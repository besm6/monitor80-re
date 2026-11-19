#!/usr/bin/env python3
"""mkcom.py seed [n] [const] - a random Fortran program (stdout): arrays in
COMMON (blank and named blocks, one and two dimensions) and n assignments
between random elements, without labels except DO terminals: subscripts
constant, variable (I, J, K) or c*v+k, sometimes a change of a subscript
variable, sometimes a DO loop over a few of the assignments.  With
"const" only constant subscripts (like tests/c008.f).  For testing index
registers across statements (CONTROL groups) against the original
(ftest.py)."""
import random
import sys

IV = ['I', 'J', 'K']


def program(seed, n=100, const=False):
    rnd = random.Random(seed)
    s = '      PROGRAM M%d\n' % seed
    s += '      COMMON A(100), Q\n      COMMON /CB/ B(10,10), C(20)\n'
    dims = {'A': [100], 'B': [10, 10], 'C': [20]}
    if not const:
        for v in IV:
            s += '      %s = %d\n' % (v, rnd.randint(1, 5))

    def sub(d):
        k = rnd.random()
        if const or k < 0.4:
            return str(rnd.randint(1, d))
        if k < 0.75:
            return rnd.choice(IV)
        c, v = rnd.choice([1, 2, 3]), rnd.choice(IV)
        return '%s*%s+%d' % (c, v, rnd.randint(0, 3)) if c > 1 else '%s+%d' % (v, rnd.randint(1, 4))

    def element():
        a = rnd.choice(['A', 'A', 'B', 'C'])
        return '%s(%s)' % (a, ','.join(sub(d) for d in dims[a]))

    loop = None
    lab = 0
    for i in range(n):
        k = rnd.random()
        if not const and loop is None and k < 0.05 and i < n - 3:
            lab += 10
            loop = (lab, rnd.randint(1, 4))
            s += '      DO %d %s = 1, %d\n' % (lab, rnd.choice(IV), rnd.randint(2, 5))
            continue
        if not const and k < 0.12:
            v = rnd.choice(IV)
            st = '%s = %s' % (v, rnd.choice(['1', '2', '%s + 1' % v, rnd.choice(IV)]))
        else:
            st = '%s = %s' % (element(), element() if rnd.random() < 0.7
                              else '%s + %s' % (element(), rnd.choice(['Q', '1.0', element()])))
        if loop is not None:
            loop = (loop[0], loop[1] - 1)
            if loop[1] <= 0:
                s += '%5d %s\n' % (loop[0], st)
                loop = None
                continue
        s += '      %s\n' % st
    if loop is not None:
        s += '%5d CONTINUE\n' % loop[0]
    return s + '      STOP\n      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 and a[1].isdigit() else 100,
                             'const' in a[1:]))
