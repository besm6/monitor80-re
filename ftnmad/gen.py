"""The code generator of FORTR* (module PUTAWAY of the root overlay),
rewritten from its disassembly (fortran/putaway.asm).

The parser calls put(w1, w2): w2 holds the operation in its low 15 bits
(and item bits: register, flags), w1 describes the operand:

    bits 48-34  pointer to the table entry (name word) of the operand
    bits 33-19  offset (or size for BSS)
    bits 18-16  type: 0 I, 1 R, 2 D, 3 C, 4-5 L
    low bits    kind: 010 variable, 001 constant, 014 temporary, 013 external

Operations 0-021 are abstract (load, add, ... store), typed by the type
of the accumulator and of the operand; the rest are machine instructions
and pseudo-operations that go to the output lists almost as they are.

The tables of the compiler are kept, as in the original, in one array of
48-bit words addressed like the memory of the overlay; the names CELL+n
used below are the common blocks of the original (see fortran/*.asm).
"""
from items import MASK48

D33143 = 0o33143
D34621 = 0o34621
DIMENLIS = 0o23440
IFLIST = 0o06636
D06466 = 0o06466
TEMPNAME = 0o06046           # a cell of PUTAWAY for a generated name


def relocate(delta):
    """move the tables (the test against a trace of the dubna simulator,
    where the root overlay is loaded 0253 words lower)"""
    global D33143, D34621, DIMENLIS, IFLIST, D06466, TEMPNAME
    D33143 += delta
    D34621 += delta
    DIMENLIS += delta
    IFLIST += delta
    D06466 += delta
    TEMPNAME += delta

B47 = 1 << 46               # an item starts a new word
B48 = 1 << 47
NTR3 = 0o300000137          # item NTR 3: integer mode
NTR18 = 0o2200000137        # item NTR 18: real mode
TYPE_LETTER = 'IRDCLL'

# operations done by instructions, in the order of the original table;
# the number selects the action
INLINE = ['I*AD*I', 'I*SU*I', 'R*AD*R', 'R*SU*R', 'R*MU*R', 'R*DI*R',
          'I*LO*I', 'R*LO*R', 'I*ST*I', 'R*ST*R', 'I*LN*I', 'R*LN*R',
          'I*ST*R', 'R*LO*I', 'R*LN*I', 'I*COMP', 'R*COMP', 'L*ST*L',
          'L*LO*L', 'I*AD*R', 'R*AD*I', 'I*SU*R', 'R*SU*I', 'I*MU*R',
          'R*MU*I', 'I*LO*L']
# operations done by library routines
LIBRARY = ['R*ST*I', 'I*MU*I', 'I*DI*I', 'I*PO*R', 'I*PO*D', 'R*DI*I',
           'R*PO*R', 'R*PO*I', 'I*PO*I', 'C*PO*I', 'R*PO*D', 'D*PO*R',
           'D*PO*I', 'D*PO*D', 'C*AD*I', 'C*SU*I', 'C*MU*I', 'C*DI*I',
           'C*AD*R', 'C*SU*R', 'C*MU*R', 'C*DI*R', 'C*AD*C', 'C*SU*C',
           'C*MU*C', 'C*DI*C', 'D*AD*D', 'D*SU*D', 'D*MU*D', 'D*DI*D',
           'D*AD*R', 'D*SU*R', 'D*MU*R', 'D*DI*R', 'D*AD*I', 'D*SU*I',
           'D*MU*I', 'D*DI*I', 'C*COMP', 'D*COMP', 'R*ST*C', 'R*ST*D',
           'D*ST*R', 'C*ST*C', 'C*ST*R', 'C*ST*I', 'D*ST*D', 'D*ST*I',
           'I*ST*D', 'C*LO*R', 'D*LO*R', 'C*LO*I', 'C*LO*C', 'D*LO*D',
           'C*LN*I', 'D*LO*I', 'C*LN*R', 'D*LN*R', 'R*LN*D', 'C*LN*C',
           'D*LN*D', 'I*LN*D', 'D*LN*I', 'I*PO*R', 'I*ST*C', 'I*ST*L']
OPNAME = {0: '*LO*', 1: '*LN*', 2: '*AD*', 3: '*SU*', 4: '*MU*', 5: '*DI*',
          6: '*COMP', 7: '*PO*', 0o12: '*ST*'}
# abstract operation -> machine instruction item
OPITEM = {0: 0o110, 2: 0o104, 3: 0o105, 4: 0o117, 5: 0o116, 0o12: 0o100}
# instructions before which the default (real) mode is restored
MODE_OPS = {0o31, 0o30, 0o26, 0o27, 0o34, 0o35, 0o37, 0o136, 0o115, 0o112, 0o113}


class CompileError(Exception):
    def __init__(self, code):
        Exception.__init__(self, 'error %o' % code)
        self.code = code


def text_word(s):
    w = 0
    for c in s.ljust(6)[:6]:
        w = w << 8 | ord(c)
    return w


class Gen:
    """PUTAWAY.  m is the table memory shared with the parser; decl and
    out receive the words of DECLIST and OUTLIST."""

    def __init__(self, m):
        self.m = m
        self.decl = []
        self.out = []
        self.real = NTR18           # the item of the default mode (*1623B)
        self.label = 0              # name of a pending label (*1451B)
        self.slot = [None, None]    # two last items, not yet written
        self.stmt = 0               # a statement mark is pending (*1435B)
        self.queue = []             # WTC/UTC items waiting for their instruction
        self.direct = False         # M6: emit without the queue
        self.w1 = self.w2 = self.op = 0
        self.name = self.w3 = 0     # *1422B, *1423B
        m[D34621 + 73] = NTR18

    # cells of the common blocks
    def d(self, n):
        return self.m[D33143 + n]

    def setd(self, n, v):
        self.m[D33143 + n] = v & MASK48

    def error(self, code):
        raise CompileError(code)

    # ---- output ---------------------------------------------------
    def flush(self):
        """*1371B: write the pending label and the two last items"""
        if self.label:
            self.out += [0o20000054, self.label]
            self.label = 0
        for i in (0, 1):
            if self.slot[i]:
                self.out += self.slot[i][:1 + (self.slot[i][0] >> 22 & 3)]
                self.slot[i] = None

    def emit(self, item, name=None, w3=None):
        """*1324B: one item to OUTLIST, through the window of two items.
        The second and the third word of an item stay in *1422B, *1423B."""
        m = self.m
        if name is not None:
            self.name = name
        if w3 is not None:
            self.w3 = w3
        if m[D34621 + 73] != self.real and (item & 0o77777) in MODE_OPS:
            m[D34621 + 73] = self.real
            self.emit(self.real)
        if self.stmt:
            self.flush()
            self.out.append(0o72)
            self.stmt = 0
        if self.d(151):
            item |= B47
            self.setd(151, 0)
        words = [item, self.name, self.w3]
        if self.slot[0] is None:
            self.slot[0] = words
        elif item & B47 or self.slot[1] is not None:
            self.flush()
            self.slot[0] = words
        else:
            self.slot[1] = words

    def emitq(self, item, name=None, w3=None):
        """*1262B: WTC and UTC wait until their instruction comes"""
        if name is not None:
            self.name = name
        if w3 is not None:
            self.w3 = w3
        name, w3 = self.name, self.w3
        if self.direct:
            self.emit(item, name, w3)
        elif (item & 0o77777) in (0o22, 0o23):
            if len(self.queue) == 3:
                self.error(0o70001)
            self.queue.append((item, name, w3))
        else:
            q, self.queue = self.queue, []
            for it in q:
                self.emit(*it)
            self.emit(item, name, w3)

    def mode(self, item):
        m = self.m
        if m[D34621 + 73] != item:
            m[D34621 + 73] = item
            self.emit(item)

    def wrdecl(self, *words):
        self.decl += words

    # ---- temporaries ----------------------------------------------
    def double(self, w1):
        return 1 if w1 & 0o200000 else 0

    def temp_mask(self, n, dbl):
        a = (B48 | (B47 if dbl else 0)) << 48 >> n
        return a >> 48, a & MASK48

    def temp(self, w1, new_ok):
        """*0660B/*0726B: allocate or release a temporary; returns w1 with
        the number of the temporary"""
        m = self.m
        n = w1 >> 5 & 0o1777
        if n == 0 and new_ok and (self.w2 & 0o77777) == 0o12:
            dbl = self.double(w1)
            lo = ~m[D33143 + 13] & MASK48
            hi = ~m[D33143 + 12] & MASK48
            if dbl:
                both = (hi << 48 | lo)
                both &= both << 1
                hi, lo = both >> 48 & MASK48, both & MASK48
            if hi:
                n = 48 - hi.bit_length()
            elif lo:
                n = 96 - lo.bit_length()
            else:
                self.error(0o27002)
            if dbl + n >= self.d(55):
                self.setd(55, dbl + n + 1)
            w1 |= n << 5
        elif m[D34621 + 75]:
            cnt = self.d(21)
            lst = [m[D33143 + 14 + i] for i in range(cnt)]
            if w1 not in lst:
                m[D33143 + 14 + cnt] = w1
                self.setd(21, cnt + 1)
            return w1
        else:
            dbl = self.double(w1)
        a, b = self.temp_mask(n, dbl)
        m[D33143 + 12] ^= a
        m[D33143 + 13] ^= b
        return w1

    # ---- operands -------------------------------------------------
    def prep(self, tmpl):
        """*0776B: the item for an instruction (tmpl) with the operand
        self.w1; may emit address instructions first"""
        m = self.m
        self.direct = False
        w1 = self.w1
        if w1 == 0:
            return tmpl, None, None
        kind = w1 & 0o37
        if kind == 0o14:
            w1 = self.w1 = self.temp(w1, True)
            item = (w1 & 0o77740) << 19 | self.d(32) | 0o20000000 | tmpl
            return self.stfun(item, self.d(138))
        if kind == 0o15:
            item = (w1 & 0o77740) << 19 | 0o20000000 | tmpl
            return self.stfun(item, self.d(137))
        if kind == 1:
            p = w1 >> 24 & 0o77777
            item = 0o20100000 | tmpl | self.d(32)
            if w1 & 0o200000:
                return item + 0o20000000, m[p], m[p + 1]
            return item, m[p], None
        if kind < 0o10:
            self.error(0o27005)
        if w1 & 0o77400:
            return self.indexed(tmpl)
        return self.plain(tmpl, 0, 0)

    def stfun(self, item, name):
        """*1202B/*1227B: a temporary; in a statement function (D34621+71)
        the name is *Xnnnn / *Ynnnn (D33143+138/137 set per function) and the
        number of the temporary is an offset: the item gets bits 39 and 22;
        an instruction with flags (bits 45-48 of w2) whose code has 0100
        becomes UTC name+offset and the instruction without an address"""
        if not self.m[D34621 + 71]:
            return item, name, None
        if not self.op >> 44 & 0o17:
            return item | 1 << 39 | 1 << 22, name, None
        if not item & 0o100:
            return item, name, None
        self.emitq(item & 0o7777777777700000 | 0o20000022, name)
        return self.op & 0o77777, None, None

    def indexed(self, tmpl):
        """*1002B: an operand with a subscript kept in an index register.
        Bits 15-9 of w1 number the subscript expression; six registers are
        tracked in D33143+91.. (the number) and D33143+85.. (the variables
        the subscript depends on, from IFLIST)."""
        m = self.m
        n = (self.w1 & 0o77400) >> 8
        tab = [m[D33143 + 91 + i] for i in range(6)]
        if n in tab:
            return self.plain(self.op, (tab.index(n) + 1) << 42, 1)
        self.direct = True
        r = 5
        for i in range(5):
            if tab[i] == 0:
                r = i
                break
        ireg = (r + 1) << 42
        m[D33143 + 91 + r] = n
        if r + 1 >= self.d(62):
            self.setd(62, r + 1)
        cnt = self.d(67)
        p = IFLIST
        pos = 0
        while True:
            if cnt == 0:
                self.error(0o27001)
            e = m[p]
            pos += 1
            if (e & 0o777770000000000) == n << 30 and e >> 45:
                break
            p += 1
            cnt -= 1
        k = min(e >> 45, 3)
        sig = 0
        for j in range(k):
            sig = (sig << 15) + (m[p + j] & 0o77777)
        m[D33143 + 85 + r] = sig
        if k == 1 and (m[IFLIST + pos - 1] & 0o7777700000) == 0o100000:
            # the subscript is a variable itself
            self.w1 = (m[IFLIST + pos - 1] & 0o77777) << 33
        else:
            m[TEMPNAME] = text_word('*I%04d' % n)
            self.w1 = TEMPNAME << 33
        self.emitq(*self.plain(0o20000023, 0, 0))
        self.setd(32, 0)
        self.emitq(ireg | 0o24)
        self.w1 = self.w1b
        self.direct = False
        return self.plain(self.op, ireg, 1)

    def plain(self, tmpl, ireg, m5):
        """*1113B: a variable, with an optional index register (ireg)"""
        m = self.m
        w1 = self.w1
        ptr = w1 >> 33
        idx = ptr - DIMENLIS
        bit43 = 0
        param = False
        if 0 <= idx <= self.d(63):
            attr = m[self.d(47) + idx]
            bit43 = attr & (1 << 42)
            if not bit43 and attr & 0o7700000:
                param = True
        longop = not tmpl & 0o100
        reg = tmpl & (0o17 << 42)
        split = False
        if not m5 and not longop and not reg and not param:
            # *1170B: a short instruction without a register
            if ptr == 0:
                reg = 0
            elif bit43:
                split = True
                reg = tmpl & 0o7777777777700000
            else:
                reg = 0o10000020000000
        elif param:
            # *1251B: a formal parameter is reached through its address
            self.direct = True
            self.emit(0o20000023 | self.d(32), m[DIMENLIS + idx])
            w1 = self.w1 = w1 & 0o77777000000
            ptr = 0
            split = bool(reg and m5)
        elif not longop:
            split = True
        else:
            split = bool(m5 and reg)
        a = (w1 & 0o77777000000) << 6 | self.d(32)
        name = text_word('')
        if ptr:
            name = m[ptr]
            a |= 0o20000000
        if split:
            self.emitq(a | 0o20000022 | ireg, name)
            a = 0
            ireg = 0
        a |= ireg | reg | (tmpl & 0o77777)
        return a, name, None

    # ---- the entry ------------------------------------------------
    def put(self, w1, w2=0):
        m = self.m
        self.w1, self.w2 = w1, w2
        self.w1s = w1               # *1414B
        self.w1b = w1               # *1416B
        if w2 & B47:
            self.setd(151, self.d(151) | 1)
        self.direct = False
        op = w2 & 0o77777
        self.op = w2                # *1415B/*1417B: the instruction
        if (w1 & 0o77777) == 0o10 and op in (0o11, 0o12, 0o100, 0o101) \
                and not w2 & B48:
            # an assigned variable: its bit in the set of known values is cleared
            i = (w1 >> 33) - self.d(37)
            if 0 <= i < self.d(66):
                i = self.d(66) - i - 1
                m[m[D34621 + 4] - (i >> 5)] &= ~(1 << (i & 31))
        if self.dispatch(op):
            self.setd(31, self.op)
            self.setd(20, self.w1)
        return self.w1

    def dispatch(self, op):
        """returns True when the operation is to be remembered as the last"""
        if op <= 0o21:
            return self.abstract(op)
        if op <= 0o43:
            if op == 0o23:
                self.mode(self.real)
            if self.w1:
                return self.short()
            return self.noaddr()
        if op <= 0o77:
            return self.pseudo(op)
        if op <= 0o127:
            return self.short()
        if op <= 0o145:
            return self.noaddr()
        self.error(0o44022)

    def noaddr(self):
        """*0074B: an instruction without an operand"""
        a = self.op
        if self.d(151):
            a |= B47
        self.emitq(a)
        return True

    def short(self):
        """*0231B: an instruction with an operand"""
        m = self.m
        op = self.op & 0o77777
        if op == 0o110 and (self.d(31) & 0o77777) in (0o100, 0o10) \
                and self.w1 == self.d(20):
            # the value is in the accumulator already
            if self.w1 & 0o37 != 0o14:
                return True
            self.w1 = self.temp(self.w1, True)
            for i in (1, 0):
                s = self.slot[i]
                if s and (s[0] & 0o77777) == 0o100:
                    if s[0] & B47:
                        self.setd(151, 1)
                    self.slot[i] = None
                    return False
            return True
        item = self.prep(self.op)
        self.emitq(*item)
        if op == 0o100 and (self.w1s & 0o77777777437) == 0o10:
            self.update()
        return True

    def update(self):
        """*0317B: after a store into an integer variable its index
        update routine is called (if there is one, GLINK decides)"""
        m = self.m
        save, self.real = self.real, NTR3
        a = (self.op & 0o6077777777700000) | 0o1500000000000031 | B48 \
            | m[D34621 + 74] | 0o20000000
        ptr = self.w1s >> 33
        self.emitq(a, m[ptr])
        self.real = save
        self.forget(ptr)

    def forget(self, ptr):
        """the index registers that depend on the variable are not valid"""
        m = self.m
        for k in range(3):
            for i in range(6):
                if (m[D33143 + 85 + i] >> (15 * k) & 0o77777) == ptr:
                    m[D33143 + 85 + i] = 0
                    m[D33143 + 91 + i] = 0

    def abstract(self, op):
        m = self.m
        if op >= 0o10:
            if op == 0o10:          # call of a subroutine
                self.op = 0o1500000000000031
                self.mode(self.real)
                return self.short() if self.w1 else self.noaddr()
            if op == 0o11:          # address of an argument
                self.op = 0o1600000000000024
                self.emitq(*self.prep(self.op))
                self.emit(0o1600000142 if self.w2 & B48 else 0o1600000143)
                if self.w2 & B47:
                    self.emit(0o20100115, B48)
                return True
            if op == 0o13:
                m[D34621 + 75] = 1
                self.setd(21, 0)
                return True
            if op == 0o14:
                m[D34621 + 75] = 0
                n = self.d(21)
                self.setd(21, 0)
                for i in range(n - 1, -1, -1):
                    self.temp(m[D33143 + 14 + i], False)
                    m[D33143 + 14 + i] = 0
                return False
            if op != 0o12:
                self.error(0o27003)
        if op == 7:
            return self.power()
        name = TYPE_LETTER[self.d(222)] + OPNAME[op]
        if op != 6:
            name += TYPE_LETTER[self.w1 >> 15 & 7]
        return self.typed(name, op)

    def typed(self, name, op):
        if name in INLINE:
            n = INLINE.index(name) + 1
            if n in (1, 2):
                self.mode(NTR3)
                self.op = OPITEM[op]
                return self.short()
            if n in (3, 4, 5, 6) or n >= 20 and n != 26:
                self.mode(self.real)
                self.op = OPITEM[op]
                return self.short()
            if n in (7, 8, 19, 26):
                self.op = 0o110
                return self.short()
            if n in (9, 10, 18):
                self.op = 0o100
                return self.short()
            if n == 13:             # I*ST*R
                self.mode(self.real)
                self.emit(0o104)
                self.op = 0o100
                return self.short()
            if n == 14:             # R*LO*I
                self.op = 0o110
                self.emitq(*self.prep(self.op))
                self.mode(self.real)
                self.emit(0o104)
                return True
            if n in (11, 12, 15):
                self.op = 0o110
                self.emitq(*self.prep(self.op))
            if n in (11, 16):
                self.mode(NTR3)
            else:
                self.mode(self.real)
            self.emit(0o106)
            return True
        if name not in LIBRARY:
            self.error(0o27003)
        self.op = 0o1600000000000024
        self.emitq(*self.prep(self.op))
        self.emit(0o20000010, text_word(name))
        return True

    def power(self):
        self.w1 = self.w1b = self.d(221)
        self.op = 0o1600000000000024
        self.emitq(*self.prep(self.op))
        self.emit(0o1600000142)
        self.w1 = self.w1b = self.d(220)
        name = TYPE_LETTER[self.d(221) >> 15 & 7] + '*PO*' \
            + TYPE_LETTER[self.w1 >> 15 & 7]
        return self.typed(name, 7)

    def begin_label(self):
        """*0163B: at a label nothing is known about the registers"""
        m = self.m
        for i in range(6):
            m[D33143 + 91 + i] = 0
            m[D33143 + 85 + i] = 0
        self.mode(self.real)
        last = 1 if self.slot[1] else 0 if self.slot[0] else None
        return last

    def set_label(self, name, last, target=None):
        """a jump to the label (target) right before it is dropped"""
        if last is not None:
            s = self.slot[last]
            if (s[0] & 0o77777) == 0o30 and not s[0] & 0o1707777700000000 \
                    and s[1] == (name if target is None else target):
                self.slot[last] = None
        if last is not None or self.label:
            self.flush()
        self.label = name
        if self.stmt:
            self.stmt = 0
            self.out.append(0o72)
        return True

    def pseudo(self, op):
        m = self.m
        w1, w2 = self.w1, self.op
        if op == 0o44:
            self.w1s = w1
            self.update()
            return True
        if op in (0o45, 0o46, 0o47, 0o50, 0o51, 0o52, 0o57, 0o53, 0o60) \
                or op == 0o54 and w2 & 0o7777700000000:
            if op == 0o54:
                w2 = self.op = w2 | 0o57
            if op in (0o53, 0o60):
                ptr = w1 >> 24 & 0o77777
            else:
                ptr = w1 >> 33
            item = ((w1 & 0o77777000000) << 6 | w2) + 0o20000000 & MASK48
            if (item & 0o77777) == 0o53 and self.label and not self.slot[0]:
                self.wrdecl(0o20000054, self.label)
                self.label = 0
            self.name = m[ptr]
            self.wrdecl(item, m[ptr])
            if op == 0o47:
                last = self.begin_label()
                self.set_label(m[ptr], last)
                return True
            return False
        if op == 0o54:
            last = self.begin_label()
            return self.set_label(m[w1 >> 33], last)
        if op == 0o55:
            self.wrdecl((w1 << 6 & 0o7777700000000) | 0o40000000 | 0o55,
                        m[w2 >> 24 & 0o77777], m[w1 >> 33])
            return False
        if op == 0o56:
            item = self.prep(self.op)
            self.emitq(*item)
            self.emit(*item)
            return False
        if op == 0o61:
            self.wrdecl(self.w2)
            return False
        if op == 0o72:
            self.stmt = 1
            self.setd(21, 0)
            self.setd(12, 0)
            self.setd(13, 0)
            return False
        if op == 0o73:
            self.setd(32, B48)
            item = self.prep(0o110)
            self.setd(32, 0)
            self.emitq(*item)
            self.w1s = w1
            self.update()
            return True
        if op == 0o74:
            item = (w2 & 0o7770000077700000) | (w2 >> 24 & 0o77777) | 0o20000000
            if w2 & 0o100000:
                self.op = 0o13
                self.emitq(item, w1)
                return True
            name = m[w1 & 0o77777]
            self.op = 0o13
            if w2 & B48 and (item & 0o77777) == 0o31:
                # after a CALL CONTROL forgets the index registers (its
                # *0767B, called after the call of *RELCN is put)
                for i in range(6):
                    m[D33143 + 91 + i] = 0
                    m[D33143 + 85 + i] = 0
            if (item & 0o77777) == 0o54:
                last = self.begin_label()
                return self.set_label(name, last, m[w1 >> 33])
            self.emitq(item | (w1 & 0o7777700000000), name)
            return True
        self.error(0o44022)

    def finish(self):
        self.flush()
        self.decl.append(0)
        self.out.append(0)
