#!/usr/bin/env python3
"""etest.py file.f ... - test of expgen.py against the original: on every
entry of G46107 seen in a trace of the dubna simulator the generation is
repeated from the same table, the calls of PUTAWAY are compared."""
import sys
import trace
import gen
import expgen
from calls import OPS, operand

S = trace.SHIFT
SC = -0o274                     # the shift of the overlay CONTROL
EXPGEN = 0o46107 + SC
EXIT = EXPGEN + 0o314
PUT = 0o4407 + S
D33143 = 0o33143 + S
gen.relocate(S)
expgen.relocate(S)


def text(w1, w2, mem):
    op = w2 & 0o77777
    return '%s%s %s' % (OPS.get(op, '%o' % op), '{%o}' % (w2 >> 15) if w2 >> 15 else '',
                        operand(w1, mem))


def test(fn, verbose):
    bad = n = 0
    mine = None
    for a, st in trace.run(open(fn).read(), [EXPGEN, EXIT, PUT]):
        if a == EXPGEN:
            m = trace.Mem(st.mem)
            mode = m[gen.D34621 + 73]
            g = gen.Gen(m)
            m[gen.D34621 + 73] = mode
            mine = []

            def put(w1, w2, g=g, mine=mine):
                mine.append((w1, w2))
                return g.put(w1, w2)
            lo, hi = m[D33143 + 218], m[D33143 + 219]
            tab = ' '.join('%o' % m[p] for p in range(lo, hi + 1))
            err = None
            try:
                expgen.ExpGen(m, put).run(lo, hi)
            except Exception as e:
                import traceback
                err = traceback.format_exc()
            orig = []
            mem = st.mem
        elif a == PUT and mine is not None:
            orig.append((st.mem[st.m[15] - 1], st.acc))
        elif a == EXIT and mine is not None:
            n += 1
            if orig != mine or err:
                bad += 1
                print('%s: table %s' % (fn, tab))
                print('  orig: ' + ' ; '.join(text(w1, w2, mem) for w1, w2 in orig))
                print('  mine: ' + ' ; '.join(text(w1, w2, mem) for w1, w2 in mine))
                if err:
                    print(err)
            elif verbose:
                print(' ; '.join(text(w1, w2, mem) for w1, w2 in orig))
            mine = None
    print('%s: %d expressions, %d differ' % (fn, n, bad))
    return bad


if __name__ == '__main__':
    a = sys.argv[1:]
    v = a and a[0] == '-v'
    sys.exit(1 if sum(test(f, v) for f in a[v:]) else 0)
