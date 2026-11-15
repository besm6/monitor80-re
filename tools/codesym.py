#!/usr/bin/env python3
"""
codesym.py - find code that disbesm6 printed as data and emit symbol-table
lines (`from-to C -`) that force it to be disassembled as code.

    codesym.py IMAGE.bin IMAGE.dis >> NAME.sym     (then re-run disbesm6;
                                                    repeat until no output)

disbesm6 follows the control flow, so the words after an unconditional jump
that are reached only through a stored return address or a computed jump stay
`конд`. Here every run of data words that directly follows code is scanned
from its start: words are collected while both halves look like instructions
(an opcode a user program may contain, branch targets inside memory that
exists, a zero half only after `мода`/`мод`); when a collected word holds `пб`, or the run ends where code
resumes, the collected words are code. The first word that does not look like
an instruction stops the scan, so literal pools and tables are left alone
unless they happen to decode cleanly up to a `пб` - check the result.

IMAGE.bin: 6 bytes per word, the 8-word overlay header first (load address in
the low 15 bits of header word 2).
"""
import re
import sys

BAD1 = {0o002, 0o032, 0o033, 0o046, 0o047}          # format 1, privileged/illegal
GOOD2 = {0o22, 0o23, 0o24, 0o25, 0o26, 0o27, 0o30, 0o31, 0o34, 0o35, 0o37}
BRANCH = {0o26, 0o27, 0o30, 0o31, 0o34, 0o35, 0o37}


def is_mod(h):
    """UTC/WTC: the next instruction takes its address from C."""
    return bool(h & 0o2000000) and (h >> 15) & 0o37 in (0o22, 0o23)


def half_ok(h, top, prev=0):
    mod = is_mod(prev)                   # `мода X; зп` and `мод X; пб 1` are fine
    if h == 0:
        return mod
    if h & 0o2000000:                                # format 2
        op, addr, reg = (h >> 15) & 0o37, h & 0o77777, h >> 20
        if op not in GOOD2:
            return False
        if op in BRANCH and not mod and not (op == 0o30 and reg) \
                and not (0o400 <= addr < top) and not (op == 0o30 and addr == 0):
            return False
        return True
    return ((h >> 12) & 0o177) not in BAD1


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    d = open(sys.argv[1], 'rb').read()
    img = [int.from_bytes(d[i:i + 6], 'big') for i in range(0, len(d) - 5, 6)]
    base = img[2] & 0o77777
    top = max(base + len(img), 0o45000)
    kind, cur = {}, None
    for l in open(sys.argv[2], encoding='utf-8'):
        f = l.split('\t')
        m = re.match(r' ?([0-7]{4,5})[: ]', f[0])
        if not m:
            continue
        cur = int(m.group(1), 8)
        rest = f[0][6:]
        if re.match(r'[0-7]{16}', rest):
            kind[cur] = 'd'
        elif re.match(r'[0-7]{2} [0-7]{2,3} [0-7]{4,5}', rest):
            kind[cur] = 'c'
    a, end = base + 8, base + len(img)
    while a < end:
        if kind.get(a) != 'd' or kind.get(a - 1) != 'c':
            a += 1
            continue
        b = a                                        # data run [a, b)
        while kind.get(b) == 'd':
            b += 1
        x, start = a, a
        while x < b:
            w = img[x - base]
            l, r = w >> 24, w & 0o77777777
            p = img[x - 1 - base] & 0o77777777
            if not (half_ok(l, top, p) and half_ok(r, top, l)):
                break
            x += 1
            jump = any((h >> 15) & 0o37 == 0o30 and h & 0o2000000 for h in (l, r))
            if jump or (x == b and kind.get(b) == 'c'):
                print('%o-%o C -' % (start, x - 1) if x - 1 > start else '%o C -' % start)
                start = x
        a = b


if __name__ == '__main__':
    main()
