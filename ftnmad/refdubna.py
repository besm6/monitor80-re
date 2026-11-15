#!/usr/bin/env python3
"""refdubna.py file.f ... - the same as ref.py, but with the dubna simulator
(its own copy of the monitor); used to cross-check and for tracing."""
import subprocess, sys, tempfile, os
COLW, PFX = 65, 19

def listing(src, extra=()):
    with tempfile.TemporaryDirectory() as t:
        job = os.path.join(t, 'job.dub')
        with open(job, 'w') as f:
            f.write('*name test\n*full\n*fortran\n' + src + '*end file\n')
        return subprocess.run(['dubna', *extra, job], capture_output=True, text=True).stdout

def madlen(lst):
    out, on = [], False
    for page in lst.split('\f'):
        lines = page.split('\n')
        if not on:
            for i, l in enumerate(lines):
                if l.startswith(' ABTOKOД  MADLEN'):
                    on, lines = True, lines[i:]
                    break
            else:
                continue
        for l in [l[:COLW] for l in lines] + [l[COLW:] for l in lines]:
            if l.startswith(' ABTOKOД  MADLEN') or l.startswith('   (1.10.72)'):
                continue
            if l.startswith(' CTPYKTYPA  ПOДПPOГPAMMЫ:'):
                on = False
                break
            s = l[PFX:].rstrip()
            if s:
                out.append(s)
    return out

if __name__ == '__main__':
    for fn in sys.argv[1:]:
        print('\n'.join(madlen(listing(open(fn).read()))))
