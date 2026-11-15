#!/usr/bin/env python3
"""ref.py [-l] file.f ... - compile Fortran sources with the original FORTR*
(Монитор-80 on volume 2148 under dispak, cards *SUPER and *FULL) and print
the Madlen text it generates, without the address and code columns of the
listing.  With -l the whole listing is printed as is."""
import subprocess, sys, tempfile, os, re

PFX = 24       # width of the address/code columns under *SUPER
HEAD = 'шифр 419999ЗС5^\nЛЕН 40(2148)^\nЕЕВ1А3\n*NAME\n*SUPER\n*FULL\n*FORTRAN\n'
TAIL = '*END FILE\n``````\nЕКОНЕЦ\n'

def listing(src):
    if not src.endswith('\n'):
        src += '\n'
    with tempfile.TemporaryDirectory() as t:
        job = os.path.join(t, 'job.b6')
        with open(job, 'w') as f:
            f.write(HEAD + src + TAIL)
        return subprocess.run(['dispak', '-l', job], capture_output=True,
                              text=True, cwd=t).stdout

def madlen(lst):
    out = []
    on = False
    for l in lst.replace('\f', '').split('\n'):
        if l.startswith(' ABTOKOД  MADLEN'):
            on = True
        elif 'ЧИCЛO OШИБ. OПEPATOPOB' in l:
            on = False
            if not l.rstrip().endswith('0000'):
                out.append('*** ERRORS ' + l.split()[-1])
        elif l.startswith(' TAБЛИЦA') or l.startswith(' CTPYKTYPA  ПOДПPOГPAMMЫ:'):
            on = False
        elif on and not l.startswith('   (1.10.72)'):
            if re.match(r' [0-7]{4}( [0-7]{4}){4}$', l):
                continue        # a constant
            s = l[PFX:].rstrip()
            if s:
                out.append(s)
    return out

if __name__ == '__main__':
    a = sys.argv[1:]
    full = a[:1] == ['-l']
    for fn in a[full:]:
        lst = listing(open(fn).read())
        if full:
            sys.stdout.write(lst)
        else:
            print('\n'.join(madlen(lst)))
