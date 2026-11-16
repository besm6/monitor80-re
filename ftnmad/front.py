"""The front end: statements of one program unit -> calls of the generator.

Takes the place of SCANSTMT, CBDPR, CONTROL and ENDPRO of the original.
The tables live in the same memory array as the generator's (gen.py):
a name is a word of text, an operand is a word with a pointer to it.
"""
import re
from fractions import Fraction

import gen
import expgen
from arith import Arith, Abort, PLUS, MINUS, MUL, DIV, POWER, ASSIGN, \
    LPAR, RPAR, COMMA
from expgen import ExpGen
from logic import Logic
from items import text_word, parse_items, render, Unit

MASK48 = (1 << 48) - 1
TYPE = 0o700000
I, R, D, C, L = 0, 1, 2, 3, 4

# places of our tables in the memory (free areas beside the generator's)
ATTR = 0o40000          # attributes of the declared names
POOL = 0o41000          # constants
NAMES = 0o50000         # names of undeclared variables, labels, externals
TABLE = 0o60000         # the table of subexpressions
TOKENS = 0o64000        # the tokens of a statement

RELOPS = ['.EQ.', '.NE.', '.GT.', '.LT.', '.GE.', '.LE.']
OPS = {'+': PLUS, '-': MINUS, '*': MUL, '/': DIV, '**': POWER, '=': ASSIGN,
       '(': LPAR, ')': RPAR, ',': COMMA,
       '.AND.': 1 << 24 | 0o12, '.OR.': 2 << 24 | 0o12, '.NOT.': 3 << 24 | 0o12}
for _n, _op in enumerate(RELOPS):
    OPS[_op] = (_n + 1) << 24 | 0o22


# functions with any number of arguments (the start of the table in OPERAND)
VARARGS = ('AMAX0', 'AMAX1', 'AMIN0', 'AMIN1', 'MAX0', 'MAX1', 'MIN0', 'MIN1')


class Error(Exception):
    pass


def integer(n):
    """an integer constant as the compiler keeps it"""
    return 0o6400000000000000 | n


def real(x):
    """a non-negative fraction -> a normalized real number"""
    if x == 0:
        return 0
    e = 0
    while x >= 1:
        x /= 2
        e += 1
    while x < Fraction(1, 2):
        x *= 2
        e -= 1
    mant = int(x * (1 << 40))
    return (e + 64) << 41 | mant


class Sym:
    def __init__(self, name, ptr, typ):
        self.name, self.ptr, self.type = name, ptr, typ
        self.declared = False   # in a type statement
        self.param = False
        self.bss = False        # memory has been asked for
        self.value = False      # the value of the function
        self.words = [1]


LOGOP = r'(?:EQ|NE|GT|LT|GE|LE|AND|OR|NOT)'
TOKEN = re.compile(r'(\d+(?:\.(?!' + LOGOP + r'\.)\d*)?(?:E[+-]?\d+)?|\.\d+(?:E[+-]?\d+)?)'
                   r'|([A-Z][A-Z0-9]*)|(\*\*|[-+*/=(),]|\.' + LOGOP + r'\.)')


class Front:
    def __init__(self):
        self.m = m = [0] * 0o100000
        self.g = gen.Gen(m)
        self.assigned = set()
        self.eg = ExpGen(m, self.put)
        self.ar = Arith(m, TABLE)
        self.lg = Logic(m, self.put, self.arith, self.blabel)
        self.nb = 0             # labels *Bnnnn made
        self.nl = 0             # labels *Ln made
        self.ndo = 0            # DO loops (labels *Wnnnn, *Tnnnn)
        self.loops = []         # open DO loops, the innermost last
        m[gen.D33143 + 47] = ATTR
        m[gen.D33143 + 138] = text_word('ERASER')
        m[gen.D33143 + 137] = text_word('CERASE')
        m[gen.D33143 + 223] = 1
        self.syms = {}
        self.ndecl = 0          # names in the list of declared ones
        self.pool = POOL
        self.names = NAMES
        self.implicit = []
        self.labels = {}
        self.pending = []       # declared variables used for the first time
        self.kind = None        # 'PROGRAM', 'SUBROUTINE', 'FUNCTION'
        self.params = []
        self.entered = False
        self.functions = {}     # external functions: name -> token
        self.arrays = {}
        self.value_used = False
        self.relcn_cell = 0
        self.jumped = False     # the last statement was a jump

    def put(self, w1, w2):
        if w1 & 0o77777 == 0o10 and w2 & 0o77777 in (0o11, 0o12, 0o100, 0o101) \
                and not w2 >> 47:
            self.assigned.add(w1 >> 33)     # the variable gets a value
        return self.g.put(w1, w2)

    # ---- names --------------------------------------------------------
    def name_cell(self, text):
        p = self.names
        self.names += 1
        self.m[p] = text_word(text)
        return p

    def declare(self, name, typ=None, param=False):
        """a name into the list of declared ones"""
        s = self.syms.get(name)
        if s is None:
            p = gen.DIMENLIS + self.ndecl
            self.m[p] = text_word(name)
            s = self.syms[name] = Sym(name, p, typ if typ is not None
                                      else self.implied(name))
            self.m[gen.D33143 + 63] = self.ndecl
            self.ndecl += 1
        elif typ is not None:
            s.type = typ
        if param:
            s.param = True
            self.m[ATTR + s.ptr - gen.DIMENLIS] = 0o100000
        else:
            s.declared = True
        return s

    def implied(self, name):
        return I if name[0] in 'IJKLMN' else R

    def variable(self, name):
        s = self.syms.get(name)
        if s is None:
            s = self.syms[name] = Sym(name, self.name_cell(name), self.implied(name))
            s.bss = True
            self.implicit.append(name)
        elif s.value:
            self.value_used = True
        elif s.declared and not s.param and not s.bss:
            s.bss = True
            self.pending.append(s)
        return s.ptr << 33 | s.type << 15 | 0o10

    def function(self, name):
        t = self.functions.get(name)
        if t is None:
            s = self.syms.get(name)
            typ = s.type if s else self.implied(name)
            t = self.name_cell(name) << 33 | typ << 15 | 0o13
            if name in VARARGS:
                t |= 0o200
            self.functions[name] = t
        return t

    def constant(self, text):
        p = self.pool
        self.pool += 1
        if re.fullmatch(r'\d+', text):
            self.m[p] = integer(int(text))
            return p << 24 | 1
        mant, _, exp = text.partition('E')
        x = Fraction(mant) * Fraction(10) ** int(exp or 0)
        self.m[p] = real(x)
        return p << 24 | R << 15 | 1

    def label(self, n):
        n = str(int(n))
        if n not in self.labels:
            self.labels[n] = self.name_cell('*' + n)
        return self.labels[n] << 33 | 0o10

    def blabel(self):
        self.nb += 1
        return self.special('*B%04d' % self.nb)

    def arith(self, start, end):
        try:
            last = self.ar.run(start, end)
        except Abort:
            return
        self.eg.run(TABLE, last)

    def load(self, toks):
        for i, t in enumerate(toks):
            self.m[TOKENS + i] = t
        self.m[TOKENS + len(toks)] = 6
        return TOKENS + len(toks)

    def special(self, text):
        return self.name_cell(text) << 33 | 0o10

    # ---- statements ---------------------------------------------------
    def tokens(self, text):
        out = []
        pos = 0
        while pos < len(text):
            mt = TOKEN.match(text, pos)
            if not mt:
                raise Error('bad character: ' + text[pos:])
            pos = mt.end()
            if mt.group(1):
                out.append(self.constant(mt.group(1)))
            elif mt.group(2):
                name = mt.group(2)
                if text[pos:pos + 1] == '(' and name not in self.arrays:
                    out.append(self.function(name))
                else:
                    out.append(self.variable(name))
            else:
                out.append(OPS[mt.group(3)])
        return out

    def begin(self, label):
        """the start of an executable statement"""
        if not self.entered:
            self.entered = True
            name = self.unit_name
            self.put(self.name_cell(name) << 33 | 0o10, 0o47)
        for s in self.pending:
            self.put(s.ptr << 33 | 1 << 18 | s.type << 15 | 0o10, 0o57)
        self.pending = []
        self.put(0, 0o72)
        if label:
            self.put(self.label(label), 0o54)

    def statement(self, label, text):
        done = self.unit_statement(label, text)
        if label:
            self.close_loops(str(int(label)))
        return done

    def close_loops(self, label):
        """the ends of the DO loops with this terminal statement"""
        put = self.put
        while self.loops and self.loops[-1][0] == label:
            _, var, step, limit, wcell, tcell = self.loops.pop()
            self.m[gen.D33143 + 222] = var >> 15 & 7
            put(var, 0o110)
            put(0, 0o300000137)
            self.m[gen.D34621 + 73] = gen.NTR3     # the mode is known now
            put(step, 0o104)
            put(var, 0o100)
            if tcell:
                put(tcell, 0o5400000074)
            put(limit, 0o106)
            put(wcell, 0o2600000074)
            self.jumped = False

    def do(self, label, text):
        mt = re.match(r'DO(\d+)([A-Z][A-Z0-9]*)=([A-Z0-9]+),([A-Z0-9]+)(?:,([A-Z0-9]+))?$',
                      text)
        if not mt:
            return False
        end, var, first, limit, step = mt.groups()
        params = [self.tokens(p)[0] for p in (first, limit, step or '1')]
        var = self.variable(var)
        self.begin(label)
        self.ndo += 1
        wcell = self.name_cell('*W%04d' % self.ndo)
        tcell = 0
        self.put(params[0], 0o110)
        self.put(var, 0o100)
        if params[0] & 0o37 != 1 or params[1] & 0o37 != 1:
            # the loop starts with the test
            tcell = self.name_cell('*T%04d' % self.ndo)
            self.put(tcell << 33 | 0o10, 0o30)
        self.put(wcell, 0o5400000074)
        self.loops.append((str(int(end)), var, params[2], params[1], wcell, tcell))
        return True

    def unit_statement(self, label, text):
        m = self.m
        mt = re.match(r'(INTEGER|REAL)?(PROGRAM|SUBROUTINE|FUNCTION)([A-Z][A-Z0-9]*)'
                      r'(?:\((.*)\))?$', text)
        if mt and self.kind is None and '=' not in text:
            self.kind = mt.group(2)
            self.unit_name = mt.group(3)
            typ = {'INTEGER': I, 'REAL': R, None: None}[mt.group(1)]
            s = self.declare(self.unit_name, typ)
            s.declared = False
            for p in (mt.group(4) or '').split(','):
                if p:
                    self.params.append(self.declare(p, param=True))
            self.put(s.ptr << 33 | 0o10, 0o46)
            if self.kind == 'FUNCTION':
                # the name of a function is the variable of its value
                m[s.ptr] = text_word('*VALUE')
                s.value = True
            return
        if self.kind is None:
            raise Error('no PROGRAM statement')
        mt = re.match(r'(INTEGER|REAL|LOGICAL)(.*)$', text)
        if mt and '=' not in text:
            for n in mt.group(2).split(','):
                self.declare(n, {'INTEGER': I, 'REAL': R, 'LOGICAL': L}[mt.group(1)])
            return
        if text == 'END':
            if not self.jumped:
                if not self.entered:
                    self.begin(None)
                self.leave()
            return True
        self.jumped = False
        if text.startswith('IF('):
            depth = 0
            for i, c in enumerate(text):
                depth += (c == '(') - (c == ')')
                if c == ')' and depth == 0:
                    break
            cond, rest = text[2:i + 1], text[i + 1:]
            toks = self.tokens(cond)
            self.begin(label)
            mt = re.match(r'(\d+),(\d+),(\d+)$', rest)
            if mt:
                self.expression(toks)
                self.put(0, 0o7100000136)
                self.put(self.label(mt.group(2)), 0o26)
                self.put(0, 0o113)
                self.put(self.label(mt.group(1)), 0o26)
                self.put(self.label(mt.group(3)), 0o30)
                self.jumped = True
                return
            names = ['*L%d' % n if n else '*L0000' for n in (self.nl, self.nl + 1)]
            self.nl += 2
            cells = [self.name_cell(n) for n in names]
            end = self.load(toks)
            self.lg.run(TOKENS, end, cells[0] << 33 | 0o10, cells[1] << 33 | 0o10)
            self.put(cells[0], 0o5400000074)
            self.statement('', rest)
            self.put(cells[1], 0o5400000074)
            self.jumped = False
            return
        if text.startswith('DO') and ',' in text and self.do(label, text):
            return
        if '=' in text:
            toks = self.tokens(text)
            self.begin(label)
            self.assignment(toks)
            return
        mt = re.match(r'CALL([A-Z][A-Z0-9]*)(\(.*\))?$', text)
        if mt:
            f = self.function(mt.group(1))
            toks = [f | 0o100] + self.tokens(mt.group(2)) if mt.group(2) else None
            self.begin(label)
            if toks:
                # integer variables among the arguments may be changed
                ints = []
                for i in range(2, len(toks) - 1):
                    t = toks[i]
                    if t & 0o37 == 0o10 and not t & 0o77777777427 and t not in ints \
                            and not self.m[ATTR + (t >> 33) - gen.DIMENLIS & 0o77777] \
                            and toks[i - 1] in (LPAR, COMMA) and toks[i + 1] in (RPAR, COMMA):
                        ints.append(t)
                self.expression(toks)
                for t in reversed(ints):
                    self.put(t, 0o73)
            else:
                self.put(f, 0o10)
            self.put(self.relcn(), 0o5500003100000074)
            return
        self.begin(label)
        mt = re.match(r'GOTO(\d+)$', text)
        if mt:
            self.put(self.label(mt.group(1)), 0o30)
            self.jumped = True
        elif text == 'CONTINUE':
            pass
        elif text in ('STOP', 'RETURN'):
            self.leave(text == 'STOP')
            self.jumped = True
        else:
            raise Error('unknown statement: ' + text)

    def relcn(self):
        if not self.relcn_cell:
            self.relcn_cell = self.name_cell('*RELCN')
        return self.relcn_cell

    def leave(self, stop=False):
        """STOP in a main program, RETURN in a subprogram"""
        if stop or self.kind == 'PROGRAM':
            p = self.name_cell('STOP*')
            self.put(p << 33 | 0o10, 0o45)
            self.put(p << 33 | 0o13, 0o1500000000000031)
        else:
            self.put(self.special('*END'), 0o30)

    def expression(self, toks):
        m = self.m
        for i, t in enumerate(toks):
            m[TOKENS + i] = t
        try:
            last = self.ar.run(TOKENS, TOKENS + len(toks) - 1)
        except Abort:
            return
        self.eg.run(TABLE, last)

    def assignment(self, toks):
        m = self.m
        n = len(toks)
        if toks[1] == ASSIGN and any(t & 0o37 in (0o12, 0o22) for t in toks[2:]):
            yes, no = self.blabel(), self.blabel()
            end = self.load(toks)
            self.lg.run(TOKENS + 2, end, yes, no)
            self.put(yes, 0o2000000000000054)
            self.pool += 1
            m[self.pool - 1] = 1
            self.put((self.pool - 1) << 24 | 1, 0o110)
            self.put(no | 1 << 18, 0o30)
            self.put(no, 0o2000000000000054)
            self.put(0, 0o110)
            self.put(toks[0], 0o2000000000000100)
            return
        if n == 3 and toks[1] == ASSIGN and toks[0] == toks[2]:
            # V = V: nothing, but for an integer its index routine is called
            if not toks[0] & 0o77777777427:
                self.put(toks[0], 0o73)
            return
        # a constant, maybe with a minus, goes without the expression code
        if n in (3, 4) and toks[1] == ASSIGN and toks[-1] & 0o37 == 1 \
                and (n == 3 or toks[2] == MINUS) and toks[0] & 0o37 == 0o10:
            lt, rt = toks[0] >> 15 & 7, toks[-1] >> 15 & 7
            m[gen.D33143 + 222] = lt if rt < lt and lt != 4 else rt
            self.put(toks[-1], n - 3)
            self.put(toks[0], 0o12)
            return
        self.expression(toks)

    # ---- the end of the unit -------------------------------------------
    def epilogue(self):
        put = self.put
        if not self.entered:
            self.begin(None)
        if self.kind == 'FUNCTION':
            put(gen.DIMENLIS << 33 | 1 << 18 | 0o10, 0o57)
        for t in reversed(list(self.functions.values())):
            put(t >> 33 << 33 | 0o10, 0o45)
        for s in self.params:
            put(s.ptr << 33 | 1 << 18 | 0o100010, 0o57)
        put(self.special('*BEGIN'), 0o54)
        put(0, 0o700001000000144)
        put(0, 0o1600001200000144)
        put(self.name_cell('*C'), 0o710002400000074)
        for s in reversed(self.params):
            put(s.ptr, 0o10010100000074)
        put(0, 0o1500000143)
        nreg = self.m[gen.D33143 + 62]
        for r in range(1, nreg + 1):
            put(0, r << 24 | 0o143)
        put(0, 0o1000000143)
        put(0, 0o143)
        put(self.relcn(), 0o5510003100000074)
        put(0, 0o300000137)
        put(0, 0o200000137)
        put(0, 0o1200000000000030)
        put(self.special('*END'), 0o54)
        put(0, 0o141)
        put(0, 0o700000141)
        for r in range(nreg, 0, -1):
            put(0, r << 24 | 0o141)
        put(0, 0o1000000141)
        if self.kind == 'FUNCTION':
            put(self.special('*VALUE'), 0o22)
            put(0, 0o103)
        put(0, 0o1000000000000030)
        put(self.special('*LABEL'), 0o54)
        self.g.label = 0        # the last label is never written
        self.g.finish()

    def text(self):
        g = self.g
        implicit = [n for n in self.implicit if self.syms[n].ptr in self.assigned]
        unit = Unit(main=self.kind == 'PROGRAM', implicit=implicit,
                    temps=self.m[gen.D33143 + 55])
        return render(parse_items(g.decl[:-1]), parse_items(g.out[:-1]), unit)


def statements(lines):
    """the cards of one program unit -> (label, text without blanks)"""
    cur = None
    for l in lines:
        l = l.rstrip('\n').upper()[:72]
        if not l.strip() or l[0] in 'C*':
            continue
        if len(l) > 5 and l[5] not in ' 0' and cur:
            cur[1] += l[6:].replace(' ', '')
            continue
        if cur:
            yield tuple(cur)
        cur = [l[:5].strip(), l[6:].replace(' ', '')]
    if cur:
        yield tuple(cur)


def compile_text(src):
    """Fortran text -> lines of Madlen text"""
    out = []
    f = None
    for label, text in statements(src.splitlines()):
        if f is None:
            f = Front()
        if f.statement(label, text):
            f.epilogue()
            out += f.text()
            f = None
    return out
