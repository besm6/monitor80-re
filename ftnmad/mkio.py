#!/usr/bin/env python3
"""mkio.py seed [n] [sub] - a random Fortran program (stdout) with PRINT,
READ, WRITE (formatted and not, units constant and in variables) and
FORMAT: lists of scalars (integer, real, double precision, in COMMON),
array elements with constant and variable subscripts, whole arrays of 1-3
dimensions, nested implied DO loops (constant and variable bounds, steps);
FORMATs with Hollerith and quoted texts, some before the first executable
statement, some continued on a second card; assignments and DO loops in
between.  With "sub" it is a subroutine whose parameters (a scalar, an
array with a variable dimension) are printed too.  For testing PRINT and
FORMAT of ftnmad against the original (ftest.py)."""
import random
import sys

from mkeqv import card

ARRAYS = [('A', '5'), ('B', '3,4'), ('C', '2,3,2'), ('KA', '6')]
SCALARS = ['X', 'Y', 'K', 'L', 'M']


def fmt(rnd, label):
    """a FORMAT statement, sometimes on two cards"""
    parts = []
    for _ in range(rnd.randint(1, 5)):
        k = rnd.random()
        if k < 0.25:
            parts.append('I%d' % rnd.randint(2, 8))
        elif k < 0.5:
            parts.append('%dF%d.%d' % (rnd.randint(1, 6), rnd.randint(6, 12), rnd.randint(1, 4)))
        elif k < 0.65:
            parts.append('E12.4')
        elif k < 0.75:
            t = rnd.choice(['AB C', 'X=', 'RESULT', '(1)', 'A, B'])
            parts.append('%dH%s' % (len(t), t))
        elif k < 0.85:
            parts.append(rnd.choice(["'XY'", "'A B'", "' = '"]))
        else:
            parts.append('%dX' % rnd.randint(1, 10))
    text = 'FORMAT (%s)' % rnd.choice([', ', ',', '/', ' / ']).join(parts)
    if rnd.random() < 0.2:
        # continued: the first card ends after a comma or a slash
        cut = max(text.find(','), text.find('/'))
        if cut > 0:
            return '%5d %s\n     1    %s\n' % (label, text[:cut + 1], text[cut + 1:].lstrip())
    return '%5d %s\n' % (label, text)


def program(seed, n=12, sub=False):
    rnd = random.Random(seed)
    s = '      SUBROUTINE G%d(P, N, V)\n' % seed if sub else '      PROGRAM G%d\n' % seed
    arrays = rnd.sample(ARRAYS, rnd.randint(1, len(ARRAYS)))
    dims = {a: [int(d) for d in ds.split(',')] for a, ds in arrays}
    s += '      DIMENSION %s\n' % ', '.join('%s(%s)' % a for a in arrays)
    if sub:
        s += '      DIMENSION V(N)\n'
    dbl = rnd.random() < 0.3
    if dbl:
        s += '      DOUBLE PRECISION D, DA(3)\n'
    com = rnd.random() < 0.4
    if com:
        s += '      COMMON /CB/ Z, W(3)\n'
    labels = list(range(900, 900 + 10 * rnd.randint(1, 4), 10))
    early = [lab for lab in labels if rnd.random() < 0.4]
    for lab in early:
        s += fmt(rnd, lab)
    ints = ['K', 'L', 'M'] + (['N'] if sub else [])
    for v in SCALARS + (['D'] if dbl else []):
        s += '      %s = %s\n' % (v, '2' if v in ints else '1.5' if v != 'D' else '1.5D0')
    if com:
        s += '      Z = 2.5\n'

    def element():
        a = rnd.choice(list(dims))
        subs = []
        for d in dims[a]:
            k = rnd.random()
            subs.append(str(rnd.randint(1, d)) if k < 0.4 else rnd.choice(['K', 'L'])
                        if k < 0.8 else rnd.choice(['K', 'L']) + '+1')
        return '%s(%s)' % (a, ','.join(subs))

    def item(depth, ivs):
        k = rnd.random()
        if k < 0.25:
            return rnd.choice(SCALARS + (['D'] if dbl else []) + (['Z', 'P', 'N'] if sub and com
                                                                    else ['P', 'N'] if sub else []))
        if k < 0.45:
            return element()
        if k < 0.6:
            return rnd.choice(list(dims) + (['V'] if sub else []) + (['W'] if com else [])
                              + (['DA'] if dbl else []))
        if depth < 2:
            iv = rnd.choice([v for v in ['I', 'J', 'IJ'] if v not in ivs])
            a = rnd.choice(list(dims))
            inner = [item(depth + 1, ivs + [iv]) for _ in range(rnd.randint(0, 1))]
            inner.append('%s(%s)' % (a, ','.join(
                iv if j == 0 else str(rnd.randint(1, d)) for j, d in enumerate(dims[a]))))
            rnd.shuffle(inner)
            first = rnd.choice(['1', '2', 'K'])
            limit = str(dims[a][0]) if first != 'K' or rnd.random() < 0.5 else 'L+0'
            limit = limit.replace('+0', '')
            step = rnd.choice(['', '', ', 2'])
            return '(%s, %s = %s, %s%s)' % (', '.join(inner), iv, first, limit, step)
        return element()

    for i in range(n):
        lab = 10 * (i + 1)
        k = rnd.random()
        if k < 0.6:
            lst = ', '.join(item(0, []) for _ in range(rnd.randint(0, 4)))
            k2 = rnd.random()
            lab_ = rnd.choice(labels)
            head = 'PRINT %d' % lab_ if k2 < 0.3 else 'READ %d' % lab_ if k2 < 0.4 else \
                '%s (%s, %d)' % (rnd.choice(['READ', 'WRITE']),
                                  rnd.choice(['5', '6', 'K', 'N' if sub else 'M']), lab_) \
                if k2 < 0.8 else '%s (%s)' % (rnd.choice(['READ', 'WRITE']),
                                               rnd.choice(['5', 'L']))
            st = head + (', ' + lst if lst and '(' not in head else
                         ' ' + lst if lst else '')
        elif k < 0.8:
            st = '%s = %s' % (element(), rnd.choice(['X', 'Y + 1.0', '2.5']))
        else:
            st = '%s = %s' % (rnd.choice(['K', 'L', 'M']), rnd.choice(['1', '2', 'K + 1', 'M']))
        s += '%5d' % lab + card(st)[5:]
        if rnd.random() < 0.15:
            late = [lab_ for lab_ in labels if lab_ not in early]
            if late:
                lb = late[0]
                early.append(lb)
                s += fmt(rnd, lb)
    for lab in labels:
        if lab not in early:
            s += fmt(rnd, lab)
    return s + ('      RETURN\n' if sub else '      STOP\n') + '      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 and a[1].isdigit() else 12,
                             'sub' in a[1:]))
