"""The front end: statements of one program unit -> calls of the generator.

Takes the place of SCANSTMT, CBDPR, CONTROL and ENDPRO of the original.
COMMON, EQUIVALENCE and DATA are kept until the first executable statement
and done then, as CBPROC of CBDPR does (CBPRCZ, CBCE, CBBSS, CBEQU).
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
from items import text_word, word_text, parse_items, render, Unit

MASK48 = (1 << 48) - 1
TYPE = 0o700000
I, R, D, C, L = 0, 1, 2, 3, 4
LCONST = 5               # the type bits of a logical constant token

# places of our tables in the memory (free areas beside the generator's)
ATTR = 0o40000          # attributes of the declared names
POOL = 0o41000          # constants
NAMES = 0o50000         # names of undeclared variables, labels, externals
TABLE = 0o60000         # the table of subexpressions
TOKENS = 0o64000        # the tokens of a statement
IMPLICIT = 0o31223      # names of undeclared variables, downwards from here
                        # (the order of the pointers decides orders below)

RELOPS = ['.EQ.', '.NE.', '.GT.', '.LT.', '.GE.', '.LE.']
OPS = {'+': PLUS, '-': MINUS, '*': MUL, '/': DIV, '**': POWER, '=': ASSIGN,
       '(': LPAR, ')': RPAR, ',': COMMA,
       '.AND.': 1 << 24 | 0o12, '.OR.': 2 << 24 | 0o12, '.NOT.': 3 << 24 | 0o12}
for _n, _op in enumerate(RELOPS):
    OPS[_op] = (_n + 1) << 24 | 0o22


# functions with any number of arguments (the start of the table in OPERAND)
# the standard functions OPERAND knows (its table *1606B, *1646B): type
# and 0200 for any number of arguments
STDFUNC = {}
for _names, _attr in (('AMAX0 AMAX1 AMIN0 AMIN1', 1 << 15 | 0o200),
                      ('MAX0 MAX1 MIN0 MIN1 LOADGO', 0o200),
                      ('DMOD DEXP DLOG DLOG10 DATAN DATAN2 DSIN DCOS DSQRT DABS DSIGN '
                       'DBLE DINT', 2 << 15),
                      ('DMAX1 DMIN1', 2 << 15 | 0o200),
                      ('CABS', 1 << 15),
                      ('CEXP CLOG CSIN CCOS CSQRT CMPLX CONJG', 3 << 15)):
    for _n in _names.split():
        STDFUNC[_n] = _attr


class Error(Exception):
    pass


def integer(n):
    """an integer constant as the compiler keeps it"""
    return 0o6400000000000000 | n & 0o37777777777777


class Form:
    """a linear form of a standard subscript (an entry of IFLIST).
    kind 1-3: c*v terms (ptr, coef); kind 4-7: an array with variable
    dimensions, s1 + d1*(s2 - 1 + d2*(s3 - 1)) with si = ci*vi + ki: c, v
    (pointers or 0), d (pointers or constants), A = k2-1, B = k3-1;
    kind 4: two subscripts; 5, 6, 7: three, d1 constant, d2 constant, none"""
    def __init__(self, n, kind, terms=(), c=(), v=(), d=(), A=0, B=0):
        self.n, self.kind, self.terms = n, kind, list(terms)
        self.c, self.v, self.d, self.A, self.B = list(c), list(v), list(d), A, B

    def cell(self):
        """an *Innnn cell is needed (not just a variable)"""
        return self.kind > 3 or len(self.terms) > 1 or self.terms[0][1] != 1

    def variables(self):
        if self.kind <= 3:
            return [p for p, c in self.terms]
        return [p for p in self.v if p]


def signed_real(x):
    """a fraction -> a normalized real number; a negative mantissa is in
    [-1, -1/2), in two's complement"""
    if x >= 0:
        return real(x)
    e = 0
    while x < -1:
        x /= 2
        e += 1
    while x >= Fraction(-1, 2):
        x *= 2
        e -= 1
    return (e + 64) << 41 | int(x * (1 << 40)) & ((1 << 41) - 1)


def real_int(w):
    """the integer part of a word taken for a real number (an octal
    constant nB in a subscript: a tiny number, 0, unless n is large)"""
    mant = w & (1 << 41) - 1
    if mant >> 40:
        mant -= 1 << 41
    x = Fraction(mant, 1 << 40) * Fraction(2) ** ((w >> 41) - 64)
    return int(x)


def negate_real(w):
    """minus a non-negative normalized real number"""
    if w == 0:
        return 0
    x = Fraction(w & ((1 << 41) - 1), 1 << 40) * Fraction(2) ** ((w >> 41) - 64)
    return signed_real(-x)


class Eq:
    """an entry of the table of equivalences (D06466+69 in CBPRCZ): a
    variable; a root has the size of its class, another one the entry it
    is equivalenced to and its offset there"""
    def __init__(self, sym, size):
        self.sym, self.size = sym, size
        self.parent, self.off = None, 0
        self.done = False       # its EQU has been made (CBEQU)


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


def double(text, neg=False):
    """a constant with exponent D -> the two words of a double precision
    number: 80 bits of mantissa, 40 in each word (the low word has no
    exponent); negative: the mantissa in [-1, -1/2), two's complement.
    FIXME: the original computes it by the library routines of double
    precision, which lose some of the last bits"""
    mant, _, exp = text.partition('D')
    x = Fraction(mant) * Fraction(10) ** int(exp or 0)
    if x == 0:
        return 0, 0
    if neg:
        x = -x
    e = 0
    while abs(x) >= 1 and not x == -1:
        x /= 2
        e += 1
    while 0 < x < Fraction(1, 2) or Fraction(-1, 2) <= x < 0:
        x *= 2
        e -= 1
    m = int(x * (1 << 80)) & ((1 << 81) - 1)
    return (e + 64) << 41 | m >> 40, m & ((1 << 40) - 1)


class Sym:
    def __init__(self, name, ptr, typ):
        self.name, self.ptr, self.type = name, ptr, typ
        self.declared = False   # in a type statement
        self.param = False
        self.bss = False        # memory has been asked for
        self.value = False      # the value of the function
        self.words = [1]
        self.needmem = False    # an array or in EQUIVALENCE: BSS by CBBSS
        self.child = False      # equivalenced to another one: no BSS
        self.datad = False      # given a value by DATA
        self.external = False   # named in EXTERNAL (not a parameter)
        self.common = None      # the block of COMMON it is in
        self.cptr = 0           # its entry in the list of blocks
        self.ext = 0            # how far its equivalence class goes past
                                # its end (bits 25-39 of word 764B)


LOGOP = r'(?:EQ|NE|GT|LT|GE|LE|AND|OR|NOT)'
HOLLERITH = re.compile(r"(\d+)H|'([^']+)'")    # nH... or '...'
OCTAL = re.compile(r'([0-7]+)B(?![A-Z0-9])')    # an octal constant: a bare word
TOKEN = re.compile(r'(\d+(?:\.(?!(?:' + LOGOP + r'|TRUE|FALSE)\.)\d*)?(?:[ED][+-]?\d+)?'
                   r'|\.\d+(?:[ED][+-]?\d+)?)'
                   r'|([A-Z][A-Z0-9]*)|(\*\*|[-+*/=(),]|\.' + LOGOP + r'\.)'
                   r'|\.(TRUE|FALSE)\.')


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
        self.consts = {}
        self.names = NAMES
        self.implicit = []
        self.labels = {}
        self.pending = []       # declared variables used for the first time
        self.kind = None        # 'PROGRAM', 'SUBROUTINE', 'FUNCTION'
        self.params = []
        self.entered = False
        self.functions = {}     # external functions: name -> token
        self.io_funcs = {}      # FT*... routines used: name -> token
        self.nholl = 0          # long Hollerith constants *Hn ...
        self.pending_holl = []  # ... whose data is still to come
        self.formats = {}       # FORMAT labels: n -> cell of /n
        self.pending_formats = []   # FORMATs before the first statement
        self.after_do = False   # the next statement ends a group of CONTROL
        self.sfuncs = set()     # statement functions (no SUBP) ...
        self.sf_bound = 0       # ... at the start of self.functions (D33212)
        self.sf_args = {}       # dummy -> token while compiling one
        self.sf_count = {'R': 0, 'L': 0}    # cells R*nnnn, L*nnnn of dummies
        self.arrays = {}
        self.value_used = False
        self.relcn_cell = 0
        self.jumped = False     # the last statement was a jump
        self.impl = IMPLICIT
        # subscripts (OPERAND): the linear forms of the standard subscripts
        # (IFLIST), the variables they depend on (D32477+7), of which the
        # first `front` are DO variables with step 1 (D33143+84)
        self.iforms = {}        # the key of a form -> its number
        self.forms = []         # Form, by number - 1
        self.ivars = []
        self.front = 0
        self.nst = 0            # N*STnn variables of the statement
        self.nst_code = []      # their assignments, to be compiled first
        self.cells = {}         # name -> cell of a generated name
        self.update = []        # names of the variables with routines *Unnnn
        self.cforms = []        # the forms with cells *Innnn
        self.iterms = []        # their terms, sorted
        self.temp_used = False
        self.commons = []       # the texts of COMMON statements
        self.blocks = []        # [name, entry, [Sym]] (D06466+4, DIMENLIS+2100)
        self.nblist = 0         # entries in the list of blocks and their items
        self.equivs = []        # the texts of EQUIVALENCE statements
        self.datas = []         # the texts of DATA statements
        self.decl_done = False
        self.eq = {}            # name -> Eq
        self.eqlist = []        # Eq in the order they were made
        self.data_cell = 0
        self.raw = ''           # the statement as it is on the cards

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
            self.impl -= 1
            self.m[self.impl] = text_word(name)
            s = self.syms[name] = Sym(name, self.impl, self.implied(name))
            s.bss = True
            self.implicit.append(name)
        elif s.value:
            self.value_used = True
        elif s.external:
            pass
        elif s.declared and not s.param and not s.bss:
            s.bss = True
            self.pending.append(s)
        return s.ptr << 33 | s.type << 15 | 0o10

    def function(self, name):
        s = self.syms.get(name)
        if s is not None and s.param and name not in self.arrays:
            # a parameter procedure: called through the address it holds
            # (kind 0213, no SUBP)
            return s.ptr << 33 | s.type << 15 | 0o213
        if s is not None and s.external:
            return s.ptr << 33 | s.type << 15 | 0o13
        t = self.functions.get(name)
        if t is None:
            if name in STDFUNC and not (s and s.declared):
                t = self.name_cell(name) << 33 | STDFUNC[name] | 0o13
            else:
                typ = s.type if s else self.implied(name)
                t = self.name_cell(name) << 33 | typ << 15 | 0o13
            self.functions[name] = t
        return t

    def hollerith(self, body):
        """a Hollerith or quoted constant: up to 6 characters a constant
        word (ISO, blanks after); a longer one is data *Hn (its words come
        before the statement) used as an integer variable"""
        if len(body) <= 6:
            return self.const_word(int.from_bytes(body.ljust(6).encode('latin-1'), 'big'), I)
        body += ' ' * (-len(body) % 6)
        self.nholl += 1
        cell = self.name_cell('*H%d' % self.nholl) << 33 | 0o10
        self.pending_holl.append((cell, [int.from_bytes(body[i:i + 6].encode('latin-1'), 'big')
                                         for i in range(0, len(body), 6)]))
        return cell

    def constant(self, text):
        """a constant: one entry of the table for every value"""
        if re.fullmatch(r'\d+', text):
            return self.const_word(integer(int(text)), I)
        if 'D' in text:
            return self.const_word(double(text), D)
        mant, _, exp = text.partition('E')
        x = Fraction(mant) * Fraction(10) ** int(exp or 0)
        return self.const_word(real(x), R)

    def const_word(self, value, typ):
        p = self.consts.get((value, typ))
        if p is None:
            p = self.consts[value, typ] = self.pool
            if typ in (D, C):       # two words
                self.m[p], self.m[p + 1] = value
                self.pool += 2
            else:
                self.m[p] = value
                self.pool += 1
        return p << 24 | typ << 15 | 1

    def label(self, n):
        n = str(int(n))
        if n not in self.labels:
            self.labels[n] = self.name_cell('*' + n)
        return self.labels[n] << 33 | 0o10

    def blabel(self):
        self.nb += 1
        return self.special('*B%04d' % self.nb)

    def note_commons(self):
        """ARITHEXP after G46107: D33143+41 keeps the largest number of
        common temporaries (cells *Ynnnn of a statement function)"""
        c = gen.D33143 + 41
        self.m[c] = max(self.m[c], self.ar.common)

    def arith(self, start, end):
        try:
            last = self.ar.run(start, end)
        except Abort:
            return
        self.eg.run(TABLE, last)
        self.note_commons()

    def load(self, toks):
        for i, t in enumerate(toks):
            self.m[TOKENS + i] = t
        self.m[TOKENS + len(toks)] = 6
        return TOKENS + len(toks)

    def special(self, text):
        return self.name_cell(text) << 33 | 0o10

    # ---- statements ---------------------------------------------------
    def tokens(self, text, prev=None):
        """the tokens of a text; prev: the token before it (a function for
        the arguments of CALL)"""
        out = []
        pos = 0
        while pos < len(text):
            mh = HOLLERITH.match(text, pos)
            if mh:
                if mh.group(1):
                    n = int(mh.group(1))
                    body = text[mh.end():mh.end() + n]
                    pos = mh.end() + n
                else:
                    body = mh.group(2)
                    pos = mh.end()
                out.append(self.hollerith(body))
                continue
            mo = OCTAL.match(text, pos)
            if mo:
                # nB: the word itself, of type I (no integer format: it is
                # used without any conversion)
                out.append(self.const_word(int(mo.group(1), 8) & (1 << 48) - 1, I))
                pos = mo.end()
                continue
            mt = TOKEN.match(text, pos)
            if not mt:
                raise Error('bad character: ' + text[pos:])
            pos = mt.end()
            if mt.group(1):
                out.append(self.constant(mt.group(1)))
            elif mt.group(2):
                name = mt.group(2)
                if name in self.sf_args and text[pos:pos + 1] != '(':
                    out.append(self.sf_args[name])
                elif text[pos:pos + 1] == '(' and name in self.arrays:
                    end = closing(text, pos)
                    subs = [self.tokens(t) for t in split_top(text[pos + 1:end])]
                    out.append(self.subscripted(self.arrays[name], subs))
                    pos = end + 1
                elif text[pos:pos + 1] == '(':
                    out.append(self.function(name))
                else:
                    out.append(self.variable(name))
            elif mt.group(3):
                out.append(OPS[mt.group(3)])
            else:
                # a logical constant: a word 1 or 0; its token has the
                # type bits 5 (as SCANSTMT makes it)
                out.append(self.const_word(int(mt.group(4) == 'TRUE'), LCONST))
        return self.complexes(out, prev)

    def complexes(self, toks, prev=None):
        """OPERAND (*0036B): ( [sign] c, [sign] c ) with real constants c,
        the parenthesis not after a function, is a complex constant"""
        def real_const(t):
            return t & 0o77777777 == R << 15 | 1
        out = []
        i = 0
        while i < len(toks):
            t = toks[i]
            before = out[-1] if out else prev
            if t == LPAR and not (before is not None and before & 0o77777 in (0o13, 0o53, 0o213)):
                parts, j = [], i + 1
                for end in (COMMA, RPAR):
                    neg = False
                    if j < len(toks) and toks[j] in (PLUS, MINUS):
                        neg = toks[j] == MINUS
                        j += 1
                    if not (j + 1 < len(toks) and real_const(toks[j]) and toks[j + 1] == end):
                        break
                    w = self.m[toks[j] >> 24]
                    parts.append(negate_real(w) if neg else w)
                    j += 2
                if len(parts) == 2:
                    out.append(self.const_word(tuple(parts), C))
                    i = j
                    continue
            out.append(t)
            i += 1
        return out

    # ---- arrays and subscripts (OPERAND) --------------------------------
    def dimension(self, item, typ=None):
        """NAME(d1,...) of DIMENSION or of a type statement"""
        mt = re.match(r'([A-Z][A-Z0-9]*)\((.*)\)$', item)
        if not mt:
            self.declare(item, typ)
            return
        s = self.declare(mt.group(1), typ)
        # a dimension of a parameter array may be a parameter
        s.dims = [int(d) if d.isdigit() else d for d in mt.group(2).split(',')]
        if len(s.dims) > 3:
            raise Error('more than three dimensions')      # 42010

        s.bss = True
        self.arrays[s.name] = s
        if not s.param:
            s.needmem = True

    def size(self, s):
        """words taken by a variable"""
        n = 2 if s.type in (D, C) else 1
        if s.name in self.arrays:
            for d in self.arrays[s.name].dims:
                n *= d
        return n

    def standard(self, toks):
        """a standard subscript c*v+k, c*v-k, c*v, v+k, v-k, v or k (c and k
        integer constants, v an integer variable) -> (c, v, k), else None"""
        def const(t):
            return t & 0o77777 == 1 and not t & TYPE

        def value(t):
            w = self.m[t >> 24]
            if w >> 42 == 0o64:         # an integer
                return w & 0o77777777777777
            return real_int(w)          # an octal constant: by its value

        t = list(toks)
        if len(t) == 1 and const(t[0]):
            return 0, None, value(t[0])
        c, k = 1, 0
        if len(t) >= 3 and const(t[0]) and t[1] == MUL:
            c = value(t[0])
            t = t[2:]
        if not t or t[0] & 0o777777777 != 0o10:
            return None
        v = t[0] >> 33
        # a declared variable with memory of its own (EQUIVALENCE, DATA):
        # its size in the attributes makes it unfit (OPERAND *0125B)
        if any(x.ptr == v and (x.needmem or x.datad) for x in self.syms.values()):
            return None
        t = t[1:]
        if t:
            if len(t) != 2 or t[0] not in (PLUS, MINUS) or not const(t[1]):
                return None
            k = value(t[1]) if t[0] == PLUS else -value(t[1])
        return c, v, k

    def subscripted(self, s, subs):
        """the token of an element of the array s"""
        dims = s.dims
        word = s.ptr << 33 | s.type << 15 | 0o30
        forms = [self.standard(t) for t in subs]
        if None not in forms:
            # constant subscripts 1 at the end do not count
            r = len(forms)
            while r > 1 and forms[r - 1] == (0, None, 1):
                r -= 1
            if any(not isinstance(d, int) for d in dims[:r - 1]):
                return word | self.general(forms[:r], dims) << 8 \
                    | (forms[0][2] - 1 & 0o77777) << 18
            terms = {}
            off, mult = 0, 2 if s.type in (D, C) else 1     # words of an element
            for i, (c, v, k) in enumerate(forms[:r]):
                if v is not None:
                    terms[v] = terms.get(v, 0) + c * mult
                off += (k - 1) * mult
                if i < r - 1:
                    mult *= dims[i]
            word |= (off & 0o77777) << 18
            if terms:
                word |= self.iform(terms) << 8
            return word
        # a non-standard subscript: the number of the element is computed
        # into a variable first: s1 + d1*(s2 - 1 + d2*(s3 - 1 ...))
        self.nst += 1
        var = self.variable('N*ST%02d' % self.nst)
        expr = list(subs[0])
        for i in range(1, len(subs)):
            d = dims[i - 1]
            d = self.const_word(integer(d), I) if isinstance(d, int) else self.variable(d)
            expr += [PLUS, d, MUL, LPAR] \
                + subs[i] + [MINUS, self.const_word(integer(1), I)]
        expr += [RPAR] * (len(subs) - 1)
        self.nst_code.append([var, ASSIGN] + expr)
        k = 2 if s.type in (D, C) else 1        # words of an element
        return word | (-k & 0o77777) << 18 | self.iform({var >> 33: k}) << 8

    def iform(self, terms):
        """the number of a linear form of variables (an entry of IFLIST)"""
        key = tuple(sorted(terms.items()))
        n = self.iforms.get(key)
        if n is None:
            n = self.iforms[key] = len(self.forms) + 1
            self.forms.append(Form(n, len(key), terms=key))
            words = [coef << 15 | ptr for ptr, coef in key]
            words[0] |= len(key) << 45 | n << 30
            self.ifl_write(words)
        for ptr, coef in reversed(key):
            self.ivar(ptr)
        return n

    def general(self, forms, dims):
        """the form of a subscript of an array with variable dimensions"""
        c = [f[0] for f in forms] + [0]
        v = [f[1] or 0 for f in forms] + [0]
        d = [dims[i] if isinstance(dims[i], int) else self.syms[dims[i]].ptr
             for i in range(len(forms) - 1)] + [0]
        A = forms[1][2] - 1
        B = forms[2][2] - 1 if len(forms) > 2 else 0
        if len(forms) == 2:
            kind = 4
        else:
            kind = 4 + isinstance(dims[0], int) + 2 * isinstance(dims[1], int) \
                if not (isinstance(dims[0], int) and isinstance(dims[1], int)) else None
            kind = {5: 5, 6: 6, 4: 7}[kind]
        words = [c[0] << 15 | v[0], d[0] << 30 | c[1] << 15 | v[1],
                 d[1] << 30 | c[2] << 15 | v[2] if len(forms) > 2 else 0,
                 (A & 0o77777) << 30 | (B & 0o77777) << 15 | 0o77777]
        key = ('general', kind) + tuple(words)
        n = self.iforms.get(key)
        if n is None:
            n = self.iforms[key] = len(self.forms) + 1
            self.forms.append(Form(n, kind, c=c[:3], v=v[:3], d=d[:2], A=A, B=B))
            words[0] |= kind << 45 | n << 30
            self.ifl_write(words)
        for p in reversed(v):
            if p:
                self.ivar(p)
        return n

    def ifl_write(self, words):
        m = self.m
        p = gen.IFLIST + m[gen.D33143 + 67]
        for i, w in enumerate(words):
            m[p + i] = w
        m[gen.D33143 + 67] += len(words)

    def ivar(self, ptr):
        """the index of a variable in the list of index variables"""
        if ptr not in self.ivars:
            self.ivars.append(ptr)
        return self.ivars.index(ptr)

    def cell(self, text, kind=0o100010):
        """the operand word of a generated name"""
        if text not in self.cells:
            self.cells[text] = self.name_cell(text)
        return self.cells[text] << 33 | kind

    def begin(self, label, sfunc=False):
        """the start of an executable statement (or of a statement
        function: no entry yet)"""
        self.declarations()
        if not self.entered and not sfunc:
            self.entered = True
            name = self.unit_name
            self.put(self.name_cell(name) << 33 | 0o10, 0o47)
        for s in self.pending:
            self.put(s.ptr << 33 | self.size(s) << 18 | s.type << 15 | 0o10, 0o57)
        self.pending = []
        for item in self.pending_holl:
            self.format_out(*item)
        self.pending_holl = []
        self.put(0, 0o72)
        if label:
            self.put(self.label(label), 0o54)
        # the non-standard subscripts of the statement
        code, self.nst_code, self.nst = self.nst_code, [], 0
        for toks in code:
            self.expression(toks)

    def statement(self, label, text):
        # CONTROL compiles the statement after a DO in a group of its own
        # (*2155B..*2165B); at the end of the group (*1064B) it forgets the
        # index registers
        group, self.after_do = self.after_do, False
        done = self.unit_statement(label, text)
        if label:
            self.close_loops(str(int(label)))
        if group:
            self.forget_registers()
        return done

    def close_loops(self, label):
        """the ends of the DO loops with this terminal statement"""
        while self.loops and self.loops[-1][0] == label:
            self.close_loop(*self.loops.pop()[1:])

    def forget_registers(self):
        """CONTROL *0767B (with nothing kept): the index registers hold
        nothing known"""
        for i in range(6):
            self.m[gen.D33143 + 91 + i] = 0
            self.m[gen.D33143 + 85 + i] = 0

    def close_loop(self, var, step, limit, wcell, tcell):
        """the end of a DO loop: var += step, the test, the jump back"""
        put = self.put
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

    # ---- input and output -----------------------------------------------
    def library(self, name):
        """a routine of the input/output library: its SUBP item comes with
        its first use"""
        if name not in self.io_funcs:
            self.io_funcs[name] = self.name_cell(name) << 33 | 0o13
            self.put(self.io_funcs[name] & ~0o37 | 0o10, 0o45)
        return self.io_funcs[name]

    def format_label(self, n):
        n = str(int(n))
        if n not in self.formats:
            self.formats[n] = self.name_cell('/' + n)
        return self.formats[n] << 33 | 0o10

    def format(self, label):
        """FORMAT (...): its text from ( to the last ) in ISO code, blanks
        and all, in words of 6 characters: SECT *, LABEL /n, OCT ..., SECT *
        (before the first executable statement they wait for the DATA)"""
        if not label:
            raise Error('FORMAT without a label')
        raw = self.raw
        text = raw[raw.index('('):raw.rindex(')') + 1]
        text += ' ' * (-len(text) % 6)
        words = [int.from_bytes(text[i:i + 6].encode('latin-1'), 'big')
                 for i in range(0, len(text), 6)]
        item = (self.format_label(label), words)
        if self.decl_done:
            self.format_out(*item)
        else:
            self.pending_formats.append(item)

    def format_out(self, cell, words):
        star = self.cell('*', 0o10)
        self.put(star, 0o52)
        self.put(cell, 0o54)
        if not self.data_cell:
            self.data_cell = self.name_cell('')
        for w in words:
            self.m[self.data_cell] = w
            self.put(self.data_cell << 24 | 1, 0o53)
        self.put(star, 0o52)

    def implied_ivar(self, var, step):
        """the variable of an implied loop gets into the list of index
        variables when the loop gets its number: a new one at the end; with
        step 1 it changes places with the first one after the front (as for
        DO, but a new one is found at its place)"""
        v = self.ivars
        p = var >> 33
        if p not in v:
            v.append(p)
        i = v.index(p)
        if step in (None, '1') and i >= self.front:
            v[i], v[self.front] = v[self.front], v[i]
            self.front += 1

    def io_tree(self, text):
        """an input/output list -> [token of an item | name of a whole array
        | (items, var, params, step, n)], made as SCANSTMT and CONTROL do it
        before the code: the tokens (and subscript forms) in the order of
        the text, the implied loops numbered at their ends (their variables
        then go to the list of index variables)"""
        out = []
        for part in split_top(text):
            if part.startswith('(') and part.endswith(')'):
                parts = split_top(part[1:-1])
                k = next((i for i, x in enumerate(parts)
                          if re.fullmatch(r'[A-Z][A-Z0-9]*=[A-Z0-9]+', x)), None)
                if k is None:
                    # parentheses without a loop: just the items
                    out += self.io_tree(part[1:-1])
                    continue
                if not 2 <= len(parts) - k <= 3:
                    raise Error('bad implied DO: ' + part)
                items = self.io_tree(','.join(parts[:k]))
                var, first = parts[k].split('=')
                step = parts[k + 2] if len(parts) - k == 3 else None
                v = self.variable(var)
                if v & 0o77777777777 != I << 15 | 0o10 or var in self.arrays:
                    raise Error('the index of an implied DO: ' + var)     # 21010
                params = [self.do_param(p) for p in (first, parts[k + 1], step or '1')]
                self.ndo += 1
                self.implied_ivar(v, step)
                out.append((items, v, params, step, self.ndo))
            elif part in self.arrays:
                out.append(part)
            elif re.fullmatch(r'[A-Z][A-Z0-9]*\(.*\)', part) and \
                    part[:part.index('(')] not in self.arrays:
                # a function and its arguments: the original takes them for
                # items (the function as an external one)
                out.append(self.function(part[:part.index('(')]))
                out += self.io_tree(part[part.index('(') + 1:-1])
            else:
                toks = self.tokens(part)
                if len(toks) != 1 or toks[0] & 0o37 not in (1, 0o10, 0o30) and \
                        toks[0] & 0o37 < 0o10:   # a constant, a variable, an element
                    raise Error('an expression in an input/output list')    # 21010
                t = toks[0]
                if t & 0o77437 == 0o30:
                    t ^= 0o20       # constant subscripts: a variable with an offset
                out.append(t)
        return out

    def io_items(self, tree, f):
        """the calls of the routine f for the items of a list"""
        for node in tree:
            if isinstance(node, tuple):
                items, v, params, step, n = node
                loop = self.open_loop(n, v, params, step, True)
                self.io_items(items, f)
                self.close_loop(*loop)
            elif isinstance(node, str):
                # a whole array: loops by IMPL*k, k = 1 the innermost
                arr = self.arrays[node]
                k = len(arr.dims)
                base = self.ndo
                self.ndo += k
                ivs = [self.variable('IMPL*%d' % (j + 1)) for j in range(k)]
                for t in ivs:
                    self.implied_ivar(t, None)
                loops = []
                for j in range(k - 1, -1, -1):
                    d = arr.dims[j]
                    lim = self.constant(str(d)) if isinstance(d, int) else self.variable(d)
                    one = self.constant('1')
                    loops.append(self.open_loop(base + j + 1, ivs[j], [one, lim, one], None,
                                                True))
                self.io_item(self.subscripted(arr, [[t] for t in ivs]), f)
                for loop in reversed(loops):
                    self.close_loop(*loop)
            else:
                self.io_item(node, f)

    def io_item(self, t, f, var=True):
        """one item: ARG, CALL f (its SUBP before the first call), and 073
        for an integer variable (even a parameter)"""
        self.put(t, 0o11)
        if var:                     # two-word values: their own routines
            f = {D: 'FD', C: 'FC'}.get(t >> 15 & 7, 'FT') + f[2:]
        self.put(self.library(f), 0o10)
        if var and t & 0o37 == 0o10 and not t & 0o777427:
            self.put(t, 0o73)       # (an element with constant subscripts too)

    def io_statement(self, label, text):
        """PRINT n, PUNCH n, READ n, READ (u, n), WRITE (u, n), READ (u),
        WRITE (u), ENCODE/DECODE (c, n, a) [list]: the routine of the start
        (the unit or count, the format and the array before it; 073 for a
        unit or count in a variable), one for every item, the end:
                    start   item    end
        PRINT n     FT*571  FT*002  FT*003
        PUNCH n     FT*561  FT*002  FT*003
        READ n      FT*541  FT*002  FT*003
        ENCODE (c,n,a)  FT*611  FT*002  FT*003
        DECODE (c,n,a)  FT*531  FT*002  FT*003
        READ (u,n)  FT*521  FT*002  FT*003
        WRITE (u,n) FT*621  FT*002  FT*003
        READ (u)    FT*641  FT*642  FT*643
        WRITE (u)   FT*721  FT*722  FT*723
        (FD*nnn, FC*nnn for double precision and complex items)"""
        mt = re.match(r'(PRINT|PUNCH|READ)(\d+|[A-Z][A-Z0-9]*(?:\([^()]*\))?)(?:,(.*))?$', text)
        me = re.match(r'(ENCODE|DECODE)\(([A-Z0-9]+),(\d+|[A-Z][A-Z0-9]*(?:\([^()]*\))?),([A-Z][A-Z0-9]*(?:\([^()]*\))?)\)(.*)$',
                      text)
        array = None
        if mt:
            unit, fmt, lst = None, mt.group(2), mt.group(3)
            start = {'PRINT': 'FT*571', 'PUNCH': 'FT*561', 'READ': 'FT*541'}[mt.group(1)]
            item, end = 'FT*002', 'FT*003'
        elif me:
            unit, fmt, array, lst = me.group(2), me.group(3), me.group(4), me.group(5)
            start = 'FT*611' if me.group(1) == 'ENCODE' else 'FT*531'
            item, end = 'FT*002', 'FT*003'
        else:
            mt = re.match(r'(READ|WRITE)\(([A-Z0-9]+)(?:,(\d+|[A-Z][A-Z0-9]*(?:\([^()]*\))?))?\)(.*)$', text)
            unit, fmt, lst = mt.group(2), mt.group(3), mt.group(4)
            write = mt.group(1) == 'WRITE'
            if fmt:
                start = 'FT*621' if write else 'FT*521'
                item, end = 'FT*002', 'FT*003'
            else:
                start, item, end = ('FT*721', 'FT*722', 'FT*723') if write else \
                    ('FT*641', 'FT*642', 'FT*643')
        args = [self.tokens(unit)[0]] if unit else []
        ftok = None
        if fmt and not fmt.isdigit():
            # a format in an array, its element or a variable: passed like
            # a variable
            ftok = self.tokens(fmt)[0]
            if ftok & 0o77437 == 0o30:
                ftok ^= 0o20
        if array:
            t = self.tokens(array)[0]
            if t & 0o77437 == 0o30:
                t ^= 0o20       # constant subscripts: a variable with an offset
        tree = self.io_tree(lst) if lst else []
        self.begin(label)
        self.m[gen.D33143 + 222] = 0    # CONTROL: the calls are of type I
        if fmt and fmt.isdigit():
            args.append(self.format_label(fmt))
        elif fmt:
            args.append(ftok)
        if array:
            args.append(t)
        for t in args:
            self.put(t, 0o11)
        self.put(self.library(start), 0o10)
        # 073 for one of them: the last integer format variable or buffer of
        # ENCODE/DECODE, not a whole array (with the bit 0100), else a unit
        # or count in a variable
        def changeable(t):
            return t & 0o37 == 0o10 and not t & 0o777427
        late = [t for t, name in ((ftok, fmt), (args[-1], array))
                if name and not name.isdigit() and name not in self.arrays and changeable(t)]
        if late:
            self.put(late[-1] | 0o100, 0o73)
        elif unit and changeable(args[0]):
            self.put(args[0], 0o73)
        if tree:
            self.io_items(tree, item)
        self.put(self.library(end), 0o10)

    def do(self, label, text):
        mt = re.match(r'DO(\d+)([A-Z][A-Z0-9]*)=([A-Z0-9]+),([A-Z0-9]+)(?:,([A-Z0-9]+))?$',
                      text)
        if not mt:
            return False
        end, var, first, limit, step = mt.groups()
        params = [self.do_param(p) for p in (first, limit, step or '1')]
        var = self.variable(var)
        self.begin(label)
        self.ndo += 1
        self.loops.append((str(int(end)),) + self.open_loop(self.ndo, var, params, step))
        self.after_do = True
        return True

    def do_param(self, text):
        """a parameter of DO: an octal constant becomes an integer"""
        t = self.tokens(text)[0]
        if t & 0o77777777 == 1 and self.m[t >> 24] >> 42 != 0o64:
            t = self.const_word(integer(self.m[t >> 24]), I)
        return t

    def open_loop(self, n, var, params, step, implied=False):
        """the start of a DO loop (or of an implied one) number n: var =
        params[0]; the jump to the test *Tn if the bounds are not both
        constants; the label *Wn.  Returns what close_loop needs"""
        wcell = self.name_cell('*W%04d' % n)
        tcell = 0
        self.put(params[0], 0o110)
        self.put(var, 0o100)
        # a DO variable with step 1 goes to the front of the list of index
        # variables; but a new one is found "at place 0" (as in the original:
        # it stays at the end, and the front grows only while it is empty)
        if not implied:
            v = self.ivars
            if var >> 33 in v:
                i = v.index(var >> 33)
            else:
                v.append(var >> 33)
                i = 0
            if step in (None, '1') and i >= self.front:
                v[i], v[self.front] = v[self.front], v[i]
                self.front += 1
        if params[0] & 0o37 != 1 or params[1] & 0o37 != 1:
            # the loop starts with the test
            tcell = self.name_cell('*T%04d' % n)
            self.put(tcell << 33 | 0o10, 0o30)
        self.put(wcell, 0o5400000074)
        return var, params[2], params[1], wcell, tcell

    def unit_statement(self, label, text):
        m = self.m
        mt = re.match(r'(INTEGER|REAL|LOGICAL|DOUBLEPRECISION|COMPLEX)?(PROGRAM|SUBROUTINE|FUNCTION)'
                      r'([A-Z][A-Z0-9]*)'
                      r'(?:\((.*)\))?$', text)
        if mt and self.kind is None and '=' not in text:
            self.kind = mt.group(2)
            self.unit_name = mt.group(3)
            typ = {'INTEGER': I, 'REAL': R, 'LOGICAL': L, 'DOUBLEPRECISION': D,
                   'COMPLEX': C, None: None}[mt.group(1)]
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
        if self.kind is None and re.match(r'BLOCKDATA([A-Z][A-Z0-9]*)?$', text):
            # its name, if any, is not used: the module is named after its
            # first block of COMMON
            self.kind = 'BLOCK DATA'
            return
        if self.kind is None:
            raise Error('no PROGRAM statement')
        mt = re.match(r'(INTEGER|REAL|LOGICAL|DOUBLEPRECISION|COMPLEX|DIMENSION)(.*)$', text)
        if mt and '=' not in text:
            typ = {'INTEGER': I, 'REAL': R, 'LOGICAL': L, 'DOUBLEPRECISION': D, 'COMPLEX': C,
                   'DIMENSION': None}[mt.group(1)]
            for n in split_top(mt.group(2)):
                self.dimension(n, typ)
            return
        if re.match(r'EXTERNAL[A-Z][A-Z0-9]*(,[A-Z][A-Z0-9]*)*$', text):
            # a name in the list of declared ones, a procedure: SUBP for
            # every one (used or not), passed as a variable; a parameter
            # stays a parameter
            for n in text[8:].split(','):
                sym = self.declare(n)
                if not sym.param:
                    sym.external = True
                    self.functions.setdefault(n, sym.ptr << 33 | 0o13)
            return
        if text.startswith('COMMON') and '=' not in text:
            if self.decl_done:
                raise Error('COMMON after an executable statement')    # 21014
            self.commons.append(text[6:])
            return
        if text.startswith('EQUIVALENCE(') and '=' not in text:
            if self.decl_done:
                raise Error('EQUIVALENCE after an executable statement')   # 21014
            self.equivs.append(text[11:])
            return
        if re.match(r'DATA[A-Z][A-Z0-9]*(\([0-9,]*\))?[,/]', text):
            if self.decl_done:
                raise Error('DATA after an executable statement')      # 21014
            self.datas.append(unblank(self.raw)[4:])
            return
        if text.startswith('FORMAT(') and text.endswith(')'):
            self.format(label)
            return
        self.declarations()
        if text == 'END' and self.kind == 'BLOCK DATA':
            return True
        if self.kind == 'BLOCK DATA':
            raise Error('executable statement in BLOCK DATA')
        if text == 'END':
            if not self.jumped:
                if not self.entered:
                    self.begin(None)
                self.leave()
            return True
        self.jumped = False
        mf = re.match(r'(PRINT|PUNCH|READ|(?:READ|WRITE)\([A-Z0-9]+,)([A-Z][A-Z0-9]*)', text)
        if mf and re.match(r'(PRINT|PUNCH|READ)[A-Z][A-Z0-9]*(\([^()]*\))?(,|$)'
                         r'|(READ|WRITE)\([A-Z0-9]+,[A-Z][A-Z0-9]*(\([^()]*\))?\)', text):
            return self.io_statement(label, text)
        if re.match(r'(PRINT|PUNCH|READ)\d+(,|$)|(READ|WRITE)\([A-Z0-9]+(,\d+)?\)'
                    r'|(ENCODE|DECODE)\(', text):
            self.io_statement(label, text)
            return
        mt = re.match(r'([A-Z][A-Z0-9]*)\(([A-Z][A-Z0-9]*(?:,[A-Z][A-Z0-9]*)*)\)=(.*)$', text)
        if mt and not self.entered and mt.group(1) not in self.arrays:
            self.statement_function(label, mt.group(1), mt.group(2).split(','), mt.group(3))
            return
        mt = re.match(r'ENTRY([A-Z][A-Z0-9]*)$', text)
        if mt and self.kind in ('SUBROUTINE', 'FUNCTION'):
            # one more entry (without parameters: with them the original
            # gives error 01011)
            self.begin(label)
            self.put(self.name_cell(mt.group(1)) << 33 | 0o10, 0o47)
            return
        if text.startswith('IF('):
            depth = 0
            for i, c in enumerate(text):
                depth += (c == '(') - (c == ')')
                if c == ')' and depth == 0:
                    break
            cond, rest = text[2:i + 1], text[i + 1:]
            toks = self.tokens(cond)
            self.begin(label)
            toks = self.funcref(toks)
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
            toks = [f | 0o100] + self.tokens(mt.group(2), f) if mt.group(2) else None
            self.begin(label)
            if toks:
                toks = self.funcref(toks)
                # integer variables among the arguments may be changed (not
                # whole arrays)
                arrays = {self.syms[n].ptr for n in self.arrays}
                ints = []
                depth = 0       # only the arguments themselves, not those of
                for i in range(2, len(toks) - 1):       # functions in them
                    t = toks[i]
                    depth += (toks[i - 1] == LPAR) - (toks[i - 1] == RPAR)
                    if t & 0o37 == 0o10 and not t & 0o77777777427 and t not in ints \
                            and not self.is_param(t >> 33) and t >> 33 not in arrays \
                            and depth == 1 \
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
        mc = re.match(r'GOTO\((\d+(?:,\d+)*)\),?([A-Z][A-Z0-9]*)$', text)
        ma = re.match(r'GOTO([A-Z][A-Z0-9]*)(?:,\(\d+(?:,\d+)*\))?$', text)
        mi = re.match(r'ASSIGN(\d+)TO([A-Z][A-Z0-9]*)$', text)
        if mt:
            self.put(self.label(mt.group(1)), 0o30)
            self.jumped = True
        elif mc:
            # GO TO (n1, n2, ...), k: WTC k; UJ *; a table UJ n1, UJ n2 ...
            # (each on a word of its own)
            self.put(self.variable(mc.group(2)), 0o23)
            self.put(self.cell('*', 0o10), 0o30)
            for n in mc.group(1).split(','):
                self.put(self.label(n), 0o2000000000000030)
            self.jumped = True
        elif ma:
            # GO TO l [, (n1, ...)]: WTC l; UJ (the list is not used)
            self.put(self.variable(ma.group(1)), 0o23)
            self.put(0, 0o30)
            self.jumped = True
        elif mi:
            # ASSIGN n TO l: the address of the label into l
            self.put(self.label(mi.group(1)), 0o1600000000000024)
            self.put(0, 0o1600000143)
            self.put(self.variable(mi.group(2)), 0o101)
        elif text == 'CONTINUE':
            pass
        elif text == 'RETURN' or re.match(r'STOP[A-Z0-9]*$', text):
            self.leave(text != 'RETURN')      # (the number of STOP is not used)
            self.jumped = True
        elif re.match(r'(REWIND|BACKSPACE|ENDFILE)[A-Z0-9]', text) and '=' not in text:
            # REWIND u, BACKSPACE u, END FILE u: VJM *REWIN, *BACKS, *ENDFI
            # with the unit (a constant, a variable or an element with
            # constant subscripts) as the argument
            mt = re.match(r'(REWIND|BACKSPACE|ENDFILE)(.*)$', text)
            u = mt.group(2)
            t = self.tokens(u)
            if len(t) != 1 or t[0] & TYPE or \
                    t[0] & 0o37 == 0o30 and t[0] & 0o77437 != 0o30:
                raise Error('the unit must be an integer constant or variable')   # 21035
            if t[0] & 0o77437 == 0o30:
                t[0] ^= 0o20    # constant subscripts: a variable with an offset
            self.put(t[0], 0o11)
            f = self.library('*' + mt.group(1)[:5])
            self.put(f, 0o1500000000000031)
        elif text.startswith('PAUSE'):
            # PAUSE [n], n a constant 1..32767: VJM PAUSE* with the number
            # as the argument (without it: item 103)
            f = self.library('PAUSE*')
            n = text[5:]
            if not n:
                self.put(0, 0o103)
            elif n.isdigit() and 0 < int(n) < 32768:
                self.put(self.constant(n), 0o11)
            else:
                raise Error('PAUSE needs a constant 1..32767')     # 21035
            self.put(f, 0o1500000000000031)
        else:
            raise Error('unknown statement: ' + text)

    # ---- EQUIVALENCE and DATA (CBPROC of CBDPR) ------------------------
    def declarations(self):
        """at the first executable statement: the equivalences, memory for
        the arrays and equivalence classes, the EQUs, the data"""
        if self.decl_done:
            return
        self.decl_done = True
        for text in self.commons:
            self.common(text)
        for text in self.equivs:
            self.equivalence(text)
        self.blocks_out()
        self.bss()
        self.equs()
        for text in self.datas:
            self.data(text)
        for item in self.pending_formats:
            self.format_out(*item)

    def blist(self, word):
        """a new entry of the list of blocks and their variables"""
        p = gen.DIMENLIS + 2100 + self.nblist
        if self.nblist >= 500:
            raise Error('too many COMMON blocks and variables')     # 42146
        self.nblist += 1
        self.m[p] = word
        return p

    def common(self, text):
        """[/name/ | //] a, b(dims), ... [/name/ ...] (CBPRCZ *0050B)"""
        pos = 0
        name = ''
        while True:
            if text.startswith('//', pos):
                name = ''
                pos += 2
            elif text.startswith('/', pos):
                mt = re.compile(r'/([A-Z][A-Z0-9]*)/').match(text, pos)
                if not mt:
                    raise Error('bad / in COMMON')              # 22015
                name = mt.group(1)
                pos = mt.end()
            if any(b[0] == name for b in self.blocks):
                raise Error('a block named twice')              # 22040
            block = [name, self.blist(text_word(name)), []]
            self.blocks.append(block)
            while True:
                mt = re.compile(r'([A-Z][A-Z0-9]*)(\([^()]*\))?').match(text, pos)
                if not mt:
                    raise Error('bad / in COMMON')              # 22015
                pos = mt.end()
                self.common_item(block, mt.group(1), mt.group(2))
                if pos == len(text):
                    return
                if text[pos] == '/':
                    break
                if text[pos] != ',':
                    raise Error('no separator in COMMON')       # 22016
                pos += 1

    def common_item(self, block, name, dims):
        if any(name in (s.name for s in b[2]) for b in self.blocks):
            raise Error('a variable twice in COMMON')           # 22045
        s = self.syms.get(name)
        if s is None:
            s = self.declare(name)
            s.declared = False
        if s.param:
            raise Error('a parameter in COMMON')                # 22042
        if dims:
            if name in self.arrays:
                raise Error('dimensions given twice')           # 22021
            self.dimension(name + dims)
        s.common = block
        s.bss = True
        self.m[ATTR + s.ptr - gen.DIMENLIS] |= 1 << 42  # reached by UTC
        s.cptr = self.blist(text_word(name))
        block[2].append(s)

    def blocks_out(self):
        """BLOCK name, CONT variable (size) ... (CBCE); a block takes also
        what the equivalence classes of its variables add at its end"""
        for name, ptr, items in self.blocks:
            total = rest = 0
            for s in items:
                n = self.size(s)
                total += n
                rest = max(rest - n, 0, s.ext)
            total += rest
            self.put(ptr << 33 | (total & 0o77777) << 18 | 0o10, 0o50)
            for s in items:
                e = self.eq.get(s.name)
                if e:
                    if e.parent:
                        raise Error('error in COMMON/EQUIVALENCE')     # 22031
                    e.done = True
                self.put(s.cptr << 33 | self.size(s) << 18 | 0o10, 0o51)

    def equivalence(self, text):
        """(a, b, ...), ... (CBPRCZ *0230B)"""
        for group in split_top(text):
            if not (group.startswith('(') and group.endswith(')')):
                raise Error('error in EQUIVALENCE')             # 22023
            items = split_top(group[1:-1])
            if len(items) < 2:
                raise Error('error in EQUIVALENCE')             # 22023
            first = self.eq_item(items[0])
            for item in items[1:]:
                first = self.eq_merge(first, self.eq_item(item))

    def eq_item(self, text):
        """a variable or an array element with one constant subscript ->
        [root of its class, its offset in the root, size of the class]
        (*0416B)"""
        mt = re.fullmatch(r'([A-Z][A-Z0-9]*)(?:\((\d+)\))?', text)
        if not mt:
            raise Error('error in EQUIVALENCE: ' + text)        # 22023
        name, sub = mt.groups()
        off = 0
        if sub is not None:
            if name not in self.arrays:
                raise Error('no dimensions for ' + name)        # 22035
            off = int(sub) - 1
        s = self.syms.get(name)
        if s is None:
            s = self.declare(name)
            s.declared = False
        if s.type in (D, C):
            off *= 2        # words of an element
        if s.param:
            raise Error('a parameter in EQUIVALENCE')           # 22026
        s.needmem = s.bss = True
        e = self.eq.get(name)
        if e is None:
            e = self.eq[name] = Eq(s, self.size(s))
            self.eqlist.append(e)
            return [e, off, e.size]
        while e.parent:
            off += e.off
            e = e.parent
        return [e, off, e.size]

    def eq_merge(self, a, b):
        """two equivalenced places: the class of b goes into that of a, or
        the other way when b is further from the start of its class (or as
        far, and its class is larger); returns the place in the joint class.
        A class with a variable of COMMON always stays the root."""
        ca, cb = a[0].sym.common, b[0].sym.common
        if ca and cb:
            raise Error('equivalence covers COMMON blocks')     # 22041
        if a[0] is b[0]:
            if a[1] != b[1]:
                raise Error('a variable equivalenced to itself + n')    # 22047
            # the original makes the root its own child and loops in CBEQU
            raise NotImplementedError('an equivalence repeated')
        if ca or cb:
            if not ca:
                a, b = b, a
            d = a[1] - b[1]
            if d < 0:
                # b would begin before its block (*0605B)
                items = a[0].sym.common[2]
                pos = sum(self.size(s) for s in items[:items.index(a[0].sym)])
                if pos + d < 0:
                    raise Error('equivalence reorders COMMON')  # 22014
            # the offset and the size come from 15-bit fields of the table
            # (a negative offset, a place before the root, is a large
            # positive number here); the size goes back there modulo 2**15
            # but stays whole in the cell of the group (D02144+134) for the
            # next item of the same parentheses; the block is modulo 2**15
            t = (b[2] - b[1]) - (a[2] - (a[1] & 0o77777))
            if t >= 0:
                a[2] += t
                a[0].size = a[2] & 0o77777
                a[0].sym.ext |= t & 0o77777     # sic: the original ORs
            r = b[0]
            r.parent, r.off = a[0], d
            r.sym.child = True
            self.m[ATTR + r.sym.ptr - gen.DIMENLIS] |= 1 << 42
            return a
        if a[1] == b[1]:
            if a[2] < b[2]:
                a, b = b, a
            d = 0
        else:
            if a[1] < b[1]:
                a, b = b, a
            d = a[1] - b[1]
            if b[2] + d >= a[2]:
                a[2] = a[0].size = b[2] + d
        r = b[0]
        r.parent, r.off = a[0], d
        r.sym.child = True
        return a

    def bss(self):
        """memory for the arrays and the roots of equivalence classes, in
        the order of the list of declared names (CBBSS)"""
        for s in sorted(self.syms.values(), key=lambda s: s.ptr):
            if not gen.DIMENLIS <= s.ptr < gen.DIMENLIS + self.ndecl:
                continue
            if s.child or s.common or not s.needmem:
                continue
            e = self.eq.get(s.name)
            size = e.size if e else self.size(s)
            self.put(s.ptr << 33 | size << 18 | 0o10, 0o57)

    def equs(self):
        """name EQU name+offset for every variable equivalenced to another
        one, after the one it refers to (CBEQU: a pass over the table,
        repeated from the first one put off)"""
        start = 0
        while True:
            later = None
            for i in range(start, len(self.eqlist)):
                e = self.eqlist[i]
                if not e.parent or e.done:
                    continue
                p = e.parent
                if p.parent and not p.done:
                    if later is None:
                        later = i
                    continue
                self.put(p.sym.ptr << 33 | (e.off & 0o77777) << 18 | 0o10,
                         e.sym.ptr << 24 | 0o55)
                e.done = True
            if later is None:
                return
            start = later

    def data(self, text):
        """names/constants/, ... (CBPRCZ *1134B)"""
        pos = 0
        while pos < len(text):
            j = text.index('/', pos)
            names = split_top(text[pos:j])
            try:
                values, pos = self.data_values(text, j + 1)
            except (IndexError, ValueError):
                raise Error('bad DATA: ' + text)
            for name in names:
                self.data_item(name, values)
            if values:
                raise Error('more constants than variables in DATA')
            if text[pos:pos + 1] == ',':
                pos += 1

    def data_values(self, text, pos):
        """the constants up to the closing '/' -> [[word, type, repeat]],
        the place after the '/'"""
        out = []
        while True:
            rep = 1
            mt = re.match(r'(\d+)\*', text[pos:])
            if mt:
                rep = int(mt.group(1))
                pos += mt.end()
            mt = re.match(r"(\d+)H", text[pos:])
            if mt:
                n = int(mt.group(1))
                pos += mt.end()
                out.append([text_word(text[pos:pos + n]), R, rep])
                pos += n
            elif text[pos] == "'":
                k = text.index("'", pos + 1)
                out.append([text_word(text[pos + 1:k]), R, rep])
                pos = k + 1
            else:
                mt = re.match(r'\.(TRUE|FALSE)\.|([0-7]+)B|([-+]?)(\d+(?:\.\d*)?'
                              r'(?:[ED][-+]?\d+)?|\.\d+(?:[ED][-+]?\d+)?)', text[pos:])
                if not mt:
                    raise Error('not a constant in DATA: ' + text[pos:])     # 22044
                pos += mt.end()
                if mt.group(1):
                    out.append([int(mt.group(1) == 'TRUE'), L, rep])
                elif mt.group(2):
                    out.append([int(mt.group(2), 8), R, rep])
                else:
                    sign, num = mt.group(3), mt.group(4)
                    if 'D' in num:
                        out.append([double(num, sign == '-'), D, rep])
                    elif re.fullmatch(r'\d+', num):
                        out.append([integer(-int(num) if sign == '-' else int(num)),
                                    R if sign else I, rep])
                    else:
                        mant, _, exp = num.partition('E')
                        x = Fraction(mant) * Fraction(10) ** int(exp or 0)
                        out.append([signed_real(-x if sign == '-' else x), R, rep])
            if text[pos] == '/':
                return out, pos + 1
            if text[pos] != ',':
                raise Error('bad DATA: ' + text)                # 22032
            pos += 1

    def in_common(self, s):
        """is the variable in COMMON, or equivalenced into it?"""
        if s is None:
            return False
        e = self.eq.get(s.name)
        while e is not None and e.parent:
            e = e.parent
        return bool(s.common or e is not None and e.sym.common)

    def data_item(self, text, values):
        """one variable, array or element of DATA and its values: SECT
        name+offset (memory already given) or SECT *, LABEL name (a cell in
        the data part), OCT value [REP n] ..., SECT * (*1157B)"""
        mt = re.fullmatch(r'([A-Z][A-Z0-9]*)(?:\(([0-9,]+)\))?', text)
        if not mt:
            raise NotImplementedError('DATA item ' + text)
        name, subs = mt.groups()
        s = self.syms.get(name)
        star = self.cell('*', 0o10)
        if s is not None and s.param:
            raise Error('DATA for a parameter')                 # 22036
        if self.kind == 'BLOCK DATA' and not self.in_common(s):
            raise Error('DATA in BLOCK DATA for a variable not in COMMON')
        if subs is not None:
            if name not in self.arrays:
                raise Error('no dimensions for ' + name)        # 22035
            off, mult = 0, 2 if s.type in (D, C) else 1
            dims = self.arrays[name].dims
            for i, k in enumerate(subs.split(',')):
                off += (int(k) - 1) * mult
                if i < len(dims):
                    mult *= dims[i]
            count = 2 if s.type == C else 1     # a complex: two reals
            self.put(s.ptr << 33 | (off & 0o77777) << 18 | 0o10, 0o52)
        elif s is not None and (s.needmem or s.datad or s.common):
            # a double precision number takes one constant, a complex two
            count = self.size(s) // (2 if s.type == D else 1)
            self.put(s.ptr << 33 | 0o10, 0o52)
        else:
            if s is None:
                s = self.declare(name)
                s.declared = False
            s.bss = True
            count = 2 if s.type == C else 1     # a complex: two reals
            self.put(star, 0o52)
            self.put(s.ptr << 33 | 0o10, 0o54)
        s.datad = True
        if not self.data_cell:
            self.data_cell = self.name_cell('')
        while count:
            if not values:
                raise Error('fewer constants than variables in DATA')
            v = values[0]
            n = min(count, v[2])
            if v[1] in (D, C):
                # two words; REP marks that it repeats both
                for w in v[0]:
                    self.m[self.data_cell] = w
                    self.put(self.data_cell << 24 | v[1] << 15 | 1, 0o53)
                if n > 1:
                    self.put(0, 1 << 39 | n << 24 | 0o61)
            else:
                self.m[self.data_cell] = v[0]
                self.put(self.data_cell << 24 | v[1] << 15 | 1, 0o53)
                if n > 1:
                    self.put(0, n << 24 | 0o61)
            count -= n
            v[2] -= n
            if not v[2]:
                values.pop(0)
        self.put(star, 0o52)

    def is_param(self, ptr):
        """a formal parameter or a variable of COMMON: a call may change it"""
        i = ptr - gen.DIMENLIS
        return 0 <= i < self.ndecl and self.m[ATTR + i] != 0

    def relcn(self):
        if not self.relcn_cell:
            self.relcn_cell = self.name_cell('*RELCN')
        return self.relcn_cell

    def leave(self, stop=False):
        """STOP in a main program, RETURN in a subprogram"""
        if stop or self.kind == 'PROGRAM':
            self.put(self.library('STOP*'), 0o1500000000000031)
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
        self.note_commons()

    @staticmethod
    def logical(toks):
        """is an assignment logical (CONTROL at *0353B)?  Only when the
        statement has a logical operator, a relation or a logical constant
        somewhere (SCANSTMT's flag in cell 107); then the tokens from the
        left side on are looked at, not counting the arguments of
        functions: an operand of type LOGICAL or a logical constant, a
        logical operator or a relation makes it logical"""
        def dot(t):
            return t & 0o37 in (0o12, 0o22) or t & 0o700037 == LCONST << 15 | 1
        if not any(dot(t) for t in toks):
            return False
        i = 0
        while i < len(toks):
            t = toks[i]
            if t >> 15 & 7 in (L, LCONST) or dot(t):
                return True
            if t & 0o37 == 0o13:
                # skip the arguments, to the parenthesis that closes them
                depth = 0
                while True:
                    i += 1
                    if i >= len(toks):
                        return False
                    k = toks[i] & 0o37
                    depth += (k == LPAR) - (k == RPAR)
                    if depth <= 0 and k == RPAR:
                        break
            i += 1
        return False

    def sf_cell(self, name, typ):
        """a cell for a dummy or the value of a statement function: its name
        makes its type by the first letter if it can (R*, E* real, L*, I*
        integer); otherwise it is declared, with a BSS item here"""
        s = self.syms.get(name)
        if typ == self.implied(name):
            return self.variable(name)
        if s is None:
            s = self.declare(name, typ)
            s.declared = False
            s.bss = True
            self.put(s.ptr << 33 | self.size(s) << 18 | 0o10, 0o57)
        return s.ptr << 33 | typ << 15 | 0o10

    def statement_function(self, label, name, dummies, body):
        """F(a, b, ...) = expression: a routine labelled F; the addresses of
        the arguments are on the stack (the last one in A), their values
        go to cells R*nnnn / L*nnnn, the value to E*nnnn / D*nnnn"""
        def typ_of(n):
            s = self.syms.get(n)
            return s.type if s else self.implied(n)
        ftyp = typ_of(name)
        nsf = len(self.sfuncs)
        self.sfuncs.add(name)
        self.function(name)
        # the table of functions: the new one changes places with the first
        # entry after the statement functions (the order of the SUBP lines)
        names = list(self.functions)
        i, j = names.index(name), self.sf_bound
        names[i], names[j] = names[j], names[i]
        self.functions = {n: self.functions[n] for n in names}
        self.sf_bound += 1
        self.begin(label, sfunc=True)
        self.put(self.name_cell(name) << 33 | 0o10, 0o2000000000000054)
        args = {}
        for i in range(len(dummies) - 1, -1, -1):
            d = dummies[i]
            t = typ_of(d)
            letter = 'L' if t in (I, L) else 'R'
            self.sf_count[letter] += 1
            cell = self.sf_cell('%s*%04d' % (letter, self.sf_count[letter]), t)
            args[d] = cell
            store = 0o101 if i else 0o100      # STX while more remain
            self.put(0, 0o1600000140)
            self.put(0, 0o1600000000000110)
            if t in (D, C):
                self.put(cell & ~0o700000, 0o100)
                self.put(0, 0o1600000100000110)
                self.put(cell & ~0o700000 | 1 << 18, store)
            else:
                self.put(cell & ~0o700000, store)
        self.put(0, 0o1500000142)
        self.put(0o10, 0o103)
        # the value: E*/I* if the function has the type of its first
        # letter, D* if its type is declared (even the same)
        letter = 'D' if name in self.syms else 'E' if ftyp == R else 'I'
        value = self.sf_cell('%s*%04d' % (letter, nsf), ftyp)
        # G40152: the temporaries of a function are *Xnnnn+k, its common
        # subexpressions *Ynnnn+k; their counters start from 0
        m = self.m
        m[gen.D34621 + 71] = 1
        m[gen.D33143 + 138] = text_word('*X%04d' % nsf)
        m[gen.D33143 + 137] = text_word('*Y%04d' % nsf)
        m[gen.D33143 + 55] = m[gen.D33143 + 41] = 0
        self.sf_args = args
        try:
            toks = self.tokens(body)
        finally:
            self.sf_args = {}
        for s in self.pending:      # declared variables first used here
            self.put(s.ptr << 33 | self.size(s) << 18 | s.type << 15 | 0o10, 0o57)
        self.pending = []
        self.assignment([value, ASSIGN] + toks)
        self.put(0, 0o1700000000000023)
        self.put(0, 0o30)
        for cnt, cell in ((55, 138), (41, 137)):
            if m[gen.D33143 + cnt]:
                self.put((gen.D33143 + cell) << 33 | 0o10, m[gen.D33143 + cnt] << 24 | 0o54)
        m[gen.D34621 + 71] = 0
        m[gen.D33143 + 138] = text_word('ERASER')
        m[gen.D33143 + 137] = text_word('CERASE')
        m[gen.D33143 + 55] = m[gen.D33143 + 41] = 0

    def assignst(self, toks):
        """ASSIGNST: a logical assignment, by jumps to the stores of 1 and 0"""
        yes, no = self.blabel(), self.blabel()
        end = self.load(toks)
        self.lg.run(TOKENS + 2, end, yes, no)
        self.put(yes, 0o2000000000000054)
        self.put(self.const_word(1, I), 0o110)
        self.put(no | 1 << 18, 0o30)
        self.put(no, 0o2000000000000054)
        self.put(0, 0o110)
        self.put(toks[0], 0o2000000000000100)

    def funcref(self, toks):
        """FUNCREF: the arguments of functions (and of CALL) that are
        logical expressions are computed first, into *V0001, *V0002, ...
        (numbered anew in every statement), and replaced by these
        variables.  The functions are taken from the right end, so inner
        ones go first; the arguments from the left.  An argument is
        logical if it is longer than one token and has a logical operator
        or a relation (G44647)."""
        toks = list(toks)
        nv = 0
        i = len(toks) - 1
        while i >= 0:
            if toks[i] & 0o77 == 0o13 and i + 1 < len(toks) and toks[i + 1] & 0o37 == LPAR:
                start = j = i + 2
                depth = 0
                while j < len(toks):
                    k = toks[j] & 0o37
                    end_arg = depth == 0 and k in (COMMA, RPAR)
                    if end_arg:
                        arg = toks[start:j]
                        if len(arg) > 1 and any(t & 0o77777 in (0o12, 0o22) for t in arg):
                            nv += 1
                            v = self.variable('*V%04d' % nv) & ~0o700000 | L << 15
                            # the last argument still has the place of the
                            # closing parenthesis, cleared, at its end
                            self.assignst([v, ASSIGN] + arg + [0] * (k == RPAR))
                            toks[start:j] = [v]
                            j = start + 1
                        else:
                            j += 1
                        if k == RPAR:
                            break
                        start = j
                        continue
                    depth += (k == LPAR) - (k == RPAR)
                    j += 1
            i -= 1
        return toks

    def assignment(self, toks):
        m = self.m
        n = len(toks)
        if toks[1] == ASSIGN and self.logical(toks):
            self.assignst(self.funcref(toks))
            return
        if n == 3 and toks[1] == ASSIGN and toks[0] == toks[2]:
            # V = V: nothing, but for an integer its index routine is called
            if not toks[0] & 0o77777777427:
                self.put(toks[0], 0o73)
            return
        # a constant, maybe with a minus, goes without the expression code
        if n in (3, 4) and toks[1] == ASSIGN and toks[-1] & 0o37 == 1 \
                and (n == 3 or toks[2] == MINUS) and toks[0] & 0o17 == 0o10:
            lt, rt = toks[0] >> 15 & 7, toks[-1] >> 15 & 7
            m[gen.D33143 + 222] = lt if rt < lt and lt != 4 else rt
            self.put(toks[-1], n - 3)
            self.put(toks[0] & ~0o20, 0o12)
            return
        self.expression(self.funcref(toks))

    # ---- the end of the unit -------------------------------------------
    def epilogue(self):
        put = self.put
        if self.kind == 'BLOCK DATA':
            # CONTROL ends it with this item only (no code)
            put(0o10, 0o56)
            self.g.finish()
            return
        if not self.entered:
            self.begin(None)
        if self.kind == 'FUNCTION':
            n = 2 if self.syms[self.unit_name].type in (D, C) else 1
            put(gen.DIMENLIS << 33 | n << 18 | 0o10, 0o57)
        # externals: those with declared names, backwards in the order of
        # the declarations, then the others backwards in the order of their
        # first use (FORTR* 04341: the table from its end down to the
        # statement functions)
        names = list(self.functions)[self.sf_bound:]
        decl = sorted((n for n in names if n in self.syms and self.syms[n].ptr < IMPLICIT
                       and self.syms[n].ptr >= gen.DIMENLIS),
                      key=lambda n: self.syms[n].ptr)
        for n in reversed([n for n in names if n not in decl] + decl):
            t = self.functions[n]
            put(t >> 33 << 33 | 0o10, 0o45)
        self.index_routines()
        for s in self.params:
            put(s.ptr << 33 | 1 << 18 | 0o100010, 0o57)
        put(self.special('*BEGIN'), 0o54)
        put(0, 0o700001000000144)
        put(0, 0o1600001200000144)
        put(self.name_cell('*C'), 0o710002400000074)
        n = len(self.params)
        if n >= 6:              # the addresses of the parameters stored by a loop
            put(0, 0o11 << 42 | n << 24 | 0o24)
            put(0, gen.B47 | 0o11 << 42 | 0o77777 << 24 | 0o25)
            put(0, 0o11 << 42 | 0o22)
            put(gen.DIMENLIS + 1, 0o10010100000074)
            put(self.cell('*') >> 33 | 0o77777 << 24, 0o1110003500000074)
        else:
            for s in reversed(self.params):
                put(s.ptr, 0o10010100000074)
        put(0, 0o1500000143)
        nreg = self.m[gen.D33143 + 62]
        if nreg >= 4:           # the index registers saved by a loop
            put(0, 0o11 << 42 | (1 - nreg & 0o77777) << 24 | 0o24)
            put(0, gen.B47 | 0o11 << 42 | nreg << 24 | 0o143)
            put(self.cell('*') >> 33, 0o1110003700000074)
        else:
            for r in range(1, nreg + 1):
                put(0, r << 24 | 0o143)
        put(0, 0o1000000143)
        put(0, 0o143)
        if self.iterms:
            self.coef_cells()
        put(self.relcn(), 0o5510003100000074)
        put(0, 0o300000137)
        self.index_cells()
        put(0, 0o200000137)
        put(0, 0o1200000000000030)
        put(self.special('*END'), 0o54)
        put(0, 0o141)
        if nreg >= 6:           # and restored by a loop
            put(0, 0o1100000700000024)
            put(0, 0o3107777700000025)
            put(0, 0o1100000100000141)
            put(self.cell('*') >> 33 | 0o77777 << 24, 0o1110003500000074)
        else:
            put(0, 0o700000141)
            for r in range(nreg, 0, -1):
                put(0, r << 24 | 0o141)
        put(0, 0o1000000141)
        if self.kind == 'FUNCTION':
            typ = self.syms[self.unit_name].type
            if typ in (D, C):
                # the value goes into the double accumulator
                put(0, 0o103)
                put(self.special('*VALUE') | typ << 15, 0)
            else:
                put(self.special('*VALUE'), 0o22)
                put(0, 0o103)
        put(0, 0o1000000000000030)
        if self.temp_used:
            put(self.cell('*TEMP', 0o10) | 1 << 18, 0o57)
        put(self.special('*LABEL'), 0o54)
        self.g.label = 0        # the last label is never written
        self.g.finish()

    def index_routines(self):
        """ENDPRO: the cells *Innnn of the linear forms of subscripts and the
        routines *Unnnn that update them when a variable changes (and *Pnnnn
        for a step of 1 of a DO variable)"""
        put = self.put
        # a form of one variable with coefficient 1 is that variable itself
        forms = self.cforms = [f for f in self.forms if f.cell()]
        if not forms:
            return
        star = self.cell('*')
        for f in forms:
            put(star, 0o52)
            put(self.cell('*I%04d' % f.n), 0o54)
            put(self.const_word(integer(0), I), 0o53)
            put(star, 0o52)
        put(self.cell('I*MUI*'), gen.B47 | 0o45)
        # variables that no cell depends on drop out of the list
        used = {p for f in forms for p in f.variables()}
        names = [self.m[p] if p in used else text_word('*CALLC') for p in self.ivars]
        # formal parameters may change in a call: *RELCN updates them
        relcn = False
        for i in range(self.ndecl - 1, -1, -1):
            p = gen.DIMENLIS + i
            if self.is_param(p) and self.m[p] in names:
                if not relcn:
                    relcn = True
                    put(self.relcn() << 33 | 0o100010, 0o54)
                    put(0, 0o1500001400000144)
                put(p << 33 | 0o100010, 0o73)
        if relcn:
            put(0, 0o1400000000000030)
            names.append(text_word('*RELCN'))
        self.inames = names
        # the terms: [variable, coefficient, form, tag, m1, m2]; the tag
        # says that the coefficient is in a cell: 1 *Knnnn, 2-3 *Mnnnn
        terms = []
        for f in forms:
            if f.kind <= 3:
                terms += [[names.index(self.m[p]), coef, f.n, 0, 0, 0] for p, coef in f.terms]
                continue
            c1, c2, c3 = f.c
            v1, v2, v3 = f.v
            d1, d2 = f.d
            if f.kind == 5:
                c2, c3 = c2 * d1, c3 * d1
            elif f.kind == 6:
                c3 *= d2
            tag1 = 0 if f.kind == 5 else 1
            tag2 = 3 if f.kind == 7 else 2
            for p, c, tag, m1, m2 in ((v1, c1, 0, d1, d2), (v2, c2, tag1, d1, d2),
                                      (v3, c3, tag2, d2, d1) if f.kind == 6
                                      else (v3, c3, tag2, d1, d2)):
                if p:
                    terms.append([names.index(self.m[p]), c, f.n, tag, m1, m2])
        # sorted by the variable (the selection sort of the original, which
        # is not stable: it decides the order of the updates)
        for last in range(len(terms) - 1, 0, -1):
            best = last
            for j in range(last - 1, -1, -1):
                if terms[j][0] > terms[best][0]:
                    best = j
            terms[best], terms[last] = terms[last], terms[best]
        self.iterms = list(terms)
        terms.append([0o7777777, 0, 0, 0, 0, 0])
        i = 0
        while i < len(terms) - 1:
            vi = terms[i][0]
            group = []
            while terms[i][0] == vi:
                group.append(i)
                i += 1
            self.routine(vi, group, terms)
        self.update = [word_text(w).strip() for w in names]

    def coef_cell(self, term):
        return self.cell(('*K%04d' if term[3] == 1 else '*M%04d') % term[2])

    def routine(self, vi, group, terms):
        put = self.put
        ncell = self.cell('*N%04d' % vi)
        var = self.ivars[vi] << 33 | 0o100010
        temp = self.cell('*TEMP')
        if vi < self.front:
            pcell = self.cell('*P%04d' % vi)
            put(pcell, 0o54)
            for j in group:
                icell = self.cell('*I%04d' % terms[j][2])
                if terms[j][3]:
                    put(self.coef_cell(terms[j]), 0o110)
                else:
                    put(self.const_word(integer(terms[j][1]), I), 0o110)
                put(icell, 0o104)
                put(icell, 0o100)
            put(self.const_word(integer(1), I), 0o110)
            put(ncell, 0o104)
            put(ncell, 0o100)
            put(0, 0o1500000000000030)
            put(pcell, gen.B47 | 0o30)
        put(ncell | 1 << 18, 0o57)
        put(self.cell('*U%04d' % vi), 0o54)
        put(ncell, 0o105)       # the difference of the new and old values
        put(ncell, 0o100)
        in_temp = False         # the product is in *TEMP
        diff = True             # the difference is in the accumulator
        for j in group:
            coef, n, tag = terms[j][1], terms[j][2], terms[j][3]
            same = terms[j + 1][:2] == terms[j][:2] and not tag and not terms[j + 1][3]
            if coef != 1 or tag:
                if in_temp:
                    put(temp, 0o110)
                    self.temp_used = True
                    in_temp = same
                else:
                    if not diff:
                        put(ncell, 0o110)
                    if tag:
                        put(self.coef_cell(terms[j]), 0o103)
                    else:
                        put(self.const_word(integer(coef), I), 0o103)
                    put(self.cells['I*MUI*'], 0o1610003100000074)
                    in_temp = same
                    if same:
                        put(temp, 0o100)
            else:
                if not diff:
                    put(ncell, 0o110)
                in_temp = False
            icell = self.cell('*I%04d' % n)
            put(icell, 0o104)
            put(icell, 0o100)
            diff = False
        put(var, 0o110)
        put(ncell, 0o100)
        put(0, 0o1500000000000030)

    # ---- the cells of arrays with variable dimensions, at the entry -----
    def mul(self, p):
        """XTS p; VJM I*MUI* (a dimension or a cell)"""
        self.put(p, 0o103)
        self.put(self.cells['I*MUI*'], 0o1610003100000074)

    def dim(self, d):
        return d << 33 | 0o100010

    def coef_cells(self):
        """*Knnnn and *Mnnnn: the coefficients that hold dimensions"""
        put = self.put
        first = True
        for t in reversed(self.iterms):
            vi, c, n, tag, m1, m2 = t
            if not tag:
                continue
            if first:
                first = False
                put(0, 0o300000137)
            if tag == 1:
                if c == 1:
                    put(self.dim(m1), 0o110)
                else:
                    put(self.const_word(integer(c), I), 0o110)
                    self.mul(self.dim(m1))
            else:
                if c == 1:
                    put(self.dim(m2), 0o110)
                else:
                    put(self.const_word(integer(c), I), 0o110)
                    self.mul(self.dim(m2))
                if tag == 3:
                    self.mul(self.dim(m1))
            cell = self.coef_cell(t)
            put(cell, 0o100)
            put(cell | 1 << 18, 0o57)

    def index_cells(self):
        """the initial values of the cells *Innnn of the forms with variable
        dimensions, from the last values of the variables (*Nnnnn)"""
        put = self.put
        for f in self.cforms:
            if f.kind <= 3:
                continue
            c1, c2, c3 = f.c
            d1, d2 = f.d
            if f.kind == 5:
                c2, c3 = c2 * d1, c3 * d1
            elif f.kind == 6:
                c3 *= d2
            nv = [self.cell('*N%04d' % self.inames.index(self.m[p])) if p else 0
                  for p in f.v]
            A, B = f.A, f.B
            t1, t2, t3 = (c1 and nv[0]), (c2 and nv[1]), (c3 and nv[2])

            def const(x, op):
                put(self.const_word(integer(x), I), op)

            def load(c, v):
                if not c or not v:
                    put(0, 0o110)
                elif c == 1:
                    put(v, 0o110)
                else:
                    const(c, 0o110)
                    self.mul(v)

            def add(c, v):
                if not c or not v:
                    return
                if c == 1:
                    put(v, 0o104)
                else:
                    const(c, 0o103)
                    self.mul(v)
                    put(0, 0o17 << 42 | 0o104)

            def addc(x):
                if x:
                    const(x, 0o104)

            icell = self.cell('*I%04d' % f.n)

            def finish(times):
                # * d1 (or d2), + c1*v1, -> *Innnn
                self.mul(self.dim(times))
                add(c1, nv[0])
                put(icell, 0o100)

            def only_first():
                if t1:
                    load(c1, nv[0])
                    put(icell, 0o100)

            def two():                  # kind 4 (*1012B)
                if t2:
                    load(c2, nv[1])
                    addc(A)
                elif A:
                    const(A, 0o110)
                else:
                    only_first()
                    return
                finish(d1)

            if f.kind == 4:
                two()
            elif f.kind == 5:           # *1037B
                if t3 or B * d1:
                    if t3:
                        load(c3, nv[2])
                        addc(B * d1)
                    else:
                        const(B * d1, 0o110)
                    self.mul(self.dim(d2))
                    add(c2, nv[1])
                elif t2:
                    load(c2, nv[1])
                else:
                    only_first()
                    continue
                add(c1, nv[0])
                put(icell, 0o100)
            elif f.kind == 6:           # *1061B
                k = B * d2 + A
                if t2:
                    load(c2, nv[1])
                    add(c3, nv[2])
                    addc(k)
                elif t3:
                    load(c3, nv[2])
                    addc(k)
                elif k:
                    const(k, 0o110)
                else:
                    only_first()
                    continue
                finish(d1)
            else:                       # kind 7
                if t3:
                    load(c3, nv[2])
                    addc(B)
                elif B:
                    const(B, 0o110)
                else:
                    two()
                    continue
                self.mul(self.dim(d2))
                add(c2, nv[1])
                addc(A)
                finish(d1)

    def text(self):
        g = self.g
        implicit = [n for n in self.implicit if self.syms[n].ptr in self.assigned]
        unit = Unit(main=self.kind == 'PROGRAM', implicit=implicit,
                    temps=self.m[gen.D33143 + 55], update=self.update)
        return render(parse_items(g.decl[:-1]), parse_items(g.out[:-1]), unit)


def closing(text, pos):
    """the place of the parenthesis that closes the one at pos"""
    depth = 0
    for i in range(pos, len(text)):
        depth += (text[i] == '(') - (text[i] == ')')
        if depth == 0:
            return i
    raise Error('unbalanced parentheses: ' + text)


def split_top(text):
    """text split at the commas outside parentheses"""
    out, depth, cur = [], 0, ''
    for c in text:
        if c == ',' and depth == 0:
            out.append(cur)
            cur = ''
            continue
        depth += (c == '(') - (c == ')')
        cur += c
    return out + [cur]


def statements(lines):
    """the cards of one program unit -> (label, text without blanks, text
    as it is: columns 7-72 of every card)"""
    cur = None
    for l in lines:
        l = l.rstrip('\n').upper()[:72]
        if not l.strip() or l[0] in 'C*':
            continue
        if len(l) > 5 and l[5] not in ' 0' and cur:
            cur[1] += l[6:].ljust(66)
            continue
        if cur:
            yield from split_dollar(*cur)
        cur = [l[:5].strip(), l[6:].ljust(66)]
    if cur:
        yield from split_dollar(*cur)


def split_dollar(label, raw):
    """$ separates statements on a card (as in the CDC 1604 compiler this
    one was made from), but not in Hollerith constants, in '...', nor in
    a FORMAT statement; only the first statement has the label; empty
    ones are skipped"""
    pieces = [raw]
    if not raw.replace(' ', '').startswith('FORMAT('):
        pieces, cur, text, i = [], '', '', 0
        while i < len(raw):
            c = raw[i]
            n = 1
            if c == "'":
                k = raw.find("'", i + 1)
                n = (len(raw) if k < 0 else k + 1) - i
            elif c == 'H' and re.search(r'(^|[^A-Z0-9])\d+$', text):
                n = int(re.search(r'\d+$', text).group()) + 1
            elif c == '$':
                pieces.append(cur)
                cur = text = ''
                i += 1
                continue
            cur += raw[i:i + n]
            text += raw[i:i + n].replace(' ', '') if n == 1 else raw[i:i + n]
            i += n
        pieces.append(cur)
    first = True
    for piece in pieces:
        if piece.strip():
            yield (label if first else '', unblank(piece), piece)
        first = False


def unblank(raw):
    """the text of a statement without blanks, but those in Hollerith
    constants nH... and in '...' kept"""
    out, i = '', 0
    while i < len(raw):
        c = raw[i]
        if c == "'":
            k = raw.find("'", i + 1)
            k = len(raw) if k < 0 else k + 1
            out += raw[i:k]
            i = k
            continue
        if c == 'H' and re.search(r'(^|[^A-Z0-9])\d+$', out):
            n = int(re.search(r'\d+$', out).group())
            out += raw[i:i + n + 1]
            i += n + 1
            continue
        if c != ' ':
            out += c
        i += 1
    return out


def compile_text(src):
    """Fortran text -> lines of Madlen text"""
    out = []
    f = None
    for label, text, raw in statements(src.splitlines()):
        if f is None:
            f = Front()
        f.raw = raw
        if f.statement(label, text):
            f.epilogue()
            out += f.text()
            f = None
    return out
