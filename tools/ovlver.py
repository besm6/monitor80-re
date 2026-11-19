#!/usr/bin/env python3
"""Compare a split overlay with another version of it, module by module.

    ovlver.py OV OTHER.bin [-v]

Run in the directory of OV (OV.layout.py, OV.gold.bin). OTHER.bin is an
image of the other version (6 bytes a word, first word = header word 0, as
made by ovlcat.py or ovl2bin). Every module and common block of the layout
is looked for in OTHER.bin by the opcodes of its instructions (ovlsame.py
signatures), its most frequent shift taken, and its words compared after
relocation: a half-word (or the low 15 bits of a data word) counts as equal
when its address in OTHER is the address in OV moved by the shift of the item
it points into (the items of the root layout too, for a sub-overlay: pass
the root's OTHER image with -r ROOT_OTHER.bin). An item not found (a common
block of zeros) takes the shift of its neighbours when both have the same
one (marked ?). Addresses in the resident monitor (below both overlays) are
not compared but listed at the end, ours -> OTHER, with their names from the
layout's LOW map. The shift of an item that the references to it
disagree with is taken from them (marked !): a work area of the root may
lie elsewhere in OTHER, even outside its image.

Prints, per item, the place in OTHER, the shift and the number of words that
differ; -v lists those words. Used to compare FORTR* of volume 2048 with
FORTRAN of the Dubna installation tape (monsys.9), fortran/monsys9/.
"""
import collections
import importlib.util
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('ovsplit', os.path.join(
    os.path.dirname(os.path.abspath(__file__)), 'ovsplit.py'))
ovsplit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ovsplit)

K = 6


def words(f):
    d = open(f, 'rb').read()
    return [int.from_bytes(d[i:i + 6], 'big') for i in range(0, len(d) - 5, 6)]


def long_fmt(h):
    return bool(h & 0o2000000)


def sig(w):
    def half(x):
        return x & (0o77700000 if long_fmt(x) else 0o77770000)
    return half(w >> 24), half(w & 0o77777777)


def addr(h):
    """the address field of instruction h (short format: offset plus S)"""
    if long_fmt(h):
        return h & 0o77777
    return (h & 0o7777) | (0o70000 if h & 0o1000000 else 0)


class Version:
    """an overlay of ours (layout + gold image) and its image in OTHER"""

    def __init__(self, lay, other, root=None):
        self.lay, self.root = lay, root
        self.a = lay.words('gold')
        self.b = words(other)
        self.ba = lay.BASE
        self.bb = self.b[2] & 0o77777
        sb = [sig(w) for w in self.b]
        self.idx = collections.defaultdict(list)
        for i in range(len(sb) - K):
            self.idx[tuple(sb[i:i + K])].append(i)
        self.shift = {}
        for s in lay.STARTS:
            self.shift[s] = self.find(s)
        self.guessed = set()
        st = lay.STARTS
        for k, s in enumerate(st):
            # an item not found (a common block of zeros) between two with
            # the same shift has that shift too
            if self.shift[s] is None:
                p = next((self.shift[t] for t in reversed(st[:k]) if self.shift[t] is not None), None)
                n = next((self.shift[t] for t in st[k + 1:] if self.shift[t] is not None), None)
                if p is not None and p == n:
                    self.shift[s] = p
                    self.guessed.add(s)
        self.low = collections.Counter()    # (ours, other) resident addresses that differ
        lowest = root.ba if root else self.ba
        self.lowest = min(lowest, self.bb if not root else root.bb)
        self.shift[None] = self.bb - self.ba     # the header
        self.learned = set()
        self.amap = {}                      # address -> its place in OTHER (learn)

    def owner(self, x):
        """(the Version, the item) that address x of ours is in, or None"""
        v = self.root if self.root and x < self.ba else self
        if v.ba + 8 <= x < v.lay.END:
            return v, v.lay.item(x)
        return None

    def learn(self):
        """the shift of an item from the references to it: where the
        opcodes of both versions agree but the addresses do not, the
        difference votes for the item pointed to; the most frequent one
        replaces a shift that fewer references agree with"""
        votes = collections.defaultdict(collections.Counter)
        at = collections.defaultdict(collections.Counter)
        for s in self.lay.STARTS:
            d = self.shift[s]
            if d is None or self.lay.KIND[s] == 'C':
                continue
            for x in range(s, self.lay.end(s)):
                j = x + d - self.bb
                if not 0 <= j < len(self.b):
                    continue
                wa, wb = self.a[x - self.ba], self.b[j]
                for ha, hb in ((wa >> 24, wb >> 24), (wa & 0o77777777, wb & 0o77777777)):
                    if ha == hb or sig(ha << 24)[0] != sig(hb << 24)[0]:
                        continue
                    xa, xb = addr(ha), addr(hb)
                    o = self.owner(xa)
                    if o:
                        votes[o][xb - xa] += 1
                        at[o[0], xa][xb] += 1
        for (v, t), c in votes.items():
            (d, n), = c.most_common(1)
            if n >= 2 and d != v.shift[t] and n > c[v.shift[t]] + v.agree(t):
                v.shift[t] = d
                v.guessed.discard(t)
                v.learned.add(t)
        for (v, xa), c in at.items():
            (xb, n), = c.most_common(1)
            if v.moved(xa) != xb and 2 * n > sum(c.values()):
                v.amap[xa] = xb             # this address has its own place

    def agree(self, t):
        """the references to item t that its shift explains: none known
        here, so 0 (the votes of learn() decide)"""
        return 0

    def find(self, s):
        """the most frequent shift of the K-word runs of item s"""
        votes = collections.Counter()
        lo, hi = s - self.ba, self.lay.end(s) - self.ba
        for i in range(lo, max(lo + 1, hi - K + 1)):
            k = tuple(sig(w) for w in self.a[i:i + K])
            if len(k) < K or len(set(k)) < 3:
                continue
            for j in self.idx.get(k, ()):
                votes[j + self.bb - i - self.ba] += 1
        if not votes:
            # a short item: whatever shift the neighbours have
            return None
        return votes.most_common(1)[0][0]

    def moved(self, x):
        """address x of ours -> the address it has in OTHER, or None"""
        if x < 0o1760 and (self.root is None or x < self.root.ba):
            return x                                    # resident monitor
        v = self
        if self.root and x < self.ba:
            v = self.root
        if x in v.amap:
            return v.amap[x]
        if not v.ba <= x < v.lay.END:
            return None
        if x < v.ba + 8:
            return x + v.bb - v.ba
        d = v.shift.get(v.lay.item(x))
        return None if d is None else x + d

    def same_addr(self, xa, xb, bits):
        m = (1 << bits) - 1
        if xa == xb:
            return True
        if 0o400 <= xa < self.lowest and 0o400 <= xb < self.lowest:
            self.low[xa, xb] += 1           # both in the resident monitor
            return True
        y = self.moved(xa)
        return y is not None and (y & m) == xb

    def same_half(self, ha, hb):
        if ha == hb:
            return True
        if sig(ha << 24)[0] != sig(hb << 24)[0]:
            return False
        return self.same_addr(addr(ha), addr(hb), 15)

    def same(self, wa, wb):
        if wa == wb:
            return True
        if wa >> 15 == wb >> 15 and self.same_addr(wa & 0o77777, wb & 0o77777, 15):
            return True                                 # an address constant
        return self.same_half(wa >> 24, wb >> 24) and \
            self.same_half(wa & 0o77777777, wb & 0o77777777)

    def compare(self, s):
        d = self.shift[s]
        lo, hi = s, self.lay.end(s)
        if d is None:
            return None, []
        if not 0 <= lo + d - self.bb and hi + d - self.bb <= len(self.b) \
                or lo + d < self.bb:
            return d, None                              # outside the image
        diff = []
        for x in range(lo, hi):
            j = x + d - self.bb
            wa = self.a[x - self.ba]
            wb = self.b[j] if 0 <= j < len(self.b) else None
            if wb is None or not self.same(wa, wb):
                diff.append((x, wa, wb))
        return d, diff


def main():
    a = sys.argv[1:]
    verbose = '-v' in a
    a = [x for x in a if x != '-v']
    rootimg = None
    if '-r' in a:
        k = a.index('-r')
        rootimg = a[k + 1]
        del a[k:k + 2]
    if len(a) != 2:
        sys.exit(__doc__)
    lay = ovsplit.Layout(a[0])
    root = None
    if lay.root:
        if not rootimg:
            sys.exit('%s is a sub-overlay of %s: give its other image with -r' % (a[0], lay.root.ov))
        root = Version(lay.root, rootimg)
        root.learn()
    v = Version(lay, a[1], root)
    v.learn()
    print('%s: ours %05o-%05o, other %05o-%05o' % (a[0], v.ba, lay.END, v.bb, v.bb + len(v.b)))
    total = 0
    for s in lay.STARTS:
        d, diff = v.compare(s)
        n = lay.end(s) - s
        name = lay.real(lay.NAME[s])
        if d is None:
            print('  %05o %-4o %s %-10s not found' % (s, n, lay.KIND[s], name))
            continue
        mark = '?' if s in v.guessed else '!' if s in v.learned else ' '
        if diff is None:
            print('  %05o %-4o %s %-10s -> %05o (%+o)%s  outside the image' % (
                s, n, lay.KIND[s], name, s + d, d, mark))
            continue
        total += len(diff)
        print('  %05o %-4o %s %-10s -> %05o (%+o)%s  %s' % (
            s, n, lay.KIND[s], name, s + d, d, mark,
            '%d differ' % len(diff) if diff else 'same'))
        if verbose:
            for x, wa, wb in diff:
                print('      %05o %016o  %s' % (x, wa, '%016o' % wb if wb is not None else '-'))
    print('total %d words differ' % total)
    for w in ([root] if root else []) + [v]:
        if w.amap:
            print('addresses of %s placed by the references to them (ours -> other):' % w.lay.ov)
            line = ''
            for xa, xb in sorted(w.amap.items()):
                line += '  %05o->%05o' % (xa, xb)
                if len(line) > 64:
                    print(line)
                    line = ''
            if line:
                print(line)
    if v.low:
        names = {}
        for a_, items in (lay.root or lay).low.items():
            names[a_] = '/'.join(n for n, k in items)
        print('resident monitor addresses (ours -> other, uses):')
        for (xa, xb), c in sorted(v.low.items()):
            print('  %05o -> %05o  %3d  %s' % (xa, xb, c, names.get(xa, '')))


if __name__ == '__main__':
    main()
