#!/usr/bin/env python3
"""mkeqv.py seed [n] [sub] - a random Fortran program (stdout) with
EQUIVALENCE and DATA: arrays and scalars, some typed, put into classes by
random groups (one constant subscript per item, never two items of one
class in a group: the original loops on that), DATA for scalars, whole
arrays, elements, with repeat counts that run over several variables,
signed integers and reals, octal, Hollerith and logical constants; then n
statements that use the variables (subscripts with variables, DO loops).
With a third argument the program is a subroutine with parameters.  For
testing CBPRCZ/CBBSS/CBEQU of ftnmad against the original (ftest.py)."""
import random
import sys

ARRAYS = [('A', 10), ('B', 5), ('C', 4), ('E', 3), ('F', 6), ('KG', 4), ('H', 8)]
SCALARS = ['P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'KK', 'LL', 'MM', 'NX']
INTS = ['I', 'J', 'K', 'L']


def const(rnd, integer):
    k = rnd.random()
    if integer:
        if k < 0.2:
            return '-%d' % rnd.randint(0, 9)
        if k < 0.3:
            return '%oB' % rnd.randint(0, 0o77777)
        return str(rnd.randint(0, 99))
    if k < 0.15:
        return '-%d.%d' % (rnd.randint(0, 9), rnd.randint(0, 9))
    if k < 0.25:
        return '%d.5E%d' % (rnd.randint(1, 9), rnd.randint(-3, 3))
    if k < 0.32:
        return rnd.choice(['2HAB', '1HZ', '3HX1Y', "'OK'", '6HABCDEF'])
    if k < 0.37:
        return '+%d.25' % rnd.randint(0, 9)
    return '%d.%d' % (rnd.randint(0, 99), rnd.randint(0, 9))


def card(st):
    """a statement -> cards, continued at ', ' (not inside a Hollerith
    constant: the rest of a card up to column 72 counts as blanks)"""
    out, cur = '', '      '
    for i, w in enumerate(st.split(', ')):
        w += ', ' if i < st.count(', ') else ''
        if len(cur) + len(w) > 72:
            out += cur.rstrip() + '\n'
            cur = '     1'
        cur += w
    return out + cur.rstrip() + '\n'


def program(seed, n=20, sub=False):
    rnd = random.Random(seed)
    arrays = rnd.sample(ARRAYS, rnd.randint(2, len(ARRAYS)))
    scalars = rnd.sample(SCALARS, rnd.randint(3, len(SCALARS)))
    size = dict(arrays)
    if sub:
        s = '      SUBROUTINE G%d(X, N, Z)\n' % seed
    else:
        s = '      PROGRAM G%d\n' % seed
    reals = [a for a in arrays if a[0][0] not in 'IJKLMN']
    ints = [a for a in arrays if a[0][0] in 'IJKLMN']
    s += '      DIMENSION %s\n' % ', '.join('%s(%d)' % a for a in reals)
    if ints:
        s += '      INTEGER %s\n' % ', '.join('%s(%d)' % a for a in ints)
    typed = [v for v in scalars if rnd.random() < 0.3]
    if typed:
        s += '      INTEGER %s\n' % ', '.join(typed)
    # equivalence classes, by union-find
    cls = {}

    def find(x):
        while cls.get(x, x) != x:
            x = cls[x]
        return x

    names = [a for a, _ in arrays] + scalars
    # some subscript variables get their values by DATA, some are in
    # EQUIVALENCE (they go to the list of declared names then)
    dints = [v for v in INTS if rnd.random() < 0.3]
    eints = [v for v in INTS if v not in dints and rnd.random() < 0.2]
    for v in eints:
        partner = rnd.choice([x for x in scalars if x[0] in 'IJKLMN' or x in typed]
                             or [None])
        if partner and find(partner) == partner:
            cls[partner] = v
            s += '      EQUIVALENCE (%s, %s)\n' % (v, partner)
    groups = []
    known = set()       # in EQUIVALENCE or DATA: has memory
    for _ in range(rnd.randint(1, 6)):
        k = rnd.randint(2, 3)
        items, roots = [], set()
        for v in rnd.sample(names, len(names)):
            if find(v) in roots:
                continue
            roots.add(find(v))
            if v in size and rnd.random() < 0.7:
                items.append('%s(%d)' % (v, rnd.randint(1, size[v])))
            else:
                items.append(v)
            if len(items) == k:
                break
        if len(items) < 2:
            continue
        for it in items[1:]:
            cls[find(it.split('(')[0])] = find(items[0].split('(')[0])
        known.update(it.split('(')[0] for it in items)
        groups.append('(%s)' % ', '.join(items))
    for i in range(0, len(groups), 3):
        s += '      EQUIVALENCE %s\n' % ', '.join(groups[i:i + 3])
    # DATA: at most one variable of a class gets values
    given = set()
    for _ in range(rnd.randint(1, 3)):
        parts = []
        for _ in range(rnd.randint(1, 3)):
            items, total = [], 0
            for v in rnd.sample(names, rnd.randint(1, 3)):
                if find(v) in given:
                    continue
                given.add(find(v))
                known.add(v)
                if v in size and rnd.random() < 0.4:
                    items.append('%s(%d)' % (v, rnd.randint(1, size[v])))
                    total += 1
                else:
                    items.append(v)
                    total += size.get(v, 1)
            if not items:
                continue
            integer = items[0][0] in 'IJKLMN' or items[0] in typed
            vals = []
            while total:
                r = rnd.randint(1, total) if rnd.random() < 0.4 else 1
                c = const(rnd, integer)
                vals.append('%d*%s' % (r, c) if r > 1 else c)
                total -= r
            parts.append('%s /%s/' % (', '.join(items), ', '.join(vals)))
        if parts:
            s += card('DATA ' + ', '.join(parts))
    if rnd.random() < 0.3:
        s += '      LOGICAL LG\n      DATA LG /.TRUE./\n'
    if dints:
        s += card('DATA ' + ', '.join('%s /%d/' % (v, rnd.randint(1, 3)) for v in dints))
    for v in INTS:
        if v not in dints:
            s += '      %s = %d\n' % (v, rnd.randint(1, 3))
    # the other scalars get values (a variable without memory is an error)
    for v in scalars:
        if v not in known:
            s += '      %s = %s\n' % (v, '1' if v[0] in 'IJKLMN' or v in typed else '1.5')
    reals_s = [v for v in scalars if v[0] not in 'IJKLMN' and v not in typed]

    def element():
        a, d = rnd.choice(arrays)
        k = rnd.random()
        if k < 0.3:
            sub_ = str(rnd.randint(1, d))
        elif k < 0.7:
            sub_ = rnd.choice(INTS)
        else:
            sub_ = '%s+%d' % (rnd.choice(INTS), rnd.randint(0, 1))
        return '%s(%s)' % (a, sub_)

    def operand():
        k = rnd.random()
        if k < 0.5:
            return element()
        if k < 0.8 and scalars:
            return rnd.choice(scalars)
        return rnd.choice(INTS + ['1.5', '2'])

    ends = []
    for i in range(n):
        lab = 10 * (i + 1)
        while ends and ends[-1] < lab:
            ends.pop()
        k = rnd.random()
        if k < 0.1 and not ends and i < n - 2:
            end = lab + 10 * rnd.randint(1, min(3, n - 1 - i))
            ends.append(end)
            st = 'DO %d %s = 1, %d' % (end, rnd.choice(INTS[2:]), rnd.randint(2, 3))
        elif k < 0.5:
            st = '%s = %s' % (element(), ' + '.join(operand() for _ in range(rnd.randint(1, 3))))
        elif k < 0.75 and reals_s:
            st = '%s = %s * %s' % (rnd.choice(reals_s), operand(), operand())
        else:
            st = '%s = %s - %s' % (rnd.choice(scalars), operand(), operand())
        s += '%5d %s\n' % (lab, st)
    return s + ('      RETURN\n' if sub else '      STOP\n') + '      END\n'


if __name__ == '__main__':
    a = sys.argv[1:]
    sys.stdout.write(program(int(a[0]), int(a[1]) if len(a) > 1 else 20, len(a) > 2))
