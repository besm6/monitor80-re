#!/usr/bin/env python3
"""gtest.py [-v] file.f ... - test of the generator alone.  The original
compiler is traced in the dubna simulator; every call of PUTAWAY is
repeated with gen.Gen on the state of the tables the original had at the
call, and the items written are compared with those of the original."""
import subprocess, sys, tempfile, os, collections
import gen

PUTAWAY, WRDECL, WROUT = 0o4134, 0o6134, 0o6135
gen.relocate(-0o253)


class Mem(dict):
    def __missing__(self, k):
        return 0


def calls(src):
    """yields (w1, w2, memory at the call, decl words, out words)"""
    with tempfile.TemporaryDirectory() as t:
        job = os.path.join(t, 'job.dub')
        tr = os.path.join(t, 'tr')
        with open(job, 'w') as f:
            f.write('*name test\n*full\n*fortran\n' + src + '*end file\n')
        subprocess.run(['dubna', '-d', 'irm', '--trace=' + tr, job], capture_output=True)
        mem = Mem()
        acc = 0
        cur = None          # [w1, w2, first reads, writes, decl, out]
        want = None
        with open(tr, errors='replace') as f:
            for l in f:
                if l[0] == ' ':
                    s = l.split()
                    if s[0] == 'ACC':
                        acc = int(''.join(s[2:6]), 8)
                    elif s[0] == 'Memory':
                        a = int(s[2][1:-1], 8)
                        v = int(''.join(s[4:8]), 8)
                        if want is not None and s[1] == 'Read':
                            cur = [v, want, {}, {}, [], []]
                            want = None
                        elif cur:
                            if s[1] == 'Read':
                                if a not in cur[3] and a not in cur[2]:
                                    cur[2][a] = v
                            else:
                                cur[3][a] = v
                        else:
                            mem[a] = v
                elif l[5:8] == ' L:':
                    a = int(l[:5], 8)
                    if a == PUTAWAY:
                        if cur:
                            mem.update(cur[2])
                            yield cur[0], cur[1], Mem(mem), cur[4], cur[5]
                            mem.update(cur[3])
                        want = acc
                        cur = None
                    elif a == WRDECL and cur:
                        cur[4].append(acc)
                    elif a == WROUT and cur:
                        cur[5].append(acc)
        if cur:
            mem.update(cur[2])
            yield cur[0], cur[1], Mem(mem), cur[4], cur[5]


def check(fn, verbose=False):
    g = gen.Gen(Mem())
    ok = True
    for n, (w1, w2, mem, decl, out) in enumerate(calls(open(fn).read())):
        if w1 and not w1 & 0o77777 and not w2:
            continue                # not a call from the compiler proper
        if decl[-1:] == [0] and out[-1:] == [0]:
            decl, out = decl[:-1], out[:-1]     # FTNMAIN closes both lists
        g.m = mem
        g.decl, g.out = [], []
        try:
            g.put(w1, w2)
        except Exception as e:
            print('%d: PUTAWAY %016o %016o: %r' % (n, w1, w2, e))
            return False
        if verbose or g.decl != decl or g.out != out:
            print('%d: PUTAWAY %016o %016o' % (n, w1, w2))
            for k, a, b in (('DECL', decl, g.decl), ('OUT', out, g.out)):
                if a or b:
                    print('  %s want %s' % (k, ' '.join('%o' % x for x in a)))
                    print('  %s got  %s' % (k, ' '.join('%o' % x for x in b)))
        if g.decl != decl or g.out != out:
            ok = False
            if not verbose:
                return False
    return ok


if __name__ == '__main__':
    a = sys.argv[1:]
    v = a[:1] == ['-v']
    for fn in a[v:]:
        print(fn, 'OK' if check(fn, v) else 'DIFFERENT')
