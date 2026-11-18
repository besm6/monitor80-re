#!/usr/bin/env python3
"""iftrace.py [-s OP] [-l] file.f ... - the tables of subscripts of the
original compiler, from a dubna trace (see gtest.py): IFLIST (the linear
forms of the subscripts, one word per term: k<<45 | n<<30 | coef<<15 | ptr
in the first word of a form, then coef<<15 | ptr; for arrays with variable
dimensions a form of four words), the list of index variables D32477+7 and
the number of DO variables at its front (D33143+84).

The tables are shown at the first call of PUTAWAY with operation OP (octal,
default 030: the first jump, e.g. RETURN; 045 for the SUBP of STOP*), before
ENDPRO squeezes IFLIST.  -l also prints the list of index variables at every
statement.

iftrace.py -p 'D(I,J)' ... puts each subscripted expression into a test
subroutine with D(M,N), E(M,N,3), F(2,M,N) as parameters and shows its
token and its IFLIST form."""
import sys
import gtest
import gen
from items import word_text

VARLIST = 0o32477 + 7 - 0o253      # D32477+7 in the dubna layout

PROBE = '''      SUBROUTINE SS(D, M, N, E, F)
      DIMENSION D(M,N), E(M,N,3), F(2,M,N), A(10), B(5,4)
      I = 2
      J = 1
      K = 1
      X = %s
      RETURN
      END
'''


def name(m, p):
    t = word_text(m[p & 0o77777]) if p & 0o77777 else ''
    return t if t.isprintable() else ''


def show(m):
    n = m[gen.D33143 + 67]
    print('IFLIST: %d words' % n)
    for i in range(n):
        e = m[gen.IFLIST + i]
        print('  %04o %016o  k=%o n=%05o coef=%05o ptr=%05o %s'
              % (i, e, e >> 45, e >> 30 & 0o77777, e >> 15 & 0o77777, e & 0o77777,
                 name(m, e)))
    print('index variables (front %d): %s' % (m[gen.D33143 + 84], varlist(m)))


def varlist(m):
    return ' '.join(name(m, m[VARLIST + i]) for i in range(m[gen.D33143 + 68]))


def run(src, stop, every=False):
    """returns (memory at the stop, the first subscripted operand word)"""
    last = None
    tok = None
    for w1, w2, mem, decl, out in gtest.calls(src):
        last = mem
        if tok is None and w1 >> 33 and w1 & 0o77400 and w1 & 0o37 == 0o10:
            tok = w1
        if every and w2 & 0o77777 == 0o72:
            print('  stmt: %s' % varlist(mem))
        if w2 & 0o77777 == stop:
            break
    return last, tok


def main():
    a = sys.argv[1:]
    stop, every, probe = 0o30, False, False
    while a and a[0].startswith('-'):
        o = a.pop(0)
        if o == '-s':
            stop = int(a.pop(0), 8)
        elif o == '-l':
            every = True
        elif o == '-p':
            probe = True
    for arg in a:
        if probe:
            m, tok = run(PROBE % arg, stop)
            print('== %s  token %o' % (arg, tok or 0))
        else:
            print('== %s' % arg)
            m, tok = run(open(arg).read(), stop, every)
        show(m)


if __name__ == '__main__':
    main()
