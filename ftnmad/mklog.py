#!/usr/bin/env python3
"""mklog.py seed [n] [do] [lc] - a Fortran program of n random IF statements
and logical assignments (stdout), for testing the code for logical
expressions against the original compiler (ftest.py).  With "do" some
statements are DO loops (nested, sharing terminal statements); with "lc"
there are logical constants .TRUE. and .FALSE. among the operands."""
import random
import sys

R = ['A', 'B', 'C']
I = ['I', 'J', 'K']
LG = ['F', 'G', 'H']


def arith(rnd, ints, depth=1):
    v = rnd.choice(I if ints else R)
    k = rnd.random()
    if depth == 0 or k < 0.45:
        if k < 0.08:
            return '2' if ints else '1.5'
        return v
    if k < 0.55:
        return '(' + arith(rnd, ints, 0) + ' - ' + arith(rnd, ints, 0) + ')'
    if k < 0.62:
        return '-' + v
    return arith(rnd, ints, 0) + ' ' + rnd.choice('+-*') + ' ' + arith(rnd, ints, 0)


CONSTS = False


def logical(rnd, depth):
    k = rnd.random()
    if depth == 0 or k < 0.3:
        k = rnd.random()
        if CONSTS and k < 0.15:
            return rnd.choice(['.TRUE.', '.FALSE.'])
        if k < 0.25:
            return rnd.choice(LG)
        ints = rnd.random() < 0.4
        op = rnd.choice(['EQ', 'NE', 'GT', 'LT', 'GE', 'LE'])
        s = arith(rnd, ints) + ' .' + op + '. ' + arith(rnd, ints)
        return '(' + s + ')' if rnd.random() < 0.15 else s
    if k < 0.42:
        leaf = rnd.choice(LG + ['.TRUE.', '.FALSE.'] if CONSTS else LG)
        return '.NOT. ' + leaf if rnd.random() < 0.4 else \
            '.NOT. (' + logical(rnd, depth - 1) + ')'
    if k < 0.55:
        return '(' + logical(rnd, depth - 1) + ')'
    return logical(rnd, depth - 1) + ' .' + rnd.choice(['AND', 'OR']) + '. ' \
        + logical(rnd, depth - 1)


def doparams(rnd):
    def p():
        return rnd.choice(['1', '2', '5', 'M', 'N'])
    ps = [p(), p()]
    if ps[0].isdigit() and ps[1].isdigit() and int(ps[0]) > int(ps[1]):
        ps.reverse()
    if rnd.random() < 0.3:
        ps.append(p())
    return ', '.join(ps)


def program(seed, n=30, loops=False):
    rnd = random.Random(seed)
    s = '      PROGRAM G%d\n      LOGICAL F, G, H\n' % seed
    for v in R:
        s += '      %s = 1.5\n' % v
    for v in I:
        s += '      %s = 2\n' % v
    s += '      F = A .GT. B\n      G = I .EQ. J\n      H = F .OR. G\n'
    s += '      M = 3\n      N = 4\n'
    labels = [10 * (i + 1) for i in range(n)]
    ends = []               # terminal statements of the open loops
    used = []               # and their variables
    for i in range(n):
        while ends and ends[-1] < i:
            ends.pop()
            used.pop()
        limit = ends[-1] if ends else n - 1
        terminal = i in ends
        free = [v for v in I if v not in used]
        if loops and free and not terminal and i < limit and rnd.random() < 0.25:
            end = rnd.randint(i + 1, min(limit, i + 6))
            ends.append(end)
            used.append(rnd.choice(free))
            s += '%5d DO %d %s = %s\n' % (labels[i], labels[end], used[-1], doparams(rnd))
            continue
        while True:
            k = rnd.random()
            if terminal:
                if k < 0.3:
                    st = 'CONTINUE'
                elif k < 0.6:
                    st = '%s = %s + 1.5' % (rnd.choice(R), rnd.choice(R))
                else:
                    st = 'IF (%s) A = B' % logical(rnd, 2)
            elif loops and k < 0.2:
                # no jumps from outside into a loop
                st = 'GO TO %d' % labels[rnd.randint(i, limit)] if ends else \
                    'A = A * B'
            elif k < 0.2:
                st = 'IF (%s) %d, %d, %d' % (arith(rnd, rnd.random() < 0.5),
                                            rnd.choice(labels), rnd.choice(labels),
                                            rnd.choice(labels))
            elif k < 0.4:
                st = '%s = %s' % (rnd.choice(LG), logical(rnd, 3))
            else:
                acts = ['A = B', 'F = G', 'STOP']
                if not loops:
                    acts += ['GO TO %d' % rnd.choice(labels), 'I = I + 1']
                act = rnd.choice(acts)
                st = 'IF (%s) %s' % (logical(rnd, 3), act)
            if len(st) <= 66:
                break
        s += '%5d %s\n' % (labels[i], st)
    return s + '      STOP\n      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    CONSTS = 'lc' in a[2:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 else 30, 'do' in a[2:]))
