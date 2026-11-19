#!/usr/bin/env python3
"""unlabel.py file.f... - remove the labels that no statement refers to
(DO, GO TO, IF, ASSIGN, READ/WRITE/PRINT formats keep theirs) from Fortran
programs, in place.  The random generators label almost every statement,
and a label ends a group of statements of CONTROL; without them the
grouping (and the lifetime of index registers) is exercised."""
import re
import sys


def unlabel(src):
    lines = src.splitlines(True)
    used = set()
    for l in lines:
        if l[:1] in 'C*' or len(l) < 7:
            continue
        body = l[6:72].replace(' ', '').upper()
        for m in re.finditer(r'DO(\d+)|GOTO(\d+)|ASSIGN(\d+)|\)(\d+)$', body):
            used.update(g for g in m.groups() if g)
        for m in re.finditer(r'GOTO\(([\d,]+)\)|(?:PRINT|READ)(\d+)|\(\w+,(\d+)\)', body):
            for g in m.groups():
                if g:
                    used.update(g.split(','))
        if body.startswith('IF('):
            used.update(re.findall(r'(?<=[,)])(\d+)(?=,|$)', body.split(')', 1)[-1]))
    out = []
    for l in lines:
        lab = l[:5].strip()
        if lab.isdigit() and l[5:6] in (' ', '0') and str(int(lab)) not in used \
                and not l[6:].lstrip().upper().startswith('FORMAT'):
            l = '     ' + l[5:]
        out.append(l)
    return ''.join(out)


if __name__ == '__main__':
    for fn in sys.argv[1:]:
        with open(fn) as f:
            s = f.read()
        with open(fn, 'w') as f:
            f.write(unlabel(s))
