#!/usr/bin/env python3
"""calls.py file.f - the calls of the generator (PUTAWAY) made by the
original compiler, in symbolic form: one line per call, "op operand".
With -e the arguments are Fortran statements instead of a file; they are
put into a main program (variables I-N integer, others real, all given
values first); declarations (DIMENSION, INTEGER, ...) among them go first.  Used to learn and to check the order of operations."""
import sys
import trace
from items import word_text

PUT = 0o4407 + trace.SHIFT
OPS = {0: 'LO', 1: 'LN', 2: 'AD', 3: 'SU', 4: 'MU', 5: 'DI', 6: 'COMP', 7: 'PO',
       0o10: 'CALL', 0o11: 'ARG', 0o12: 'ST', 0o13: 'BEG', 0o14: 'FREE',
       0o26: 'UZA', 0o27: 'U1A', 0o30: 'UJ', 0o31: 'VJM', 0o44: 'UPD',
       0o45: 'SUBP', 0o46: 'NAME', 0o47: 'ENTRY', 0o50: 'BLOCK', 0o51: 'CONT',
       0o52: 'SECT', 0o53: 'OCT', 0o54: 'LABEL', 0o55: 'EQU', 0o57: 'BSS',
       0o61: 'REP', 0o72: 'STMT', 0o73: 'INPUT', 0o74: 'RAW'}


def operand(w1, mem):
    if w1 == 0:
        return ''
    kind = w1 & 0o37
    t = 'IRDCLL??'[w1 >> 15 & 7]
    if kind == 1:
        p = w1 >> 24 & 0o77777
        return '=%o:%s' % (mem[p], t)
    if kind == 0o14:
        return 'T%d:%s' % (w1 >> 5 & 0o1777, t)
    s = word_text(mem[w1 >> 33]) if w1 >> 33 else '%o' % (w1 & 0o77777)
    off = w1 >> 18 & 0o77777
    if off:
        s += '+%o' % off
    fl = w1 & 0o77777 & ~0o37
    return '%s:%s%s%s' % (s, t, '/%o' % kind if kind != 0o10 else '',
                          '[%o]' % fl if fl else '')


def calls(src):
    """yields (text, w1, w2)"""
    prev = None
    for a, st in trace.run(src, [PUT]):
        w2 = st.acc
        w1 = st.mem[st.m[15] - 1]
        if w1 and not w1 & 0o77777 and not w2:
            continue
        op = w2 & 0o77777
        name = OPS.get(op, '%o' % op)
        if op <= 0o12 and op not in (0o10, 0o11):
            name = 'IRDCLL'[st.mem[0o33143 + trace.SHIFT + 222] & 7] + name
        if op == 0o74:
            name = 'RAW %o' % (w2 >> 24 & 0o777)
            arg = word_text(st.mem[w1 & 0o77777]) if not w2 & 0o100000 else '=%o' % w1
            if w1 >> 24 & 0o77777:
                arg += '+%o' % (w1 >> 24 & 0o77777)
        else:
            arg = operand(w1, st.mem)
        hi = w2 >> 15
        yield '%s%s %s' % (name, '{%o}' % hi if hi else '', arg), w1, w2


DECL = r'(DIMENSION|INTEGER|REAL|LOGICAL|COMMON|DOUBLE|COMPLEX)\b'


def program(stmts):
    names = set()
    import re
    decl = [s for s in stmts if re.match(DECL, s)]
    stmts = [s for s in stmts if not re.match(DECL, s)]
    arrays = set()
    for s in decl:
        arrays |= set(re.findall(r'\b([A-Z][A-Z0-9]*)\(', s))
    for s in stmts:
        names |= set(re.findall(r'\b[A-Z][A-Z0-9]*\b', re.sub(r'\.[A-Z]+\.', ' ', s)))
    src = '      PROGRAM QQ\n' + ''.join('      %s\n' % s for s in decl)
    for n in sorted(names - arrays):
        if len(n) <= 2:
            src += '      %s = %s\n' % (n, '1' if n[0] in 'IJKLMN' else '1.0')
    src += '      CONTINUE\n'
    for s in stmts:
        src += '      %s\n' % s
    return src + '      STOP\n      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    if a[0] == '-e':
        import re
        src = program(a[1:])
        a = [x for x in a if not re.match(DECL, x)]
        skip = src.count('\n') - len(a[1:]) - 3 - (len(sys.argv) - 1 - len(a))
        groups = []
        for t, w1, w2 in calls(src):
            if t.startswith('STMT'):
                groups.append([])
            elif groups:
                groups[-1].append(t.strip())
        for st, g in zip(a[1:], groups[skip:]):
            print('%-28s %s' % (st, ' ; '.join(g)))
        sys.exit()
    for t, w1, w2 in calls(open(a[0]).read()):
        print(t)
