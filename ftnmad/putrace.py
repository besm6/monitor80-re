#!/usr/bin/env python3
"""putrace.py file.f - run the original compiler in the dubna simulator with
an instruction trace and list the calls of PUTAWAY (the code generator of
FORTR*): the two argument words of every call.  In dubna's copy of the
monitor PUTAWAY starts at 04134 (04407 on volume 2048).
Options: -a ADDR[,ADDR...]  also report the execution of these addresses
(octal, in dubna's layout) with the accumulator."""
import subprocess, sys, tempfile, os, re

PUTAWAY = 0o4134
NAMES = {0o6134: 'WRDECL', 0o6135: 'WROUT'}     # 06407, 06410 on volume 2048

def text(w):
    n = int(w.replace(' ', ''), 8)
    t = ''.join(chr((n >> s) & 255) for s in range(40, -8, -8))
    return repr(t) if all(32 <= ord(c) < 127 for c in t) else ''

def trace(src, watch=()):
    with tempfile.TemporaryDirectory() as t:
        job = os.path.join(t, 'job.dub')
        tr = os.path.join(t, 'tr')
        with open(job, 'w') as f:
            f.write('*name test\n*full\n*fortran\n' + src + '*end file\n')
        subprocess.run(['dubna', '-d', 'irm', '--trace=' + tr, job], capture_output=True)
        acc = '0'
        calls = []
        want = None
        with open(tr, errors='replace') as f:
            for l in f:
                if l.startswith('      '):
                    s = l.strip()
                    if s.startswith('ACC = '):
                        acc = s[6:]
                    elif want and s.startswith('Memory Read'):
                        calls.append(('PUTAWAY', s.split('= ')[1], want))
                        want = None
                elif l[5:8] == ' L:':
                    a = int(l[:5], 8)
                    if a == PUTAWAY:
                        want = acc
                    elif a in NAMES:
                        calls.append(('  ' + NAMES[a], acc, text(acc)))
                    elif a in watch:
                        calls.append(('%05o' % a, acc, ''))
        return calls

if __name__ == '__main__':
    a = sys.argv[1:]
    watch = ()
    if a[0] == '-a':
        watch = [int(x, 8) for x in a[1].split(',')]
        a = a[2:]
    for k, w1, w2 in trace(open(a[0]).read(), watch):
        print(k, w1.replace(' ', ''), w2.replace(' ', ''))
