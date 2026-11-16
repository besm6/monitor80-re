#!/usr/bin/env python3
"""atest.py file.f ... - test of arith.py against the original: every call
of ARITHEXP seen in a trace of the dubna simulator is repeated on the
same tokens, the tables of subexpressions are compared."""
import sys
import trace
from arith import Arith, Abort

S = trace.SHIFT
SC = -0o274                     # the shift of the overlay CONTROL
ARITHEXP = 0o41174 + SC
EXPGEN = 0o46107 + SC
D33143 = 0o33143 + S
TABLE = 0o10170 + S + 4600


def show(words):
    return ' '.join('%o' % w for w in words)


def test(fn, verbose):
    bad = n = 0
    pend = None
    for a, st in trace.run(open(fn).read(), [ARITHEXP, EXPGEN]):
        if a == ARITHEXP:
            start, end = st.acc & 0o77777, st.mem[st.m[15] - 1] & 0o77777
            m = trace.Mem(st.mem)
            toks = [m[p] for p in range(start, end + 1)]
            ar = Arith(m, TABLE)
            try:
                last = ar.run(start, end)
                pend = [m[p] for p in range(TABLE, last + 1)]
            except Abort:
                pend = None
            except Exception as e:
                pend = ['%s' % e]
            src = toks
        elif pend is not None:
            n += 1
            lo, hi = st.mem[D33143 + 218], st.mem[D33143 + 219]
            ref = [st.mem[p] for p in range(lo, hi + 1)]
            if ref != pend or lo != TABLE:
                bad += 1
                print('%s: tokens %s\n  orig %s\n  mine %s'
                      % (fn, show(src), show(ref), pend if isinstance(pend[0], str) else show(pend)))
            elif verbose:
                print('%s\n  -> %s' % (show(src), show(ref)))
            pend = None
    print('%s: %d expressions, %d differ' % (fn, n, bad))
    return bad


if __name__ == '__main__':
    a = sys.argv[1:]
    v = a and a[0] == '-v'
    sys.exit(1 if sum(test(f, v) for f in a[v:]) else 0)
