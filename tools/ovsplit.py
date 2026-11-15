#!/usr/bin/env python3
"""
ovsplit.py - cut a static overlay into modules and common blocks.

Run in the directory of the overlay OV, which holds OV.layout.py, OV.gold.bin
and OV.gold.dis (several overlays of one program share a directory):

    ovsplit.py OV be           write NAME.be (BEMSH) for every module piece
    ovsplit.py OV asm NAME     filter: DTRAN output of NAME (stdin) -> final
                               Madlen text (stdout)
    ovsplit.py OV cmp [-v] [build.lst]
                               after a build: check every module and common
                               block of OV.silver.bin against OV.gold.bin at
                               its intended address, using the load map in the
                               overlay.pl listing (one wrong length does not
                               hide everything after it); -v lists the words
    ovsplit.py OV check        byte comparison of OV.silver.bin with
                               OV.gold.bin (-> OV.cmp.out); prints GOOD when
                               only the 8-word header differs
    ovsplit.py OV map          print the layout table
    ovsplit.py OV modules      file names (without suffix) of the module pieces

OV.layout.py defines
    BASE, END   address of the overlay header, address after the last word
    LAYOUT      [(address, kind, name)] in address order, covering everything
                after the header:
                  M  a module cut from the disassembly at a call boundary
                  L  a module taken from the permanent library
                  C  a common block (`name:,LC,len`)
    LIB         {address: (module name, {offset: entry name})} for L items
    RENAME      {name in the .be: real name}: BEMSH labels are at most 6
                characters without `*`, real names appear only in Madlen
    LOW         load table of the resident monitor (lowmap.txt: name, E for an
                entry, C for a common block, address); numeric addresses of
                its routines and common blocks become names (aliases Raaaaa
                and Kaaaaa in the .be). An operand with an index register, or
                one that follows `мода X`/`мод X`, is an offset and is left
                alone; so is the operand of `уиа`, unless `счи`/`счим` of
                the same register follows within two instructions (an
                address passed to a procedure). LOWSKIP: names to leave
    ERRCALLS    addresses of the error routines: the number that `уиа` loads
                shortly before a call of one of them is an
                error number, not an address, and stays a number
    NUMBERS     addresses of words whose `уиа` loads a number although it
                looks like an address (what the rule above cannot see)
    ERRMSG      file of error messages (`code text`, see ftnerr.py): the error
                numbers found by the ERRCALLS and NUMBERS rules get a comment
                with the text in the .asm (the low 12 bits are the code)
    BASES       {module address: register} for a module that keeps its own
                address in a base register: operands indexed by it are
                offsets from the module start and stay numbers; with
                `base:R,0` in NAME.dtr DTRAN turns them into local labels
    ROOT        (sub-overlay only) OV name of the root overlay; addresses in
                the root that the listing shows as numbers become the names of
                its modules, entries and common blocks

Data that more than one module refers to is not left inside a module: it is a
common block, and its non-zero words are set by a `,DATA,` section
(`n,SET,label` / `1,,block+off`) in the module that precedes it (the one the
data belonged to).

The loader places modules and commons in the order of the external table of
the first module, so that module declares every item of LAYOUT in address
order; that pins the layout.

In a .be file a label of another module is `X extrd X`, a label inside
another module becomes its entry (`входн X`), a label inside a common block is
rewritten as `Dccccc+offset`, and the block is declared as an external; the
`asm` filter turns that SUBP into the LC. The listing does not show the filler
`мода 0` in the right half of a word after `пвл` or an extracode, and BEMSH
does not add one, so it is written out.
"""
import importlib.util
import os
import re
import sys
import textwrap

M, C, L = 'M', 'C', 'L'
SYM = re.compile(r'\b([GD])([0-7]{5})\b([+-]\d+)?(?![\d\'])')
NUM = re.compile(r"^'([0-7]+)'(\(М\d+\))?$")
ADDR = re.compile(r' ?([0-7]{4,5})[: ]')
DATA_OPS = {'конд', 'конк', 'кк', 'дк', 'пам'}
# the register of these is not an index (link or counter), the address is a target
NOIDX = {'уиа', 'пв', 'пвл', 'пио', 'пино', 'цикл'}
JUMPS = {'пб', 'пв', 'пвл', 'по', 'пе', 'пио', 'пино', 'цикл'}


class Layout:
    def __init__(self, ov):
        spec = importlib.util.spec_from_file_location('layout_' + ov, ov + '.layout.py')
        m = importlib.util.module_from_spec(spec)
        sys.dont_write_bytecode = True
        spec.loader.exec_module(m)
        self.ov = ov
        self.BASE, self.END = m.BASE, m.END
        self.STARTS = [a for a, _, _ in m.LAYOUT]
        self.ENDS = self.STARTS[1:] + [m.END]
        self.KIND = {a: k for a, k, _ in m.LAYOUT}
        self.NAME = {a: n for a, _, n in m.LAYOUT}
        self.LIB = getattr(m, 'LIB', {})
        self.RENAME = dict(getattr(m, 'RENAME', {}))
        for a, (n, e) in self.LIB.items():
            self.RENAME['G%05o' % a] = n
            for o, x in e.items():
                self.RENAME['G%05o' % (a + o)] = x
        r = getattr(m, 'ROOT', None)
        self.root = Layout(r) if r else None
        self.errcalls = set(getattr(m, 'ERRCALLS', ())) | (self.root.errcalls if self.root else set())
        self.bases = {a: '%o' % r for a, r in getattr(m, 'BASES', {}).items()}
        self.numbers = set(getattr(m, 'NUMBERS', ()))
        self.errmsg = dict(self.root.errmsg) if self.root else {}
        if getattr(m, 'ERRMSG', None):
            for l in open(m.ERRMSG, encoding='utf-8'):
                self.errmsg[int(l[:4], 8)] = l[5:].strip()
        self.low, self.lowend = {}, {}       # resident monitor: addr -> [(name, kind)]
        if getattr(m, 'LOW', None):
            skip = set(getattr(m, 'LOWSKIP', ()))
            marks = set()
            for l in open(m.LOW, encoding='utf-8'):
                for x in re.finditer(r'(\S+)\s+(?:([EC])\s+)?([0-7]{5})(?=\s|$)', l):
                    a = int(x.group(3), 8)
                    marks.add(a)
                    if x.group(1) != 'CBOБOД' and x.group(1) not in skip:
                        self.low.setdefault(a, []).append((x.group(1), x.group(2) or 'M'))
            marks = sorted(marks)
            for a in self.low:               # an item ends where the next one starts
                self.lowend[a] = next(b for b in marks if b > a)
            for a, items in self.low.items():
                for n, k in items:
                    self.RENAME[('K' if k == C else 'R') + '%05o' % a] = n

    def low_commons(self):
        return {'K%05o' % a: self.lowend[a] - a
                for a, items in self.low.items() for n, k in items if k == C}

    def item(self, a):
        p = None
        for s in self.STARTS:
            if s <= a:
                p = s
        return p if a < self.END else None

    def end(self, s):
        return self.ENDS[self.STARTS.index(s)]

    def real(self, n):
        return self.RENAME.get(n, n)

    def fname(self, s):
        return self.real(self.NAME[s]).lower().replace('*', '%')

    def commons(self):
        return {self.NAME[a]: self.end(a) - a for a in self.STARTS if self.KIND[a] == C}

    def entry_labels(self):
        """{address: label} of the entries declared in this overlay's .be files."""
        e = {}
        for s in self.STARTS:
            f = self.fname(s) + '.be'
            if self.KIND[s] != M or not os.path.exists(f):
                continue
            for l in open(f, encoding='utf-8'):
                m = re.match(r'\tвходн\t([GE]([0-7]{5}))$', l)
                if m:
                    e[int(m.group(2), 8)] = m.group(1)
        return e

    def words(self, which):
        d = open('%s.%s.bin' % (self.ov, which), 'rb').read()
        return [int.from_bytes(d[i:i + 6], 'big') for i in range(0, len(d) - 5, 6)]


def make_be(lay, dis):
    STARTS, KIND, NAME, item = lay.STARTS, lay.KIND, lay.NAME, lay.item
    body = {s: [] for s in STARTS if KIND[s] == M}   # -> [(addr, label, op, arg)]
    labels = {}                                      # address -> label in the listing
    halves = {}                                      # address -> instruction lines
    cur = None
    for l in open(dis, encoding='utf-8'):
        f = l.rstrip('\n').split('\t')
        m = ADDR.match(f[0])
        if m:
            cur = int(m.group(1), 8)
        if cur is None or cur < STARTS[0] or 'ФИНИШ' in l:
            continue
        if not m and f[0].strip() == '':
            f = ['', ''] + [x for x in f if x]       # second half of a two-line word
        if len(f) < 3:
            continue
        if f[1]:
            labels[cur] = f[1]
        s = item(cur)
        if KIND[s] != M:
            continue
        code = re.match(r'[ 0-7:]{6}[0-7]{2} [0-7]{2,3} [0-7]{4,5} ', f[0]) is not None
        body[s].append((cur, f[1], f[2], f[3] if len(f) > 3 else ''))
        if code:
            halves[cur] = halves.get(cur, 0) + 1
    g = lay.words('gold')
    for s in body:                       # the listing omits the filler `мода 0` in
        lines = []                       # the right half after пвл and extracodes
        for t in body[s]:
            lines.append(t)
            if halves.get(t[0]) == 1 and g[t[0] - lay.BASE] & 0o77777777 == 0o02200000:
                lines.append((t[0], '', 'мода', ''))
        body[s] = lines
    entries = {s: set() for s in body}
    ext = {s: {} for s in body}                      # label -> external name
    out = {}
    errs = set()                                     # (file name, error number)
    root = lay.root
    rent = root.entry_labels() if root else {}
    for s in body:
        def fix(m, s=s, op=None, arg=''):
            a = int(m.group(2), 8)       # the label
            sym, off = m.group(1) + m.group(2), m.group(3) or ''
            t = a + int(off or 0)        # the word referred to
            o = item(t)
            if o is None or item(a) is None:
                sys.exit('%s: %s is outside the image' % (NAME[s], m.group(0)))
            if op not in NOIDX and '(' in arg and KIND[o] != C and (o != s or item(a) != s):
                return "'%o'" % t        # an indexed offset that only looks like an address
            if o == s and item(a) == s:
                return (NAME[s] if a == s else sym) + off
            if KIND[o] == L:
                if t != o and t - o not in lay.LIB[o][1]:
                    sys.exit('%s: %s is not an entry of %s' % (NAME[s], m.group(0), lay.LIB[o][0]))
                ext[s]['G%05o' % t] = 1
                return 'G%05o' % t
            if KIND[o] == C:
                ext[s][NAME[o]] = NAME[o]
                return NAME[o] + ('+%d' % (t - o) if t != o else '')
            if t == o and o != s:
                ext[s][NAME[o]] = NAME[o]
                return NAME[o]
            if o == s:                   # own word reached from a foreign label
                if t == s:
                    return NAME[s]
                lab = labels.setdefault(t, 'E%05o' % t)
                return lab
            if t not in labels and op not in NOIDX:
                return "'%o'" % t        # an indexed offset that only looks like an address
            lab = labels.setdefault(t, 'E%05o' % t)   # a word inside another module
            entries[o].add((t, lab))
            ext[s][lab] = lab
            return lab

        def rootref(op, arg, s=s):
            """A number that is an address in the root overlay -> its name."""
            m = NUM.match(arg)
            if not m or op in DATA_OPS:
                return arg
            t, idx = int(m.group(1), 8), m.group(2) or ''
            o = root.item(t)
            if o is None or t < root.STARTS[0] or (idx and op not in NOIDX):
                return arg
            k = root.KIND[o]
            if k == C:
                x = root.NAME[o]
                ext[s][x] = 1
                return x + ('+%d' % (t - o) if t != o else '') + idx
            if k == L and (t == o or t - o in root.LIB[o][1]):
                x = 'G%05o' % t
            elif k == M and t == o:
                x = root.NAME[o]
            elif k == M and t in rent:
                x = rent[t]
            else:
                return arg
            ext[s][x] = 1
            return x + idx

        def errnum(i, s=s):
            """Is a register loaded at line i consumed by a call of an error routine?"""
            b = body[s]
            for _ in range(5):
                i += 1
                if i >= len(b):
                    return False
                o, r = b[i][2], b[i][3]
                m = re.match(r"(?:[GD]([0-7]{5})|'([0-7]+)')(\(М\d+\))?$", r)
                if o in ('пв', 'пвл', 'пб') and m:
                    t = int(m.group(1) or m.group(2), 8)
                    if t in lay.errcalls:
                        return True
                    if o == 'пб' and not m.group(3) and lay.item(t) == s:
                        i = next(k for k, x in enumerate(b) if x[0] == t) - 1
                        continue         # a shared tail: follow the jump
                    return False
                if o in JUMPS:
                    return False
            return False

        def lowref(op, arg, nxt, s=s):
            """A number that is an address in the resident monitor -> its name."""
            m = NUM.match(arg)
            if not m or op in DATA_OPS:
                return arg
            if op == 'уиа' and not any(o in ('счи', 'счим') and '(%s)' % r == m.group(2)
                                       for o, r in nxt):
                return arg               # уиа loads an offset, unless the register is
                                         # then pushed: an address passed to a procedure
            t, idx = int(m.group(1), 8), m.group(2) or ''
            if idx and op not in NOIDX:
                return arg
            jump = op in JUMPS
            for n, k in lay.low.get(t, ()):          # exact: a routine or a block
                if (k == C) != jump or len(lay.low[t]) == 1:
                    x = ('K' if k == C else 'R') + '%05o' % t
                    ext[s][x] = 1
                    return x + idx
            for a, items in lay.low.items():         # inside a common block
                for n, k in items:
                    if k == C and a < t < lay.lowend[a] and not jump:
                        ext[s]['K%05o' % a] = 1
                        return 'K%05o+%d' % (a, t - a) + idx
            return arg

        out[s] = []
        mod = False                      # the previous instruction is мода/мод X:
        for i, (a, lab, op, arg) in enumerate(body[s]):   # this address field is then an offset
            nxt = [t[2:] for t in body[s][i + 1:i + 3]]      # the next two instructions
            if (op == 'уиа' and (errnum(i) or a in lay.numbers)) or \
                    (op != 'уиа' and arg.endswith('(М%s)' % lay.bases.get(s))):
                new = SYM.sub(lambda m: "'%o'" % (int(m.group(2), 8) + int(m.group(3) or 0)), arg)
                mod = False              # an error number or an offset from the base
                if op == 'уиа' and NUM.match(new):
                    errs.add((lay.fname(s), int(NUM.match(new).group(1), 8)))
                out[s].append((a, lab, op, new))
                continue
            new = SYM.sub(lambda m, op=op, arg=arg: fix(m, op=op, arg=arg), arg)
            if not mod:
                if root:
                    new = rootref(op, new)
                if lay.low:
                    new = lowref(op, new, nxt)
            mod = op in ('мода', 'мод') and arg != ''
            out[s].append((a, lab, op, new))
    with open(lay.ov + '.errnum', 'w') as f:     # for the comments of make_asm
        for n, x in sorted(errs):
            f.write('%s %o\n' % (n, x))
    for s in body:                       # labels may have been added by any module
        lines, seen = [], set()
        for a, lab, op, arg in out[s]:
            if a not in seen:
                lab = '' if a == s else labels.get(a, '')
            seen.add(a)
            lines.append((lab, op, arg))
        lines[0] = (NAME[s],) + lines[0][1:]
        out[s] = lines
    for s in body:
        with open(lay.fname(s) + '.be', 'w', encoding='utf-8') as f:
            f.write('\t'.join(out[s][0]).rstrip() + '\n')
            for a, x in sorted(entries[s]):
                f.write('\tвходн\t%s\n' % x)
            for t in out[s][1:]:
                f.write('\t'.join(t).rstrip() + '\n')
            for x in sorted(ext[s], key=lambda x: (x[1:], x)):
                f.write('%s\textrd\t%s\n' % (x, x))
        print('%-12s %05o-%05o  entries: %s' % (
            lay.fname(s) + '.be', s, lay.end(s) - 1,
            ' '.join(x for _, x in sorted(entries[s])) or '-'))


def data_section(lay, c, n):
    """Madlen DATA lines that set the non-zero words of common c."""
    w = lay.words('gold')[c - lay.BASE:lay.end(c) - lay.BASE]
    runs, i = [], 0
    while i < len(w):
        if not w[i]:
            i += 1
            continue
        j = i
        while j < len(w) and (w[j] or (j + 1 < len(w) and w[j + 1])):
            j += 1                       # a single zero does not end a run
        runs.append((i, j))
        i = j
    consts, sets = [], []
    for k, (i, j) in enumerate(runs):
        lab = 'V%d/%d' % (n, k)
        for x in range(i, j):
            o = '%016o' % w[x]
            consts.append(' %s,OCT,%s' % (lab + ':' if x == i else '',
                                          ' '.join(o[y:y + 4] for y in range(0, 16, 4))))
        sets.append(' %d,SET,%s\n 1,,%s%s' % (j - i, lab, lay.NAME[c], '+%d' % i if i else ''))
    return consts + sets


def make_asm(lay, name):
    STARTS, KIND, NAME = lay.STARTS, lay.KIND, lay.NAME
    s = next(a for a in STARTS if KIND[a] == M and lay.fname(a) == name.lower())
    commons, rename = lay.commons(), dict(lay.RENAME)
    commons.update(lay.low_commons())
    if lay.root:
        commons.update(lay.root.commons())
        rename.update(lay.root.RENAME)
    src = [l.rstrip('\n') for l in sys.stdin]
    head, decl, rest = [], [], []
    for l in src:
        m = re.match(r' (\S+):,SUBP,$', l)
        if m and not rest:
            decl.append(m.group(1))
        elif not decl and not rest and ',NAME,' in l:
            head.append(l)
        else:
            rest.append(l)
    if s == STARTS[0]:
        decl = [NAME[a] for a in STARTS[1:]] + [d for d in decl if d not in NAME.values()]
    # the commons that follow this module are its data
    own, i = [], STARTS.index(s) + 1
    while i < len(STARTS) and KIND[STARTS[i]] == C:
        own.append(STARTS[i])
        i += 1
    for c in own:
        if NAME[c] not in decl:
            decl.append(NAME[c])
    data = []
    for n, c in enumerate(own):
        data += data_section(lay, c, n)
    if not rest or rest[-1].strip() != ',END,':
        sys.exit('%s: no END' % name)
    ren = re.compile(r'(?<![\w/*])(%s)(?![\w/*])' % '|'.join(rename or ['\0']))
    for l in head:
        print(ren.sub(lambda m: rename[m.group(1)], l))
    for d in decl:
        print(' %s:,LC,%d' % (rename.get(d, d), commons[d]) if d in commons
              else ' %s:,SUBP,' % rename.get(d, d))
    try:
        errs = {int(l.split()[1], 8) for l in open(lay.ov + '.errnum')
                if l.split()[0] == name.lower()}
    except OSError:
        errs = set()
    for l in rest[:-1]:
        m = re.match(r' (?:\S+:)?\d+,VTM,([0-7]+)B$', l)
        if m and int(m.group(1), 8) in errs and int(m.group(1), 8) & 0o7777 in lay.errmsg:
            n = int(m.group(1), 8)       # an error number: its message as a comment
            t = re.sub(r' {3,}\S{1,2}$', '', lay.errmsg[n & 0o7777])   # a stray letter
            for k, t in enumerate(textwrap.wrap(' '.join(t.split()), 60)):
                print('C %s %s' % (' ' * len('%o:' % n) if k else '%o:' % n, t))
        print(ren.sub(lambda m: rename[m.group(1)], l))
    if data:
        print(' ,DATA,')
        for l in data:
            print(l)
    print(' ,END,')


def compare(lay, lst, verbose):
    g, s, base = lay.words('gold'), lay.words('silver'), lay.BASE
    want = {lay.real(lay.NAME[a]): a for a in lay.STARTS}
    got = {}
    for l in open(lst, encoding='utf-8', errors='replace'):
        for m in re.finditer(r'(\S+)\s+(?:C\s+)?([0-7]{5})(?=\s|$)', l):
            if m.group(1) in want:
                got.setdefault(m.group(1), int(m.group(2), 8))
    ok = True
    for n, a in sorted(want.items(), key=lambda t: t[1]):
        if n not in got:
            print('%-9s missing from the load map' % n)
            ok = False
            continue
        bad = [i for i in range(lay.end(a) - a) if not 0 <= got[n] - base + i < len(s)
               or s[got[n] - base + i] != g[a - base + i]]
        if bad or got[n] != a:
            ok = False
            print('%-9s want %05o got %05o (%+d)  %s' % (
                n, a, got[n], got[n] - a,
                'first diff +%o (%05o), %d words' % (bad[0], a + bad[0], len(bad))
                if bad else 'same words'))
            if verbose:
                for i in bad[:16]:
                    x = s[got[n] - base + i] if 0 <= got[n] - base + i < len(s) else 0
                    print('   +%04o %05o gold %016o silver %016o' % (i, a + i, g[a - base + i], x))
    print('all %d items in place and equal' % len(want) if ok else 'DIFFERENT')
    return ok


def check(lay):
    g = open(lay.ov + '.gold.bin', 'rb').read()
    try:
        s = open(lay.ov + '.silver.bin', 'rb').read()
    except OSError:
        s = b''
    diff = [i for i in range(max(len(g), len(s)))
            if i >= len(g) or i >= len(s) or g[i] != s[i]]
    with open(lay.ov + '.cmp.out', 'w') as f:
        for i in diff:
            f.write('%d %o %o\n' % (i + 1, g[i] if i < len(g) else 0, s[i] if i < len(s) else 0))
    if not s:
        print('%s: \033[1;31mBAD (build failed)\033[22;39m' % lay.ov)
    elif diff and diff[-1] >= 48:
        print('%s: \033[1;31mBAD (%d bytes differ)\033[22;39m' % (lay.ov, len(diff)))
    else:
        print('%s: \033[1;32mGOOD (%d bytes differ in the header)\033[22;39m' % (lay.ov, len(diff)))
        return True
    return False


def main():
    a = sys.argv[1:]
    if len(a) < 2 or not os.path.exists(a[0] + '.layout.py'):
        sys.exit(__doc__)
    lay = Layout(a[0])
    a = a[1:]
    if a[0] == 'be':
        make_be(lay, a[1] if len(a) > 1 else lay.ov + '.gold.dis')
    elif a[0] == 'asm' and len(a) > 1:
        make_asm(lay, a[1])
    elif a[0] == 'cmp':
        r = [x for x in a[1:] if x != '-v']
        sys.exit(0 if compare(lay, r[0] if r else 'build.lst', '-v' in a) else 1)
    elif a[0] == 'check':
        sys.exit(0 if check(lay) else 1)
    elif a[0] == 'map':
        for s in lay.STARTS:
            print(' %05o  %05o  %6o  %s  %s' % (s, lay.end(s) - 1, lay.end(s) - s,
                                                 lay.KIND[s], lay.real(lay.NAME[s])))
    elif a[0] == 'modules':
        print(' '.join(lay.fname(s) for s in lay.STARTS if lay.KIND[s] == M))
    else:
        sys.exit(__doc__)


if __name__ == '__main__':
    main()
