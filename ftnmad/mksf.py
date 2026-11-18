#!/usr/bin/env python3
"""mksf.py seed [n] [sub] - a random Fortran program (stdout) with statement
functions: some real and integer functions of 1-3 dummies (named like
variables of the program, which then shadow them), bodies with arithmetic
on the dummies, the variables of the program, standard functions and the
functions defined before; then n assignments, IFs and CALLs that call them
with expressions as arguments.  With "sub" it is a subroutine with
parameters (used in the bodies too).  For testing the statement functions
of ftnmad against the original (ftest.py)."""
import random
import sys

import mkexpr
from mkeqv import card

DUMMIES = ['X', 'Y', 'Z', 'I', 'J', 'U']
VARS_R = ['A', 'B', 'C']
VARS_I = ['K', 'L', 'I']     # I: mkexpr uses it in exponents


def program(seed, n=15, sub=False):
    rnd = random.Random(seed)
    s = '      SUBROUTINE G%d(P, N)\n' % seed if sub else '      PROGRAM G%d\n' % seed
    names = rnd.sample(['F', 'G', 'H', 'Q', 'KF', 'MF', 'W', 'V'], rnd.randint(1, 5))
    typed = [f for f in names if rnd.random() < 0.2]
    if typed:
        s += '      INTEGER %s\n' % ', '.join(typed)
    if rnd.random() < 0.3:
        s += '      COMMON /CB/ B\n'
    funcs = []          # (name, number of dummies, integer)
    for f in names:
        ds = rnd.sample(DUMMIES, rnd.randint(1, 3))
        ints = f[0] in 'IJKLMN' or f in typed
        mkexpr.R = [d for d in ds if d[0] not in 'IJKLMN'] + VARS_R[:rnd.randint(0, 2)] \
            + (['P'] if sub else [])
        mkexpr.I = [d for d in ds if d[0] in 'IJKLMN'] + VARS_I[:rnd.randint(0, 1)] \
            + (['N'] if sub else [])
        if not mkexpr.R:
            mkexpr.R = ['1.5']
        if not mkexpr.I:
            mkexpr.I = ['2']
        body = mkexpr.expr(rnd, rnd.randint(1, 3), ints)
        if funcs and rnd.random() < 0.5:
            g, k, gi = rnd.choice(funcs)
            args = [mkexpr.expr(rnd, 1, gi) for _ in range(k)]
            body += ' + %s(%s)' % (g, ', '.join(args))
        s += card('%s(%s) = %s' % (f, ', '.join(ds), body))
        funcs.append((f, len(ds), ints))
    for v in VARS_R + VARS_I:
        s += '      %s = %s\n' % (v, '2' if v[0] in 'IJKLMN' else '1.5')
    mkexpr.R, mkexpr.I = VARS_R + (['P'] if sub else []), VARS_I + (['N'] if sub else [])

    def call():
        g, k, gi = rnd.choice(funcs)
        # a dummy of a statement function takes any type of argument; keep
        # the types of the dummies' first letters for clean arithmetic
        return '%s(%s)' % (g, ', '.join(mkexpr.expr(rnd, rnd.randint(0, 2), False)
                                        for _ in range(k)))
    for i in range(n):
        lab = 10 * (i + 1)
        k = rnd.random()
        if k < 0.15:
            st = 'IF (%s .GT. %s) %s = %s' % (call(), mkexpr.expr(rnd, 1, False),
                                             rnd.choice(VARS_R), call())
        elif k < 0.25:
            st = 'CALL SB(%s, %s)' % (call(), rnd.choice(VARS_R))
        else:
            v = rnd.choice(VARS_R + VARS_I)
            st = '%s = %s %s %s' % (v, call(), rnd.choice('+-*'),
                                    mkexpr.expr(rnd, 1, v[0] in 'IJKLMN'))
        s += '%5d' % lab + card(st)[5:]
    return s + ('      RETURN\n' if sub else '      STOP\n') + '      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 and a[1].isdigit() else 15,
                             'sub' in a[1:]))
