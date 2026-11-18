#!/usr/bin/env python3
"""mkeqv.py seed [n] [sub] [com] [bd] - a random Fortran program (stdout) with
EQUIVALENCE and DATA: arrays and scalars, some typed, put into classes by
random groups (one constant subscript per item, never two items of one
class in a group: the original loops on that), DATA for scalars, whole
arrays, elements, with repeat counts that run over several variables,
signed integers and reals, octal, Hollerith and logical constants; then n
statements that use the variables (subscripts with variables, DO loops).
With "sub" the program is a subroutine with parameters; with "com" some
variables are in COMMON blocks (blank and named, dimensions in COMMON
too), equivalenced with others (never two classes with COMMON, never
before the start of a block: a model of the positions keeps the program
free of errors 22041 and 22014), and there are CALLs.  With "bd" it is
a BLOCK DATA instead: COMMON, EQUIVALENCE, DATA only for variables in
COMMON or equivalenced into it (all classes are), no statements.  For testing CBPRCZ/CBCE/CBBSS/CBEQU of ftnmad against the
original (ftest.py)."""
import random
import sys

ARRAYS = [('A', 10), ('B', 5), ('C', 4), ('E', 3), ('F', 6), ('KG', 4), ('H', 8)]
SCALARS = ['P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'KK', 'LL', 'MM', 'NX']
INTS = ['I', 'J', 'K', 'L']


def const(rnd, integer):
    k = rnd.random()
    if integer:
        if k < 0.2:
            return '-%d' % rnd.randint(0, 9)
        if k < 0.3:
            return '%oB' % rnd.randint(0, 0o77777)
        return str(rnd.randint(0, 99))
    if k < 0.15:
        return '-%d.%d' % (rnd.randint(0, 9), rnd.randint(0, 9))
    if k < 0.25:
        return '%d.5E%d' % (rnd.randint(1, 9), rnd.randint(-3, 3))
    if k < 0.32:
        return rnd.choice(['2HAB', '1HZ', '3HX1Y', "'OK'", '6HABCDEF'])
    if k < 0.37:
        return '+%d.25' % rnd.randint(0, 9)
    return '%d.%d' % (rnd.randint(0, 99), rnd.randint(0, 9))


def card(st):
    """a statement -> cards, continued at ', ' (not inside a Hollerith
    constant: the rest of a card up to column 72 counts as blanks)"""
    out, cur = '', '      '
    for i, w in enumerate(st.split(', ')):
        w += ', ' if i < st.count(', ') else ''
        if len(cur) + len(w) > 72:
            out += cur.rstrip() + '\n'
            cur = '     1'
        cur += w
    return out + cur.rstrip() + '\n'


def program(seed, n=20, sub=False, com=False, bd=False):
    com = com or bd
    rnd = random.Random(seed)
    arrays = rnd.sample(ARRAYS, rnd.randint(2, len(ARRAYS)))
    scalars = rnd.sample(SCALARS, rnd.randint(3, len(SCALARS)))
    size = dict(arrays)
    if bd:
        s = '      BLOCK DATA\n'
    elif sub:
        s = '      SUBROUTINE G%d(X, N, Z)\n' % seed
    else:
        s = '      PROGRAM G%d\n' % seed
    # COMMON blocks: name -> variables
    blocks, cdims = {}, set()
    if com:
        bnames = ['', 'B1', 'B2'][:rnd.randint(1, 3)]
        for v in [a for a, _ in arrays] + scalars + INTS:
            if rnd.random() < 0.35:
                blocks.setdefault(rnd.choice(bnames), []).append(v)
                if v in size and rnd.random() < 0.5:
                    cdims.add(v)
    reals = [a for a in arrays if a[0][0] not in 'IJKLMN' and a[0] not in cdims]
    ints = [a for a in arrays if a[0][0] in 'IJKLMN' and a[0] not in cdims]
    if reals:
        s += '      DIMENSION %s\n' % ', '.join('%s(%d)' % a for a in reals)
    if ints:
        s += '      INTEGER %s\n' % ', '.join('%s(%d)' % a for a in ints)
    typed = [v for v in scalars if rnd.random() < 0.3]
    if typed:
        s += '      INTEGER %s\n' % ', '.join(typed)
    st = []
    for b, vs in blocks.items():
        st.append(('/%s/ ' % b if b else '// ' if st else '')
                  + ', '.join('%s(%d)' % (v, size[v]) if v in cdims else v for v in vs))
    for i in range(0, len(st), 2):
        s += card('COMMON ' + ' '.join(st[i:i + 2]))

    # equivalence classes: union-find with the offsets of the starts of the
    # variables; a class with a variable of COMMON has block positions
    par = {}            # name -> (parent, start - start of the parent)
    base = {}           # root -> position of its start in its block
    members = {}        # root -> names
    for vs in blocks.values():
        pos = 0
        for v in vs:
            base[v] = pos
            pos += size.get(v, 1)

    def find(x):
        d = 0
        while x in par:
            x, dd = par[x]
            d += dd
        return x, d

    def root(x):
        return find(x)[0]

    def merge(x, ox, y, oy):
        """x(ox+1) and y(oy+1) at one place; False if the original would
        refuse it"""
        (rx, dx), (ry, dy) = find(x), find(y)
        delta = dy + oy - dx - ox           # start(rx) - start(ry)
        if rx == ry or rx in base and ry in base:
            return False
        if rx in base:
            rx, ry, delta = ry, rx, -delta
        mx = members.get(rx, [rx])
        if ry in base and min(base[ry] + delta + find(m)[1] for m in mx) < 0:
            return False
        par[rx] = (ry, delta)
        members[ry] = members.get(ry, [ry]) + mx
        return True

    names = [a for a, _ in arrays] + scalars
    # some subscript variables get their values by DATA, some are in
    # EQUIVALENCE (they go to the list of declared names then)
    dints = [v for v in INTS if rnd.random() < 0.3]
    eints = [v for v in INTS if v not in dints and rnd.random() < 0.2]
    for v in eints if not bd else []:
        partner = rnd.choice([x for x in scalars if x[0] in 'IJKLMN' or x in typed]
                             or [None])
        if partner and root(partner) == partner and merge(v, 0, partner, 0):
            s += '      EQUIVALENCE (%s, %s)\n' % (v, partner)
    groups = []
    known = {v for vs in blocks.values() for v in vs}   # has memory
    for _ in range(rnd.randint(1, 6)):
        k = rnd.randint(2, 3)
        items = []
        for v in rnd.sample(names, len(names)):
            if items and root(v) == root(items[0][0]):
                continue
            if bd and not items and root(v) not in base:
                # in BLOCK DATA a class outside COMMON is an error
                continue
            o = rnd.randint(1, size[v]) if v in size and rnd.random() < 0.7 else 0
            if items and not merge(items[0][0], max(items[0][1] - 1, 0), v, max(o - 1, 0)):
                continue
            items.append((v, o))
            if len(items) == k:
                break
        if len(items) < 2:
            continue
        known.update(v for v, _ in items)
        groups.append('(%s)' % ', '.join('%s(%d)' % it if it[1] else it[0] for it in items))
    for i in range(0, len(groups), 3):
        s += '      EQUIVALENCE %s\n' % ', '.join(groups[i:i + 3])
    # DATA: at most one variable of a class gets values
    given = set()
    for _ in range(rnd.randint(1, 3)):
        parts = []
        for _ in range(rnd.randint(1, 3)):
            items, total = [], 0
            for v in rnd.sample(names, rnd.randint(1, 3)):
                if root(v) in given or bd and root(v) not in base:
                    continue
                given.add(root(v))
                known.add(v)
                if v in size and rnd.random() < 0.4:
                    items.append('%s(%d)' % (v, rnd.randint(1, size[v])))
                    total += 1
                else:
                    items.append(v)
                    total += size.get(v, 1)
            if not items:
                continue
            integer = items[0][0] in 'IJKLMN' or items[0] in typed
            vals = []
            while total:
                r = rnd.randint(1, total) if rnd.random() < 0.4 else 1
                c = const(rnd, integer)
                vals.append('%d*%s' % (r, c) if r > 1 else c)
                total -= r
            parts.append('%s /%s/' % (', '.join(items), ', '.join(vals)))
        if parts:
            s += card('DATA ' + ', '.join(parts))
    if bd:
        return s + '      END\n'
    if rnd.random() < 0.3:
        s += '      LOGICAL LG\n      DATA LG /.TRUE./\n'
    if dints:
        s += card('DATA ' + ', '.join('%s /%d/' % (v, rnd.randint(1, 3)) for v in dints))
    for v in INTS:
        if v not in dints:
            s += '      %s = %d\n' % (v, rnd.randint(1, 3))
    # the other scalars get values (a variable without memory is an error)
    for v in scalars:
        if v not in known:
            s += '      %s = %s\n' % (v, '1' if v[0] in 'IJKLMN' or v in typed else '1.5')
    reals_s = [v for v in scalars if v[0] not in 'IJKLMN' and v not in typed]

    def element():
        a, d = rnd.choice(arrays)
        k = rnd.random()
        if k < 0.3:
            sub_ = str(rnd.randint(1, d))
        elif k < 0.7:
            sub_ = rnd.choice(INTS)
        else:
            sub_ = '%s+%d' % (rnd.choice(INTS), rnd.randint(0, 1))
        return '%s(%s)' % (a, sub_)

    def operand():
        k = rnd.random()
        if k < 0.5:
            return element()
        if k < 0.8 and scalars:
            return rnd.choice(scalars)
        return rnd.choice(INTS + ['1.5', '2'])

    ends = []
    called = False
    for i in range(n):
        lab = 10 * (i + 1)
        while ends and ends[-1] < lab:
            ends.pop()
        k = rnd.random()
        if k < 0.1 and not ends and i < n - 2:
            end = lab + 10 * rnd.randint(1, min(3, n - 1 - i))
            ends.append(end)
            st = 'DO %d %s = 1, %d' % (end, rnd.choice(INTS[2:]), rnd.randint(2, 3))
        elif com and k < 0.22:
            st = 'CALL SB(%s)' % ', '.join(rnd.choice([a for a, _ in arrays] + scalars + INTS)
                                         for _ in range(rnd.randint(0, 2)))
            st = st.replace('()', '')
        elif k < 0.5:
            st = '%s = %s' % (element(), ' + '.join(operand() for _ in range(rnd.randint(1, 3))))
        elif k < 0.75 and reals_s:
            st = '%s = %s * %s' % (rnd.choice(reals_s), operand(), operand())
        else:
            st = '%s = %s - %s' % (rnd.choice(scalars), operand(), operand())
        # with "com" no label after a CALL (the index registers are
        # forgotten there); elsewhere CONTROL forgets them at the ends of
        # its groups of statements, not reproduced yet: labels hide that
        if com and called and lab not in ends:
            s += '      %s\n' % st
        else:
            s += '%5d %s\n' % (lab, st)
        called = st.startswith('CALL')
    return s + ('      RETURN\n' if sub else '      STOP\n') + '      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 else 20, 'sub' in a[2:],
                             'com' in a[2:], 'bd' in a[2:]))
