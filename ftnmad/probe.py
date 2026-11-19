#!/usr/bin/env python3
"""probe.py [-f file] [statement ...] - the diagnostics of the original
compiler for many statements at once: they are put one per card into a
SUBROUTINE (DIMENSION A(5), B(3,3) given) and compiled by ref.py; prints
each statement with the codes printed after it ('-' for none).  The
statements are read from the file, one per line, if -f is given.  An
error does not stop the compiler, so one run answers for all of them."""
import sys

import dtest
import ref


def probe(stmts, head='      SUBROUTINE PROBE\n      DIMENSION A(5), B(3,3)\n'):
    src = head + ''.join('      %s\n' % s for s in stmts) + '      END\n'
    sec = sum(dtest.sections(ref.listing(src)), [])
    out, cur = [], None
    for l in sec:
        if len(l) == 6 and l[1:].isdigit():
            if cur is not None:
                cur[1].append(l.strip())
        elif l.startswith('          ') or l.startswith('    C'):
            cur = [l.strip(), []]
            out.append(cur)
    return out


if __name__ == '__main__':
    a = sys.argv[1:]
    if a and a[0] == '-f':
        stmts = [l.rstrip('\n') for l in open(a[1]) if l.strip()]
    else:
        stmts = a
    for s, codes in probe(stmts)[2:-1]:
        print('%-40s %s' % (s, ' '.join(codes) or '-'))
