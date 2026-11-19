"""Instruction trace of the original compiler in the dubna simulator, as a
test oracle.  run(src, addrs) yields (address, state) every time one of
the addresses is executed (left instruction of the word); the state has
the accumulator, the index registers and the memory seen so far.
Addresses are those of dubna's copy of the monitor: the root overlay is
loaded 0253 words lower than on volume 2048 (SHIFT)."""
import subprocess, tempfile, os

SHIFT = -0o253


class Mem(dict):
    def __missing__(self, k):
        return 0


class State:
    def __init__(self):
        self.acc = 0
        self.m = [0] * 16       # index registers
        self.mem = Mem()
        self.writes = []        # (address, value) since the last event
        self.path = []          # the addresses of the last words executed


def run(src, addrs, job='*name test\n*full\n*fortran\n'):
    if not isinstance(addrs, set):  # a set may be changed by the caller on the way
        addrs = set(addrs)
    with tempfile.TemporaryDirectory() as t:
        jf = os.path.join(t, 'job.dub')
        tr = os.path.join(t, 'tr')
        with open(jf, 'w') as f:
            f.write(job + src + '*end file\n')
        subprocess.run(['dubna', '-d', 'irm', '--trace=' + tr, jf], capture_output=True)
        st = State()
        with open(tr, errors='replace') as f:
            for l in f:
                if l[0] == ' ':
                    s = l.split()
                    k = s[0]
                    if k == 'ACC':
                        st.acc = int(''.join(s[2:6]), 8)
                    elif k == 'Memory':
                        a = int(s[2][1:-1], 8)
                        v = int(''.join(s[4:8]), 8)
                        st.mem[a] = v
                        if s[1] == 'Write':
                            st.writes.append((a, v))
                    elif k[0] == 'M' and k[1:].isdigit():
                        st.m[int(k[1:], 8)] = int(s[2], 8)
                elif l[5:8] in (' L:', ' R:'):
                    a = int(l[:5], 8)
                    if not st.path or st.path[-1] != a:
                        st.path = st.path[-15:] + [a]
                    if l[5:8] == ' L:' and a in addrs:
                        yield a, st
                        st.writes = []
