#!/usr/bin/env python3
"""mkerr.py seed file.f [n] - a copy of a correct Fortran program (stdout)
with n (default 1) of its statements spoiled at random: a character
inserted, deleted or doubled, a parenthesis dropped, a name made too
long, a constant made bad (E without exponent, 8 in an octal constant,
a wrong Hollerith count), a keyword misspelt.  For testing the
diagnostics of ftnmad against the original (dtest.py): the statements
after the spoiled one must still be compiled and diagnosed alike."""
import random
import re
import sys

CHARS = "+-*/=(),.'$ABZ019"


def spoil(rnd, body):
    """body: columns 7-72 of a card -> a spoiled body"""
    s = body.rstrip()
    k = rnd.random()
    pos = rnd.randrange(len(s) + 1)
    if k < 0.2:
        return s[:pos] + rnd.choice(CHARS) + s[pos:]
    if k < 0.3 and s:
        pos = min(pos, len(s) - 1)
        return s[:pos] + s[pos + 1:]
    if k < 0.4 and s:
        pos = min(pos, len(s) - 1)
        return s[:pos] + s[pos] + s[pos:]
    if k < 0.5 and ')' in s:
        i = rnd.choice([m.start() for m in re.finditer(r'\)', s)])
        return s[:i] + s[i + 1:]
    if k < 0.6:
        names = list(re.finditer(r'\b[A-Z][A-Z0-9]*\b', s))
        if names:
            m = rnd.choice(names)
            return s[:m.end()] + 'XYZWQ'[:rnd.randint(1, 5)] + s[m.end():]
    if k < 0.75:
        nums = list(re.finditer(r'\b\d+(\.\d*)?', s))
        if nums:
            m = rnd.choice(nums)
            t = rnd.choice(['E', 'E+', '.5.', '8B', '9B', 'D', '1H', '0H', '99999999999',
                            '.0E99', 'B7'])
            return s[:m.end()] + t + s[m.end():]
    if k < 0.85:
        m = re.match(r'\s*([A-Z]+)', s)
        if m and len(m.group(1)) > 2:
            w = m.group(1)
            i = rnd.randrange(len(w))
            return s[:m.start(1) + i] + rnd.choice('AEIOUX') + s[m.start(1) + i + 1:]
    return s[:pos] + rnd.choice(CHARS) + s[pos:]


def program(seed, src, n=1):
    rnd = random.Random(seed)
    lines = src.splitlines()
    cand = [i for i, l in enumerate(lines)
            if len(l) > 6 and l[0] != 'C' and l[5] in ' 0' and l[6:].strip()
            and not re.match(r'\s*(SUBROUTINE|FUNCTION|PROGRAM|END\s*$)', l[6:])]
    for i in rnd.sample(cand, min(n, len(cand))):
        l = lines[i]
        lines[i] = (l[:6] + spoil(rnd, l[6:]))[:72]
    return '\n'.join(lines) + '\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), open(a[1]).read(), int(a[2]) if len(a) > 2 else 1))
