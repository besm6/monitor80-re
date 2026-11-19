#!/usr/bin/env python3
"""errtrace.py file.f - where the original compiler finds the errors of a
program: runs it in dubna and, for every call of ERRPRINT (the error
number in the accumulator), prints the number, the statement (count of
PUTAWAY items 072 so far) and the words executed just before, as
addresses of volume 2048 with the module they are in: for the root
(below 035064) one, for the overlays at 035064 (CONTROL, CBDPR, ENDPRO,
GLINK) a candidate from each.  Dubna loads the root 0253 and the
overlays 0274 words lower than they are on volume 2048."""
import os
import re
import sys

import calls
import trace

ERRPRINT = 0o34320
FORTRAN = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'fortran')


def layouts():
    """overlay -> [(start, module)] from fortran/*.layout.py"""
    out = {}
    for fn in sorted(os.listdir(FORTRAN)):
        if fn.endswith('.layout.py'):
            text = open(os.path.join(FORTRAN, fn)).read()
            names = dict(re.findall(r"'G([0-7]{5})': '([^']+)'", text))
            # every module of the layout, by its name or its address
            mods = {a: names.get(a, 'G' + a) for a in re.findall(r"\(0o([0-7]{5}), M, 'G", text)}
            mods.update(names)
            out[fn.split('.')[0]] = sorted((int(a, 8), n) for a, n in mods.items())
    return out


def where(a, lay):
    """a dubna address -> 'volume-address module+offset ...'"""
    v = a - trace.SHIFT if a < 0o35064 + trace.SHIFT else a + 0o274
    names = []
    for ov, mods in lay.items():
        if (ov == 'fortr') != (v < 0o35064):
            continue
        best = [m for m in mods if m[0] <= v]
        if best:
            s, n = best[-1]
            names.append('%s:%s+%o' % (ov, n, v - s))
    return '%05o %s' % (v, ' '.join(names))


def main(fn):
    lay = layouts()
    nst = 0
    for a, st in trace.run(open(fn).read(), [calls.PUT, ERRPRINT + trace.SHIFT]):
        if a == calls.PUT:
            if st.acc == 0o72:
                nst += 1
            continue
        print('%05o  statement %d' % (st.acc, nst))
        for p in st.path[-6:-1]:
            print('    ' + where(p, lay))


if __name__ == '__main__':
    main(sys.argv[1])
