#!/usr/bin/env python3
"""sctrace.py file.f - what SCANSTMT (the statement reader of FORTR*)
returns for every statement of the source, from a trace of the original:
the token array (from the address passed in M6) and the cells it sets."""
import sys
import trace

SCAN = 0o2412 + trace.SHIFT


def text(v):
    t = ''.join(chr(v >> s & 255) for s in range(40, -8, -8))
    return repr(t) if all(32 <= ord(c) < 127 for c in t) else ''


if __name__ == '__main__':
    src = open(sys.argv[1]).read()
    ret = None
    m6 = 0
    addrs = {SCAN}
    it = trace.run(src, addrs)
    n = 0
    for a, st in it:
        if a == SCAN:
            n += 1
            m6 = st.m[6]
            ret = st.m[0o15]
            addrs.add(ret)
        elif a == ret:
            addrs.discard(ret)
            last = {}
            for ad, v in st.writes:
                last[ad] = v
            toks = sorted(ad for ad in last if m6 <= ad < m6 + 0o1000)
            line = ' '.join(text(last[ad]).strip("'").strip() or '%o' % last[ad] for ad in toks)
            cells = ' '.join('%o=%o' % (ad if ad < 0o200 else ad - 0o32670 + 0o1000, last[ad])
                             for ad in sorted(last) if ad in (0o104, 0o105, 0o107, 0o110, 0o111, 0o112, 0o113, 0o115, 0o120, 0o123, 0o32670 + 34))
            print('%d [%o %o] %s | %s' % (n, m6, ret, line, cells))
