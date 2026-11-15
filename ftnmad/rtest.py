#!/usr/bin/env python3
"""rtest.py file.f ... - test of the renderer alone: takes the DECLIST and
OUTLIST items of the original compiler from a trace (putrace.py), renders
them with items.render and compares with the text of the original."""
import sys, difflib
import putrace, ref, items

def check(fn, show=True):
    src = open(fn).read()
    decl, out = [], []
    for k, w1, w2 in putrace.trace(src):
        w = int(w1.replace(' ', ''), 8)
        if k.strip() == 'WRDECL':
            decl.append(w)
        elif k.strip() == 'WROUT':
            out.append(w)
    want = ref.madlen(ref.listing(src))
    d, o = items.parse_items(decl[:-1]), items.parse_items(out[:-1])
    # the variables with update routines are not in the lists: the routine
    # *Unnnn ends with XTA var, ATX *Nnnnn
    names = []
    for i, it in enumerate(o):
        if it.op == items.LABEL and it.name.startswith('*U'):
            j = i + 1
            while not (o[j].op == 0o30 and o[j].reg == 13):
                if o[j].op == 0o110:
                    v = o[j].name
                j += 1
            names.append(v)
    # undeclared variables: BSS lines that are not in DECLIST
    declared = {it.name for it in d if it.op == items.BSS}
    impl = [l.split()[0] for l in want if ', BSS ,  1' in l
            and l.split()[0] not in declared and l[1] != '*']
    unit = items.Unit(main=any('PROGRAM :' in l for l in want), update=names,
                      implicit=impl)
    got = items.render(d, o, unit)
    if got == want:
        return True
    if show:
        for l in difflib.unified_diff(want, got, 'original', 'rendered', lineterm='', n=1):
            print(l)
    return False

if __name__ == '__main__':
    for fn in sys.argv[1:]:
        print(fn, 'OK' if check(fn) else 'DIFFERENT')
