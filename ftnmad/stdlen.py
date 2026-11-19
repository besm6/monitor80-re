#!/usr/bin/env python3
"""stdlen.py file.f - the lengths of the COMMON blocks of a program as the
standard lays them out (variables in order, equivalenced ones placed by
their partners), to check what the compilers (FORTR*, *FTN, *FOREX) make."""
import re, sys
from front import statements, split_top
src = open(sys.argv[1]).read()
size, blocks, eqs = {}, {}, []
for label, text, raw, echo in statements(src.splitlines()):
    if not text:
        continue
    m = re.match(r'(DIMENSION|INTEGER|REAL|LOGICAL)(.*)', text)
    if m:
        for it in split_top(m.group(2)):
            mm = re.match(r'(\w+)\((\d+)\)', it)
            if mm: size[mm.group(1)] = int(mm.group(2))
    elif text.startswith('COMMON'):
        cur = ''
        for part in re.split(r'(/\w*/)', text[6:]):
            if part.startswith('/'): cur = part[1:-1]; continue
            for it in split_top(part):
                if not it: continue
                mm = re.match(r'(\w+)(?:\((\d+)\))?', it)
                if mm.group(2): size[mm.group(1)] = int(mm.group(2))
                blocks.setdefault(cur, []).append(mm.group(1))
    elif text.startswith('EQUIVALENCE'):
        for g in split_top(text[11:]):
            items = []
            for it in split_top(g[1:-1]):
                mm = re.match(r'(\w+)(?:\((\d+)\))?', it)
                items.append((mm.group(1), int(mm.group(2) or 1) - 1))
            eqs.append(items)
pos = {}   # name -> (block, start)
for b, vs in blocks.items():
    p = 0
    for v in vs:
        pos[v] = (b, p); p += size.get(v, 1)
changed = True
while changed:
    changed = False
    for items in eqs:
        known = [(n, o) for n, o in items if n in pos]
        if not known: continue
        b, p = pos[known[0][0]]; ref = p + known[0][1]
        for n, o in items:
            if n not in pos:
                pos[n] = (b, ref - o); changed = True
for b in blocks:
    lo = min(p for n, (bb, p) in pos.items() if bb == b)
    hi = max(p + size.get(n, 1) for n, (bb, p) in pos.items() if bb == b)
    print('%s: %d (0o%o)%s' % (b or '//', hi, hi, '  STARTS BEFORE 0' if lo < 0 else ''))
