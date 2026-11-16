"""Code for arithmetic expressions: module G46107 of the overlay CONTROL
with its helpers G50517, G50531, G50610, G50635, G50655, rewritten from
the disassembly (fortran/g46107.asm etc).

The input is the table made by arith.py: entries "header = tokens 6".
The entries are evaluated in the order of the table, each one into the
accumulator.  After an entry whose header is a reference n<<5|011 the
entry that uses the reference is looked up; the accumulator either goes
on there (absorbing the simple operands around the reference) or is
stored into a temporary that takes the place of the reference.

The work cells are those of the original (common block D33143+152...),
kept in the table memory: some of them are read before they are set.
"""
from arith import PLUS, MINUS, MUL, DIV, POWER, ASSIGN, END, TYPE

LO, LN, AD, SU, MU, DI, COMP, PO, CALL, ARG, ST, BEG, FREE = range(13)
CELLS = 0o33143 + 152
MANT = 0o37777777777777


def relocate(delta):
    global CELLS
    CELLS += delta


def additive(t):
    return t == PLUS or t == MINUS


def opcode(t):
    return (t >> 24) + 1


class ExpGen:
    def __init__(self, m, put):
        self.m = m
        self.put = put

    # the cells that outlive a call or are shared with the generator
    def cell(self, k):
        return self.m[CELLS + k]

    def setcell(self, k, v):
        self.m[CELLS + k] = v

    llim = property(lambda s: s.cell(0o26), lambda s, v: s.setcell(0o26, v))
    acctype = property(lambda s: s.cell(0o106), lambda s, v: s.setcell(0o106, v))

    # ------------------------------------------------------------------
    def entries(self, start, end):
        """the list of entries, the last one first: [place before the
        header, place of the end]; holes (zero words) are squeezed out"""
        m = self.m
        ents = [None]
        e = end
        while True:
            p = e
            more = True
            while True:
                p -= 1
                if m[p] == END:
                    break
                if p == start:
                    more = False
                    break
            hm1 = p if more else start - 1
            q = p
            while q <= e and m[q]:
                q += 1
            if q <= e:
                e = self.squeeze(q, e)
            ents.append([hm1, e])
            e = p
            if not more:
                return ents

    def squeeze(self, a, b):
        """G50517: the words a..b without zeros; returns the new end"""
        m = self.m
        o = a - 1
        for p in range(a, b + 1):
            if m[p]:
                o += 1
                m[o] = m[p]
        return o

    def compare(self, op1, op2):
        """G50655: 0 - the operators are of one rank, 1 - the second
        binds stronger, 2 - the first does"""
        r1 = additive(op1) or op1 == END
        r2 = additive(op2) or op2 == END
        if r1 == r2:
            return 0
        return 1 if r1 else 2

    def stronger(self, pos, ueq):
        """G50635: is there, to the left of the operator at pos, an
        operator that binds stronger (before the limits)?  Returns its
        place or None."""
        m = self.m
        mult = not additive(m[pos])
        p = pos
        while True:
            if p == self.llim or p == ueq:
                return None
            p -= 2
            t = m[p]
            if t == ASSIGN:
                return None
            if mult:
                if t == POWER:
                    return p
            elif not additive(t):
                return p

    def small_power(self, exp):
        """the value of an integer constant 0..8, or None"""
        m = self.m
        if exp & 0o700037 != 1:
            return None
        v = m[exp >> 24 & 0o77777]
        if not v >> 47:
            return None
        v &= MANT
        if v > 8:
            return None
        return v

    def power(self, base, exp, live):
        """G50531: base ** exp; live: the base is in the accumulator"""
        n = self.small_power(exp)
        if n is None:
            self.setcell(0o105, base)
            self.setcell(0o104, exp)
            self.put(0, PO)
            return
        self.inline_power(base, n, live)

    def inline_power(self, base, n, live):
        """G50532: a power 0..8 by multiplications"""
        put = self.put
        put(0, BEG)
        if not live:
            put(base, LO)
        if n == 0:
            put(base, DI)
        else:
            n -= 1
            while n:
                put(base, MU)
                n -= 1
                if n == 0:
                    break
                if n == 1:
                    continue
                sq = put(self.tmp, ST)
                if n & 1:
                    n -= 1
                    put(base, MU)
                again = False
                while True:
                    put(sq, MU)
                    n -= 2
                    if n == 0:
                        break
                    if n == 4:
                        base = put(self.tmp, ST)
                        n = 1
                        again = True
                        break
                if not again:
                    break
        put(0, FREE)

    def linear(self, first, last, op):
        """G50610, G50611: operands first..last joined by + and -;
        op is the operation for the first one"""
        m, put = self.m, self.put
        p = first
        if m[p] & 0o37 == 2:
            if m[p] != PLUS:
                op += 1
            p += 1
        put(m[p], op)
        while p != last:
            p += 2
            put(m[p], opcode(m[p - 1]))

    def call(self, f):
        """a function call: f, arguments separated by commas"""
        m, put = self.m, self.put
        low = m[f] & 0o77777
        flags = {0o13: 4, 0o113: 0, 0o213: 6}.get(low, 2)
        put(m[f + 1], flags << 45 | ARG)
        p = f + 2
        while m[p] != END:
            put(m[p + 1], ARG)
            p += 2
        put(m[f], CALL)

    # ------------------------------------------------------------------
    def products(self, first, end, run):
        """*0111B: an entry with multiplications; run is the place of the
        first operator that is not + or -.  Every product is computed in
        the accumulator; the sum collected so far waits in a temporary
        (put in place of the first token)."""
        m, put = self.m, self.put
        prefix = True           # 14B: the operands before the product wait
        lab = 111
        while True:
            if lab == 111:
                p = q = run     # p: the operator looked at, q: the pending one
                live = False    # 15B: the accumulator holds the product
                lab = 114
            elif lab == 114:
                if m[p] != POWER:
                    lab = 167
                    continue
                if live:
                    m[p - 1] = put(self.tmp, ST)
                self.power(m[p - 1], m[p + 1], live)
                live = True
                p += 2
                if p != end:
                    continue
                p = 0
                lab = 127
            elif lab == 127:
                # the product is ready; the sum before it
                q -= 1
                if q != first:
                    q -= 1
                    if m[q] == MINUS:
                        put(0, COMP)
                    if not prefix:
                        put(m[first], AD)
                    elif q != first:
                        self.linear(first, q - 1, AD)
                prefix = False
                if p == 0:
                    return
                while True:     # *0146B: the sums that follow
                    op = opcode(m[p])
                    p += 2
                    if p == end:
                        put(m[p - 1], op)
                        return
                    if not additive(m[p]):
                        break
                    put(m[p - 1], op)
                m[first] = put(self.tmp, ST)
                run = p
                lab = 111
            elif lab == 167:
                if p == 0 or additive(m[p]):
                    q = run
                    lab = 127
                    continue
                q = p
                p += 2
                if p == end:
                    p = 0
                elif m[p] == POWER:
                    if live:
                        m[q - 1] = put(self.tmp, ST)
                        live = False
                    base = m[p - 1]
                    while True:
                        self.power(base, m[p + 1], live)
                        live = True
                        p += 2
                        if p == end:
                            p = 0
                            break
                        if m[p] != POWER:
                            break
                        base = put(self.tmp, ST)
                    if m[q] != DIV:
                        put(m[q - 1], opcode(m[q]))
                        continue
                    m[q + 1] = put(self.tmp, ST)
                    live = False
                if not live:
                    if m[q - 2] == MINUS:
                        m[q - 2] = PLUS
                        put(m[q - 1], LN)
                    else:
                        put(m[q - 1], LO)
                put(m[q + 1], opcode(m[q]))
                live = True

    # ------------------------------------------------------------------
    def run(self, start, end):
        m, put = self.m, self.put
        ents = self.entries(start, end)
        cur = len(ents) - 1
        state = 'entry'
        while True:
            if state == 'entry':
                # *0044B: evaluate the entry cur
                hm1, e = ents[cur]
                p = hm1 + 2
                while m[p] == ASSIGN:
                    p += 2
                if m[p] == 0:
                    cur -= 1
                    continue
                first = p - 1
                self.tmp = m[first - 2] & TYPE
                self.acctype = self.tmp >> 15
                if m[first] & 0o37 == 0o13:
                    self.call(first)
                else:
                    self.tmp |= 0o14
                    n = e - first - 1
                    p = first + (n & 1) - 1
                    run = None
                    for i in range(n >> 1):
                        p += 2
                        if not additive(m[p]):
                            run = p
                            break
                    if run is None:
                        self.linear(first, e - 1, LO)
                    else:
                        self.products(first, e, run)
                # *0263B
                cur -= 1
                if cur == 0:
                    break
                user = cur + 1
                state = 'done'
            elif state == 'done':
                # *0316B: the entry that starts at first is in the
                # accumulator; who needs it?
                ref = m[first - 2]
                if ref & 0o37 != 0o11:
                    put(ref, ST)
                    state = 'entry'
                    continue
                while True:
                    user -= 1
                    uhm1, uend = ents[user]
                    use = uend - 1
                    while use != uhm1 and m[use] != ref:
                        use -= 1
                    if use != uhm1:
                        break
                state = self.use(ref, ents, user, use)
                if state == 'entry':
                    continue
                # *0665B: the using entry is in the accumulator now
                if user == 1:
                    break
                m[self.ueq0] = 0
                first = self.ueq0 + 1
                state = 'done'
        # *0266B: the assignments
        hm1, e = ents[1]
        hdr = hm1 + 1
        if m[hdr] & 0o37 != 0o12:
            p = hdr + 1
            while m[p] == ASSIGN:
                p += 2
            p -= 3
            while True:
                put(m[p], ST)
                if p == hdr:
                    break
                self.acctype = m[p] >> 15 & 7
                p -= 2

    def use(self, ref, ents, user, use):
        """*0336B: the reference ref, now in the accumulator, is used at
        the place use of the entry user.  Returns 'entry' when the
        evaluation goes on with the next entry, 'done' when the using
        entry has been evaluated here."""
        m, put = self.m, self.put
        uhm1, uend = ents[user]
        need = True
        tmpr = ref & TYPE | 0o14
        eq = uhm1
        while m[eq + 2] == ASSIGN:
            eq += 2
        self.ueq0 = ueq = eq
        self.tmp = m[eq - 1] & TYPE | 0o14

        def store():
            if need:
                m[use] = put(self.tmp, ST)
            return 'entry'

        before = m[use - 1]
        if before == DIV:
            return store()
        if before == POWER:
            self.tmp = tmpr
            return store()
        if m[use + 1] == POWER:
            n = self.small_power(m[use + 2])
            if n is None:
                self.tmp = tmpr
                return store()
            base = put(tmpr, ST)
            self.setcell(0o105, base)
            self.inline_power(base, n, True)
            if before == MINUS:
                put(0, COMP)
            return 'done'
        if m[eq + 1] & 0o37 == 0o13:
            self.tmp = self.acctype << 15 | 0o14
            return store()
        if self.cell(0o107) and self.tmp == 0o14:
            return store()
        if m[eq + 1] & 0o37 == 2:
            ueq += 1
        if tmpr != self.tmp:
            if ueq + 2 == uend:
                if m[ueq] == MINUS:
                    put(0, COMP)
                return 'done'
            m[use] = put(self.tmp, ST)
            need = False
            self.acctype = self.tmp >> 15
        # *0441B: how far to the right the simple operands go
        rlim = uend
        p = use + 1
        while p != uend:
            if m[p + 1] & 0o37 in (0o11, 0o15):
                rlim = p
                break
            p += 2
        return self.absorb(ents, user, use, ueq, uend, rlim, need, store)

    def absorb(self, ents, user, use, ueq, uend, rlim, need, store):
        """*0451B: the accumulator takes in the simple operands around
        the reference, first those on the right while the operators allow,
        then those on the left, starting from the leftmost"""
        m, put = self.m, self.put
        before = m[use - 1]
        p = self.stronger(use - 1, ueq)
        if p is None:
            self.llim = ueq
        else:
            self.llim = p + 2
            if p + 3 == use:
                if before == MUL or m[use + 1] not in (MUL, DIV):
                    return store()
        left = use - 1          # M4
        right = use             # M6
        llop = m[self.llim]     # 32B
        rop = m[rlim]           # 27B
        eaten = 0               # M10: tokens taken out of the entry
        again = False           # 40B
        lab = 473
        while lab != 640:
            llim = self.llim
            if lab == 473:
                if right == llim:
                    if left == llim or self.compare(m[left], rop) == 1:
                        lab = 640
                    else:
                        lab = 534
                    continue
                right += 1
                rop = m[right]
                if m[left] != ASSIGN:
                    r = self.compare(m[left], rop)
                    if again:
                        if r:
                            lab = 640
                            continue
                    elif r != 1:
                        right -= 1
                        lab = 534
                        continue
                # *0506B: the operand on the right
                if right == rlim:
                    right = llim
                    lab = 640
                    continue
                right += 1
                if m[right + 1] == POWER or self.compare(rop, m[right + 1]) == 1:
                    lab = 640
                    continue
                put(m[right], opcode(rop))
                m[right] = m[right - 1] = 0
                eaten += 2
            elif lab == 534:
                # the operands on the left
                save = left
                if self.stronger(left, ueq) is not None:
                    lab = 640
                    continue
                if llim != ueq and save == llim:
                    lab = 640
                    continue
                lop = m[left]
                lab = 635
                if lop == ASSIGN:
                    continue
                m[left] = 0
                eaten += 1
                p = save
                if additive(lop):
                    if lop == MINUS:
                        put(0, COMP)
                    if p != llim:
                        p = llim
                        while True:
                            if m[p] == ASSIGN:
                                op = AD
                            else:
                                eaten += 1
                                op = AD if m[p] == PLUS else SU
                                m[p] = 0
                            p += 1
                            put(m[p], op)
                            m[p] = 0
                            eaten += 1
                            p += 1
                            if p == save:
                                break
                    if llim != ueq:
                        lab = 627
                else:
                    whole = True
                    while p != llim:
                        p -= 2
                        if additive(m[p]) or m[p] == ASSIGN:
                            whole = False
                            break
                    left = p
                    op = MU
                    first = not whole
                    while True:
                        if not first:
                            eaten += 1
                            op = opcode(m[p])
                            m[p] = 0
                        first = False
                        put(m[p + 1], op)
                        m[p + 1] = 0
                        eaten += 1
                        p += 2
                        if p == save:
                            break
                    lab = 627 if whole else 473
            elif lab == 627:
                eaten -= 1
                m[llim] = MUL if llop in (MUL, DIV) else PLUS
                lab = 635
            elif lab == 635:
                again = True
                left = llim
                lab = 473
        # *0640B
        if self.llim == ueq and uend == rlim:
            if eaten + ueq + 2 == uend + (m[self.llim] != ASSIGN):
                return 'done'
        if need or eaten:
            m[use] = put(self.tmp, ST)
            ents[user][1] = self.squeeze(self.llim, uend)
        return 'entry'
