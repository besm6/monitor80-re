#!/usr/bin/env python3
"""mkexpr.py seed [n] - a Fortran program of n random arithmetic
assignments (stdout), for testing the expression code against the
original compiler (atest.py, etest.py)."""
import random
import sys

R = ['A', 'B', 'C', 'D']
I = ['I', 'J', 'K']


def expr(rnd, depth, ints):
    k = rnd.random()
    if depth <= 0 or k < 0.3:
        k = rnd.random()
        if k < 0.12:
            return rnd.choice(['2', '3', '7']) if ints or rnd.random() < 0.3 \
                else rnd.choice(['2.0', '0.5', '1.5'])
        if ints or k < 0.3:
            return rnd.choice(I)
        return rnd.choice(R)
    if k < 0.4:
        return '(' + expr(rnd, depth - 1, ints) + ')'
    if k < 0.47:
        return '-' + expr(rnd, depth - 1, ints) if depth == 3 else \
            '(-' + expr(rnd, depth - 1, ints) + ')'
    if k < 0.55 and not ints:
        f = rnd.choice(['SQRT', 'SIN', 'ABS', 'AMAX1'])
        a = expr(rnd, depth - 1, False)
        if f == 'AMAX1':
            a += ', ' + expr(rnd, depth - 1, False)
        return f + '(' + a + ')'
    if k < 0.63:
        b = expr(rnd, 0, ints)
        if rnd.random() < 0.4:
            b = '(' + expr(rnd, depth - 1, ints) + ')'
        e = rnd.choice(['2', '3', '4', '5', '8', '9', 'I', 'B', '(I + 1)'])
        return b + '**' + e
    op = rnd.choice(['+', '-', '*', '/', '+', '*'])
    return expr(rnd, depth - 1, ints) + ' ' + op + ' ' + expr(rnd, depth - 1, ints)


def program(seed, n=40):
    rnd = random.Random(seed)
    s = '      PROGRAM F%d\n' % seed
    for v in R:
        s += '      %s = 1.5\n' % v
    for v in I:
        s += '      %s = 2\n' % v
    for i in range(n):
        ints = rnd.random() < 0.25
        e = expr(rnd, 3, ints)
        lhs = rnd.choice(['X', 'Y', 'L', 'M'])
        st = '      %s = %s' % (lhs, e)
        while len(st) > 72:
            e = expr(rnd, 2, ints)
            st = '      %s = %s' % (lhs, e)
        s += st + '\n'
    return s + '      STOP\n      END\n'


if __name__ == '__main__':
    sys.stdout.write(program(int(sys.argv[1]), int(sys.argv[2]) if len(sys.argv) > 2 else 40))
