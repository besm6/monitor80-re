#!/usr/bin/env python3
"""grptrace.py [-r] file.f - how CONTROL of the original compiler groups the
statements: runs it in dubna and prints, in order, the starts of statements
(PUTAWAY item 072, numbered like the C*****HAЧAЛO lines), the calls of
*0767B (the index registers are forgotten; with the caller's offset in
CONTROL and D33143+73, the registers that are kept) and the passes through
*1064B (the end of a group: D33143+73 cleared first).  With -r: the
statements at which the table of index registers (D33143+91..96) is found
emptied, for the original and for ftnmad side by side.  Dubna addresses:
CONTROL is at 0o34600 (0274 lower than on volume 2048)."""
import sys

import trace
import calls

CONTROL = 0o34600
FORGET = CONTROL + 0o767
GROUP_END = CONTROL + 0o1064
D33143 = 0o33143 + trace.SHIFT


def main(fn):
    src = open(fn).read()
    n = 0
    for a, st in trace.run(src, [calls.PUT, FORGET, GROUP_END]):
        if a == calls.PUT:
            if st.acc == 0o72:
                n += 1
                print('stmt %d' % n)
        elif a == FORGET:
            print('    forget (from CONTROL+%o) keep=%o' % (st.m[13] - CONTROL - 1,
                                                          st.mem[D33143 + 73]))
        else:
            print('    group end')


def resets_original(src):
    """statement numbers at whose PUTAWAY calls the register table went
    from something to nothing"""
    out, n, prev = [], 0, False
    for a, st in trace.run(src, [calls.PUT]):
        if st.acc == 0o72:
            n += 1
        full = any(st.mem[D33143 + 91 + i] for i in range(6))
        if prev and not full:
            out.append(n)
        prev = full
    return out


def resets_ftnmad(src):
    import front
    import gen
    out, state = [], [0, False]
    old = front.Front.put

    def put(self, w1, w2):
        if w2 & 0o77777 == 0o72:
            state[0] += 1
        full = any(self.m[gen.D33143 + 91 + i] for i in range(6))
        if state[1] and not full:
            out.append(state[0])
        state[1] = full
        return old(self, w1, w2)
    front.Front.put = put
    try:
        front.compile_text(src)
    finally:
        front.Front.put = old
    return out


if __name__ == '__main__':
    if sys.argv[1] == '-r':
        src = open(sys.argv[2]).read()
        print('original:', resets_original(src))
        print('ftnmad:  ', resets_ftnmad(src))
    else:
        main(sys.argv[1])
