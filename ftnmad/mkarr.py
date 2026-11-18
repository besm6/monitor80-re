#!/usr/bin/env python3
"""mkarr.py seed [n] [sub|vd] - a Fortran program of n random statements
with arrays (stdout): standard subscripts (c*v+k), non-standard ones, DO
loops with and without step 1, integer assignments that change the
subscript variables.  With "sub" the program is a subroutine whose
parameters appear in subscripts too; with "vd" also with parameter arrays
of variable dimensions D(M,N), E(M,N,3), G(M,2,N), H(2,M,3) (standard
subscripts only).  For testing the subscript code (IFLIST, N*STnn, index
update routines, *K/*M cells) against the original (ftest.py)."""
import random
import sys

ARRAYS = [('A', [10]), ('B', [5, 4]), ('C', [3, 3, 3]), ('KA', [8]), ('D', [4, 6])]
VDARRAYS = [('VD', ['M', 'N']), ('VE', ['M', 'N', 3]), ('VG', ['M', 2, 'N']),
            ('VH', [2, 'M', 3])]
VD = False
INTS = ['I', 'J', 'K', 'L', 'MM']
REALS = ['X', 'Y', 'Z']


def subscript(rnd, d, ints, std=False):
    v = rnd.choice(ints)
    k = rnd.random() * (0.8 if std else 1)
    if not isinstance(d, int):
        d = 3
    if k < 0.15:
        return str(rnd.randint(1, d))
    if k < 0.4:
        return v
    if k < 0.55:
        return '%s+%d' % (v, rnd.randint(0, 2))
    if k < 0.65:
        return '%s-%d' % (v, rnd.randint(0, 2))
    if k < 0.8:
        return '%d*%s%s' % (rnd.randint(1, 3), v, rnd.choice(['', '+1', '-1', '-2']))
    # non-standard
    w = rnd.choice(ints)
    return rnd.choice(['%s+%s' % (v, w), '%s*2' % v, '%s-%s+1' % (v, w), '%s*%s' % (v, w),
                       '1+%s' % v, '-%s+3' % v, 'KA(%s)' % v, 'KA(%s+1)-1' % v])


def element(rnd, ints, real=True):
    names = [a for a in ARRAYS if (a[0] != 'KA') == real or rnd.random() < 0.2]
    if VD and real and rnd.random() < 0.5:
        names = VDARRAYS
    name, dims = rnd.choice(names)
    std = name.startswith('V') and rnd.random() < 0.8
    return '%s(%s)' % (name, ','.join(subscript(rnd, d, ints, std) for d in dims))


def operand(rnd, ints):
    k = rnd.random()
    if k < 0.55:
        return element(rnd, ints)
    if k < 0.75:
        return rnd.choice(REALS)
    if k < 0.85:
        return '1.5'
    return rnd.choice(ints)


def expr(rnd, ints):
    s = operand(rnd, ints)
    for _ in range(rnd.randint(0, 2)):
        s += ' %s %s' % (rnd.choice('+-*'), operand(rnd, ints))
    return s


def program(seed, n=40, sub=False, vd=False):
    global VD
    VD = vd
    rnd = random.Random(seed)
    ints = list(INTS)
    if vd:
        s = '      SUBROUTINE G%d(VD, M, N, VE, VG, VH, X)\n' % seed
        s += '      DIMENSION VD(M,N), VE(M,N,3), VG(M,2,N), VH(2,M,3)\n'
        ints += ['N']
    elif sub:
        s = '      SUBROUTINE G%d(N, NN, X)\n' % seed
        ints += ['N', 'NN']
    else:
        s = '      PROGRAM G%d\n' % seed
    s += '      DIMENSION %s\n' % ', '.join('%s(%s)' % (a, ','.join(map(str, d)))
                                         for a, d in ARRAYS if a != 'KA')
    s += '      INTEGER KA(8)\n'
    for v in INTS:
        s += '      %s = %d\n' % (v, rnd.randint(1, 3))
    for v in REALS[sub:]:
        s += '      %s = 1.5\n' % v
    ends = []
    used = []
    labels = [10 * (i + 1) for i in range(n)]
    for i in range(n):
        while ends and ends[-1] < i:
            ends.pop()
            used.pop()
        limit = ends[-1] if ends else n - 1
        free = [v for v in INTS if v not in used]
        terminal = i in ends
        if free and not terminal and i < limit and rnd.random() < 0.2:
            end = rnd.randint(i + 1, min(limit, i + 5))
            ends.append(end)
            used.append(rnd.choice(free))
            par = rnd.choice(['1, 3', '1, MM', '2, 4', 'J, 3', '1, 4, 2', '1, 3, 1'])
            s += '%5d DO %d %s = %s\n' % (labels[i], labels[end], used[-1], par)
            continue
        while True:
            k = rnd.random()
            loose = [v for v in INTS if v not in used]
            if k < 0.15 and loose:
                st = '%s = %s %s %d' % (rnd.choice(loose), rnd.choice(ints),
                                        rnd.choice('+-'), rnd.randint(1, 2))
            elif k < 0.25:
                st = '%s = %s' % (element(rnd, ints, False), rnd.choice(ints + ['2']))
            elif k < 0.35:
                st = '%s = %s' % (rnd.choice(REALS), expr(rnd, ints))
            elif k < 0.4 and loose:
                st = '%s = %s' % (rnd.choice(loose), element(rnd, ints, False))
            elif k < 0.47:
                st = 'IF (%s .%s. %s) %s = %s' % (element(rnd, ints), rnd.choice(['GT', 'LE', 'NE']),
                                                 operand(rnd, ints), element(rnd, ints),
                                                 operand(rnd, ints))
            elif k < 0.52:
                st = 'CALL S(%s, %s, %s)' % (rnd.choice('ABCD'), element(rnd, ints),
                                             rnd.choice(INTS))
            elif k < 0.57:
                st = '%s = SQRT(%s) + ABS(%s)' % (element(rnd, ints), element(rnd, ints),
                                                  operand(rnd, ints))
            else:
                st = '%s = %s' % (element(rnd, ints), expr(rnd, ints))
            if len(st) <= 64:
                break
        s += '%5d %s\n' % (labels[i], st)
    return s + ('      RETURN\n' if sub else '      STOP\n') + '      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    mode = a[2] if len(a) > 2 else ''
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 else 40, mode == 'sub',
                             mode == 'vd'))
