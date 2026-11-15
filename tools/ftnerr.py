#!/usr/bin/env python3
"""Decode the error message file of the Monitor-80 Fortran compiler (FORTR*).

    besmtool dump 2048 --start=0202 --length=4 --to-file=/dev/stdout | \
        tools/ftnerr.py > fortran/errmsg.txt

Zones 0202-0205 of the system volume (2048 and 2148 hold the same data).
Words 0-0313 of the first zone are a table, one word per message:

    bits 48-37   place of the text in its 256-word section:
                   word = ((v >> 4) & 037) * 8 + (v & 3) * 2
    bits 36-19   error code (4 octal digits)
    bits 18-1    section: zone (digit 1) and quarter of the zone (digit 3)

An unused entry has 110200 in the code field. The texts start at word 01000
of the first zone, 14 words (84 characters) each, 18 texts in a section, in
KOI-7 with Latin letters for the look-alikes (and D for Д here and there).
ERRPRINT finds the entry by the low 12 bits of the number it is given, reads
the section and prints the text. The listing shows the whole
number: its digits above the code are the severity (1, 2 or 4; after a 4 the
rest of the program unit is only scanned, not translated).

Output: `code text`, sorted by code.
"""
import sys

CYR = 'ЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧ'


def char(b):
    if 0x60 <= b < 0x7f:
        return CYR[b - 0x60]
    return chr(b) if 0x20 <= b < 0x60 else '?'


def main():
    d = sys.stdin.buffer.read()
    out = {}
    for i in range(0o1000):
        w = int.from_bytes(d[i * 6:i * 6 + 6], 'big')
        v, code, sec = w >> 36, (w >> 18) & 0o777777, w & 0o777777
        if not v & 0o4000:
            break                        # the table is over
        if code == 0o110200:
            continue
        a = (sec & 7) * 1024 + ((sec >> 6) & 7) * 256 + ((v >> 4) & 0o37) * 8 + (v & 3) * 2
        out[code] = ''.join(char(b) for b in d[a * 6:(a + 14) * 6]).rstrip()
    for code in sorted(out):
        print('%04o %s' % (code, out[code]))


main()
