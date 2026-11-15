#!/usr/bin/env python3
"""Find code that two images share, whatever addresses it is linked at.

    ovlsame.py A.bin BASE_A B.bin BASE_B [MINLEN]

A.bin and B.bin are memory images (6 bytes a word, e.g. the *.bin made by
ovl2bin), BASE_x the octal address of their first word. Words are compared
by the opcodes and registers of both instructions, address fields ignored,
so a module linked at different places in two overlays still matches. Runs
of at least MINLEN (default 8) words are printed with the shift B - A; a
change of the shift between runs marks a module boundary or an edit.
Used to find the Madlen assembler modules inside GLINK (overlay ASEMBLER).
"""
import sys

K = 6                                    # words in the search key


def words(f):
    d = open(f, 'rb').read()
    return [int.from_bytes(d[i:i + 6], 'big') for i in range(0, len(d) - 5, 6)]


def sig(w):
    def half(x):                         # long-address or short-address format
        return x & (0o77700000 if x & 0o2000000 else 0o77770000)
    return half(w >> 24), half(w & 0o77777777)


def main():
    if len(sys.argv) < 5:
        sys.exit(__doc__)
    a, ba, b, bb = words(sys.argv[1]), int(sys.argv[2], 8), words(sys.argv[3]), int(sys.argv[4], 8)
    minlen = int(sys.argv[5]) if len(sys.argv) > 5 else 8
    sb = [sig(w) for w in b]
    idx = {}
    for i in range(len(sb) - K):
        idx.setdefault(tuple(sb[i:i + K]), []).append(i)
    runs = []                            # [first, last, shift]
    for i in range(len(a) - K):
        k = tuple(sig(w) for w in a[i:i + K])
        if k not in idx or len(set(k)) < 4 or not all(a[i:i + K]):
            continue                     # no match, or a run of equal words
        for j in idx[k]:
            d = j + bb - i - ba
            r = next((r for r in runs[-4:] if r[2] == d and r[1] == i + ba - 1), None)
            if r:
                r[1] = i + ba
                break
        else:
            runs.append([i + ba, i + ba, idx[k][0] + bb - i - ba])
    for x, y, d in runs:
        if y + K - x >= minlen:
            print('%05o-%05o = %05o-%05o  (%+o)' % (x, y + K - 1, x + d, y + K - 1 + d, d))


main()
