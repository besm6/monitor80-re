"""Arithmetic expressions: module ARITHEXP of the overlay CONTROL,
rewritten from its disassembly (fortran/arithexp.asm).

The statement comes as an array of tokens (see lexer): operands are words
in the format of the generator (kind in the low bits: 1 constant,
010 variable, 013 function), operators are N<<24|2 (1 + 2 - 3 * 4 / 5 **
6 =), 3 is '(', 4 is ')', 5 is ',', 6 the end.

ARITHEXP cuts the expression into a table of flat subexpressions
(triads).  Every entry of the table is

    header, '=', token ..., 6

where the header is what receives the value: a reference n<<5|011 with the
type of the subexpression, or the variable of an assignment.  In the
token array a subexpression is replaced by its reference.  Subexpressions
are made of: the arguments of functions that hold operators, function
calls, parentheses, powers; a right part whose type differs from the type
of the assigned variable.  An entry equal to an earlier one is dropped,
both references become one "common" temporary n<<5|015.

The table is then given to the generator of expressions (expgen).
"""
from gen import CompileError

PLUS, MINUS, MUL, DIV, POWER, ASSIGN = (n << 24 | 2 for n in range(1, 7))
LPAR, RPAR, COMMA, END = 3, 4, 5, 6
FLPAR, FRPAR = 0o33, 0o34       # the parentheses of an argument list
TYPE = 0o700000
NOT20 = 0o7777777777777757
OPERATORS = (PLUS, MINUS, MUL, DIV, POWER)


class Arith:
    """m: the memory; table: address of the table of subexpressions."""

    def __init__(self, m, table, warn=None):
        self.m = m
        self.table = table
        self.warn = warn or (lambda code: None)
        self.common = 0         # D46106: number of common temporaries

    def error(self, code):
        raise CompileError(code)

    # ------------------------------------------------------------------
    def run(self, start, end):
        """the tokens start..end -> the table; returns the address of its
        last word"""
        m = self.m
        self.start, self.end = start, end
        self.depth = 0          # 777B
        self.nsub = 0           # 701B: number of the next subexpression
        self.common = 0
        self.length = end - start + 1
        self.out = self.table   # 703B
        for p in range(start, end + 1):
            if m[p] & 0o77777 == 0o15:
                m[p] = m[p] >> 3 << 3
        # functions, from the last one
        p = end
        while True:
            k = m[p] & 0o77
            if k == 0o13 or k == 0o53:
                self.function(p)
                if p == start:
                    break
                p -= 1
                continue
            if p == start:
                break
            p -= 1
        self.parens(start, end)
        self.statement()
        return self.out - 1

    def function(self, fpos):
        """the argument list of the function at fpos"""
        m = self.m
        depth = 0
        nargs = 0
        p = fpos + 1
        while m[p] == 0:
            p += 1
        if m[p] & 0o77777 != LPAR:
            # a function name without arguments: an argument itself
            if m[p] & 0o77777 not in (RPAR, COMMA):
                self.error(0o22202)
            p = fpos - 1
            while m[p] == 0:
                p -= 1
            if m[p] & 0o77777 not in (LPAR, COMMA):
                self.error(0o22202)
            m[fpos] = m[fpos] >> 6 << 6 | 0o10
            return
        m[p] += 0o30
        p += 1
        first = p
        while True:
            while m[p] == 0:
                p += 1
            t = m[p]
            if t == COMMA:
                if depth:
                    self.error(0o22201)
                self.argument(first, p - 1)
                p += 1
                first = p
                nargs += 1
                continue
            low = t & 0o77777
            if low == RPAR:
                if depth:
                    depth -= 1
                    p += 1
                    continue
                m[p] = 0
                self.argument(first, p)
                m[p] = FRPAR
                return
            if low == LPAR:
                depth += 1
            elif low == FLPAR:
                p += 1
                while m[p] & 0o77777 != FRPAR:
                    p += 1
            p += 1

    def argument(self, first, last):
        m = self.m
        self.parens(first, last)
        p = last
        while True:
            if m[p] & 0o37 == 2:
                self.subexpr(first, last)
                return
            if p == first:
                break
            p -= 1
        self.type_of(first, last)

    def parens(self, first, last):
        """*0214B: parentheses, function calls and powers of a range"""
        m = self.m
        stack = []
        p = first
        while True:
            t = m[p]
            low = t & 0o77777
            if t == 0:
                pass
            elif t == LPAR:
                stack.append(p)
                self.depth -= 1
            elif low == FLPAR or t == POWER and m[p + 1] & 0o37 == 0o13:
                if low != FLPAR:
                    p += 2
                m[p] = 0
                a = p - 1
                while True:
                    p += 1
                    if m[p] & 0o77777 == FRPAR:
                        break
                m[p] = 0
                b = self.after(p, p)
                p = self.group(a, b)
            elif t == POWER:
                p += 1
                if m[p] == LPAR:
                    stack.append(p)
                    self.depth -= 1
                else:
                    p = self.power(p - 1)
            elif low == RPAR:
                m[p] = 0
                b = self.after(p, p)
                if self.depth == 0:
                    raise Abort()
                self.depth += 1
                a = self.before(stack.pop())
                p = self.group(a, b)
            if p == last:
                return
            p += 1

    def group(self, a, b):
        """*0234B: the range a..b becomes a subexpression; a power with
        this exponent too.  Returns where to go on."""
        m = self.m
        self.subexpr(a, b)
        if a != self.start and m[a - 1] == POWER:
            self.power(a - 1)
        return b

    def power(self, pos):
        """*0537B: base ** exponent around pos; returns the place of the
        exponent"""
        m = self.m
        p = pos + 1
        while m[p] == 0:
            p += 1
        b = p
        p = pos - 1
        while m[p] == 0:
            p -= 1
        a = p
        p -= 1
        if m[p] == MINUS:
            p -= 1
            while m[p] == 0:
                p -= 1
            if m[p] in (LPAR, ASSIGN):
                a = p + 2
        self.subexpr(a, b)
        return b

    def after(self, p, last):
        """*0301B: p is a closing parenthesis; a multiplication is put in
        when an operand follows.  Returns the end of the range."""
        m = self.m
        while True:
            if p == self.end:
                return last
            p += 1
            t = m[p]
            if t == 0:
                continue
            if t == RPAR or t in OPERATORS:
                return last
            if t & 0o77777 == LPAR or t & 0o37 in (1, 0o10, 0o11, 0o13, 0o15, 0o30):
                m[p - 1] = MUL
                self.warn(0o2210)
                return p - 2
            return last

    def before(self, pos):
        """*0333B: pos is an opening parenthesis; a multiplication is put
        in when an operand precedes.  Returns the start of the range."""
        m = self.m
        p = pos
        while p != self.start:
            p -= 1
            t = m[p]
            if t == 0:
                continue
            if t == LPAR or t in OPERATORS or t == ASSIGN:
                break
            if t & 0o77777 in (RPAR, 1):
                m[p + 1] = MUL
                self.warn(0o2210)
                return p + 2
            break
        m[pos] = 0
        return pos

    def subexpr(self, a, b):
        """*0162B: the tokens a..b go to the table as a new entry, a
        reference takes their place"""
        m = self.m
        ref = self.nsub << 5 | 0o11
        self.nsub += 1
        head = self.out
        m[head] = ref
        m[head + 1] = ASSIGN
        o = head + 2
        for p in range(a, b + 1):
            if m[p]:
                m[o] = m[p] & NOT20
                o += 1
                m[p] = 0
        m[o] = END
        self.out = o + 1
        m[a] = ref
        ref |= self.type_of(head + 2, o - 1)
        m[head] = m[a] = ref
        self.same()

    def type_of(self, first, last):
        """*0355B: the type of a flat expression, as a field of a token"""
        m = self.m
        seen = [0] * 8
        p = first
        while m[p] & 0o17 == 0:
            p += 1
        if m[p] & 0o17 == 0o13:
            seen[m[p] >> 15 & 7] = 1
        else:
            operand = True      # an operand is expected
            if not m[p] & 0o7777777077777775:
                if m[p] not in (PLUS, MINUS):
                    self.error(0o22203)
                skip = True
            else:
                skip = False
            while True:
                if skip:
                    p += 1
                    if m[p] == 0:
                        if p == last:
                            break
                        continue
                skip = True
                operand = not operand
                if not operand:
                    # the operand has come
                    k = m[p] & 0o37
                    if k >> 3 == 0 and k >> 1:
                        self.error(0o22203)
                    seen[m[p] >> 15 & 7] = 1
                else:
                    if p == last:
                        self.error(0o22203)
                    t = m[p] & 0o7777777077777775
                    if t:
                        if t == RPAR:
                            break
                        self.error(0o22206)
                if p == last:
                    break
        if seen[4]:
            seen[0], seen[4] = seen[4], 0
        t = 7
        while not seen[t]:
            if t == 0:
                self.error(0o22203)
            t -= 1
        if t >> 1 == 3 and seen[t - 1]:
            self.error(0o22204)
        return t << 15

    def find(self, base, n, tok):
        """*0676B: the last of n words from base equal to tok (index), or None"""
        m = self.m
        while n:
            n -= 1
            if m[base + n] == tok:
                return n
        return None

    def same(self):
        """*0562B: the new entry is dropped when an earlier one is the same"""
        m = self.m
        tab = self.table
        new = self.find(tab, self.out - tab, ASSIGN)
        old = new
        while True:
            old = self.find(tab, old, ASSIGN)
            if old is None:
                return
            i, j = old, new
            while True:
                i += 1
                j += 1
                if m[tab + i] != m[tab + j]:
                    break
                if m[tab + j] == END:
                    break
            if m[tab + i] == m[tab + j]:
                break
        was = m[tab + old - 1]
        tok = was
        if was & 0o37 != 0o15:
            tok = was & TYPE | self.common << 5 | 0o15
            self.common += 1 + (was >> 16 & 1)
            m[tab + old - 1] = tok
            i = self.find(tab, new, was)
            if i is not None:
                m[tab + i] = tok
            else:
                self.replace(was, tok)
        self.replace(m[tab + new - 1], tok)
        for p in range(tab + new - 1, self.out + 1):
            m[p] = 0
        self.out = tab + new - 1

    def replace(self, was, tok):
        i = self.find(self.start, self.length, was)
        if i is None:
            self.error(0o22205)
        self.m[self.start + i] = tok

    def copy(self, p, o):
        """*0502B: the rest of the statement goes to the table"""
        m = self.m
        while True:
            if m[p]:
                m[o] = m[p] & NOT20
                o += 1
                m[p] = 0
            if p == self.end:
                break
            p += 1
        m[o] = END
        self.out = o + 1

    def statement(self):
        """*0444B: what is left is one flat expression or an assignment"""
        m = self.m
        eq = self.find(self.start, self.length, ASSIGN)
        if eq is None:
            t = self.type_of(self.start, self.end)
            m[self.out] = t | 0o12
            m[self.out + 1] = ASSIGN
            self.copy(self.start, self.out + 2)
            return
        right = self.start + eq + 1
        t = self.type_of(right, self.end)
        left = m[right - 2]
        if left & 0o17 != 0o10:
            self.error(0o22207)
        if left & TYPE != t:
            ref = self.nsub << 5 | 0o11 | t
            self.nsub += 1
            m[self.out] = ref
            m[self.out + 1] = ASSIGN
            self.copy(right, self.out + 2)
            m[right] = ref
        self.copy(self.start, self.out)


class Abort(Exception):
    """the expression is left as it is (unbalanced parentheses)"""
