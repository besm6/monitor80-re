"""Logical expressions: module LOGEXPR of the overlay CONTROL, rewritten
from its disassembly (fortran/logexpr.asm).

A logical expression is compiled into jumps: to one label when it is
true, to another when it is false.  Three passes:

1. The tokens are cut at the logical operators.  Every piece becomes a
   descriptor end<<30 | code<<24 | start<<6 | 011 of an arithmetic
   expression in the token array and of the test of its value.  A relation
   L op R is turned into a difference (the signs of one side are
   reversed in the token array); the relations .EQ. and .NE. of integers
   are compared by exclusive or instead (two expressions).
2. .NOT. is carried down to the descriptors (the low three bits of the
   code are reversed), exchanging .AND. and .OR. on the way.
3. For every descriptor: the code of the expression, a conditional jump
   to where to go when it is true and a jump to where to go when false -
   the outer labels or labels made here before the other descriptors.
"""
from gen import CompileError
from arith import PLUS, MINUS, LPAR, RPAR, END, TYPE

AND, OR, NOT = (n << 24 | 0o12 for n in (1, 2, 3))
FLAG = 1 << 47
OR_NOT = FLAG | OR          # made from .AND. under .NOT.
AND_NOT = FLAG | AND
ASN57 = 0o7100000136
# relation number -> code of the test
RELCODE = {1: 5, 2: 2, 3: 0o44, 4: 4, 5: 3, 6: 0o43}


def kind(t):
    return t & 0o37


class Logic:
    def __init__(self, m, put, arith, newlabel):
        """arith(start, end) compiles an arithmetic expression;
        newlabel() gives the operand word of a new label"""
        self.m, self.put, self.arith, self.newlabel = m, put, arith, newlabel

    def error(self, code):
        raise CompileError(code)

    def run(self, start, end, true, false):
        """tokens start..end-1 (m[end] ends them); jumps to the operand
        words true and false"""
        self.generate(self.negations(self.scan(start, end)), true, false)

    # ---- pass 1 ----------------------------------------------------------
    def scan(self, start, end):
        m = self.m
        buf = []
        p = start
        while True:
            depth = 0
            seg = p
            rel = None
            while True:
                t = m[p]
                if kind(t) == 0o22:
                    if rel:
                        self.error(0o24103)
                    self.operand_before(p, seg)
                    n = m[p + 1]
                    if n == RPAR or n == END or kind(n) == 0o12:
                        self.error(0o24105)
                    rel = (p, depth, RELCODE.get(t >> 24 & 7, 0o43))
                elif t == LPAR:
                    depth += 1
                elif t == RPAR:
                    depth -= 1
                elif kind(t) == 0o12:
                    if t >> 24 & 7 != 3:
                        self.operand_before(p, seg)
                    break
                if p == end:
                    break
                p += 1
            oper = p
            closing = []
            outer = max(depth, 0)
            while depth > 0:        # parentheses opened before the piece
                if m[seg] != LPAR:
                    self.error(0o24104)
                buf.append(LPAR)
                seg += 1
                depth -= 1
            while depth < 0:        # and closed after it
                if m[p - 1] != RPAR:
                    self.error(0o24104)
                closing.append(RPAR)
                p -= 1
                depth += 1
            if rel:
                buf.append(self.relation(seg, p, rel, outer))
                buf += closing
            elif p != seg:
                buf.append((p - 1) << 30 | 2 << 24 | seg << 6 | 0o11)
                buf += closing
            if oper == end:
                buf.append(END)
                return buf
            buf.append(m[oper])
            p = oper + 1

    def operand_before(self, p, seg):
        if p == seg or self.m[p - 1] == LPAR:
            self.error(0o24113)

    def relation(self, seg, p, rel, outer):
        """the descriptor of the relation in seg..p-1"""
        m = self.m
        rp, depth, code = rel
        n = depth - outer
        if n < 0:
            self.error(0o24105)
        for i in range(n):          # parentheses around the whole relation
            if m[p - 1] != RPAR or m[seg] != LPAR:
                self.error(0o24105)
            seg += 1
            p -= 1
        m[rp] = 0
        if code in (0o43, 0o44):
            if m[rp + 1] not in (PLUS, MINUS):
                m[rp] = PLUS
            seg = self.negate(seg, rp - 1, seg)
        elif code in (5, 2) and all(not m[q] & TYPE for q in range(seg, p)):
            m[rp] = END
            code = 0o41 if code == 2 else 0o46
        else:
            self.negate(rp + 1, p - 1, seg)
        return (p - 1) << 30 | code << 24 | seg << 6 | 0o11

    def negate(self, a, b, seg):
        """the signs of the terms of a..b are reversed; returns seg, moved
        back when a minus has been put before it"""
        m = self.m
        depth = 0
        t = m[a]
        if t == PLUS:
            m[a] = MINUS
        elif t == MINUS:
            m[a] = PLUS
        else:
            if t == LPAR:
                depth = 1
            m[a - 1] = MINUS
            if a == seg:
                seg -= 1
        p = a
        while p != b:
            p += 1
            t = m[p]
            if t == LPAR:
                depth += 1
            elif t == RPAR:
                depth -= 1
            elif depth == 0:
                if t == PLUS:
                    m[p] = MINUS
                elif t == MINUS:
                    m[p] = PLUS
        if depth:
            self.error(0o24105)
        return seg

    # ---- pass 2 ----------------------------------------------------------
    def negations(self, buf):
        out = []
        stack = [0]             # is the current level under .NOT.
        i = 0
        while True:
            t = buf[i]
            if kind(t) == 0o12:
                n = t >> 24 & 7
                if n == 3:
                    i += 1
                    t = buf[i]
                    if kind(t) == 0o11:
                        out.append(t if stack[-1] else t ^ 7 << 24)
                    else:
                        if t != LPAR:
                            self.error(0o24106)
                        stack.append(0 if stack[-1] else 1)
                        out.append(t)
                elif n == 1:
                    out.append(OR_NOT if stack[-1] else t)
                elif n == 2:
                    out.append(AND_NOT if stack[-1] else t)
                else:
                    self.error(0o24107)
            elif kind(t) == 0o11:
                out.append(t ^ 7 << 24 if stack[-1] else t)
            elif t == LPAR:
                stack.append(stack[-1])
                out.append(t)
            elif t == RPAR:
                stack.pop()
                out.append(t)
            elif t == END:
                out.append(t)
                return out
            i += 1

    # ---- pass 3 ----------------------------------------------------------
    def evaluate(self, t):
        m, put = self.m, self.put
        code = t >> 24 & 0o77
        start = t >> 6 & 0o77777
        end = t >> 30
        if code in (0o41, 0o46):
            p = start
            while kind(m[p]) != END:
                p += 1
            self.arith(p + 1, end)
            put(0, 0o143)
            self.arith(start, p - 1)
            put(0, 0o1700000000000112)
        else:
            self.arith(start, end)

    def generate(self, seq, true_out, false_out):
        put = self.put
        labels = {}             # place in seq -> label operand

        def label(k):
            if k not in labels:
                labels[k] = self.newlabel()

        def target(x):
            if isinstance(x, tuple):
                return x[0]
            if x not in labels:
                self.error(0o24110)
            return labels[x]

        k = 0
        while True:
            t = seq[k]
            if kind(t) != 0o11:
                if t == END:
                    return
                k += 1
                if k in labels:
                    put(labels[k], 0o2000000000000054)
                continue
            self.evaluate(t)
            save = k
            cur = t
            conj = False
            yes = no = None
            # what follows the operand
            while True:
                k += 1
                t = seq[k]
                if t != RPAR:
                    break
            if kind(t) == 0o12:
                k += 1
                if t >> 24 & 7 == 1:
                    conj = True
                    yes = k
                else:
                    no = k
                label(k)
                # the other way: over the operands that follow
                depth = 0
                state = 433
                while True:
                    t = seq[k]
                    if state == 433:
                        if kind(t) == 0o11:
                            k += 1
                            if seq[k] == END:
                                state = 454
                                break
                            state = 466
                        elif t == LPAR:
                            depth = 1
                            while True:
                                k += 1
                                t = seq[k]
                                if t == LPAR:
                                    depth += 1
                                elif t == RPAR:
                                    depth -= 1
                                    if depth == 0:
                                        break
                                elif t == END:
                                    self.error(0o24114)
                            k += 1
                            state = 515
                        else:
                            self.error(0o24112)
                    elif state == 466:
                        if kind(t) == 0o12:
                            state = 476
                        elif t == RPAR:
                            depth = 0o70000
                            k += 1
                            state = 515
                        elif t == LPAR:
                            state = 433
                        else:
                            k += 1
                            if seq[k] == END:
                                state = 454
                                break
                    elif state == 515:
                        if t == RPAR:
                            k += 1
                        elif t == END:
                            state = 454
                            break
                        elif kind(t) == 0o12:
                            state = 476
                        else:
                            k += 1
                            state = 433
                    elif state == 476:
                        n = t >> 24 & 7
                        if conj:
                            if n == 1 or t == OR_NOT:
                                k += 1
                                state = 433
                                continue
                            k += 1
                            no = k
                        else:
                            if n != 1 or t != AND_NOT and depth != 0o70000:
                                k += 1
                                state = 433
                                continue
                            k += 1
                            yes = k
                        label(k)
                        break
                if state == 454:
                    if conj:
                        no = (false_out,)
                    else:
                        yes = (true_out,)
            elif t == END:
                yes, no = (true_out,), (false_out,)
            else:
                self.error(0o24104)
            # the jumps
            yes = target(yes)
            c = cur >> 24 & 7
            if c in (2, 5):
                put(0, ASN57)
            put(yes, 0o26 if c in (3, 5, 6) else 0o27)
            put(target(no), 0o30)
            k = save + 1
            if k in labels:
                put(labels[k], 0o2000000000000054)
