"""The intermediate lists of the FORTR* compiler and their rendering as
Madlen text (what the overlay GLINK does before it assembles the text).

The generator (PUTAWAY in the original) writes two lists of items, DECLIST
and OUTLIST.  An item is one word, optionally followed by a name word
(6 characters of ISO text) or by the value of a literal:

    bits 9-1    operation: 0100 + a short machine opcode, a long machine
                opcode 020-037 as is, or a pseudo-operation (below)
    bit 16      a literal follows (printed as "= xxxxxxxx xxxxxxxx")
    bit 23      a name word follows
    bits 39-25  offset (name+offset), or a number when there is no name
    bit 40      the name is a variable
    bits 46-43  index register
    bit 47      the instruction starts a new word (printed with a ':')
    bit 48      special (VJM to the index update routine of a variable,
                conditional call of *RELCN)

Pseudo-operations: 010 CALL, 045 SUBP, 046 NAME, 047 ENTRY, 052 switch
between the code and the data section, 053 OCT, 054 label, 057 BSS,
072 start of a statement.
"""

MASK48 = (1 << 48) - 1

# pseudo-operations
CALL, SUBP, NAME, ENTRY, SECT, OCT, LABEL, BSS, STMT = \
    0o10, 0o45, 0o46, 0o47, 0o52, 0o53, 0o54, 0o57, 0o72

SHORT = {   # short machine opcodes (item operation = 0100 + opcode)
    0o00: 'ATX', 0o01: 'STX', 0o03: 'XTS', 0o04: 'A+X', 0o05: 'A-X',
    0o06: 'X-A', 0o07: 'AMX', 0o10: 'XTA', 0o11: 'AAX', 0o12: 'AEX',
    0o13: 'ARX', 0o14: 'AVX', 0o15: 'AOX', 0o16: 'A/X', 0o17: 'A*X',
    0o20: 'APX', 0o21: 'AUX', 0o22: 'ACX', 0o23: 'ANX', 0o24: 'E+X',
    0o25: 'E-X', 0o26: 'ASX', 0o27: 'XTR', 0o30: 'RTE', 0o31: 'YTA',
    0o34: 'E+N', 0o35: 'E-N', 0o36: 'ASN', 0o37: 'NTR', 0o40: 'ATI',
    0o41: 'STI', 0o42: 'ITA', 0o43: 'ITS', 0o44: 'MTJ', 0o45: 'J+M',
}
LONG = {
    0o22: 'UTC', 0o23: 'WTC', 0o24: 'VTM', 0o25: 'UTM', 0o26: 'UZA',
    0o27: 'U1A', 0o30: 'UJ', 0o31: 'VJM', 0o37: 'VLM',
}


def text_word(s):
    """6 characters -> a word of ISO text"""
    w = 0
    for c in s.ljust(6)[:6]:
        w = w << 8 | ord(c)
    return w


def word_text(w):
    return ''.join(chr(w >> s & 255) for s in range(40, -8, -8)).rstrip()


class Item:
    __slots__ = ('op', 'reg', 'off', 'name', 'lit', 'lit2', 'var', 'align', 'spec')

    def __init__(self, op, name=None, off=0, reg=0, lit=None, var=False,
                 align=False, spec=False):
        self.op, self.name, self.off, self.reg = op, name, off & 0o77777, reg
        self.lit, self.var, self.align, self.spec = lit, var, align, spec
        self.lit2 = None            # the second word of a double literal

    def words(self):
        n = 2 if self.lit2 is not None else \
            1 if self.name is not None or self.lit is not None else 0
        w = (self.op | (self.lit is not None) << 15 | n << 22
             | self.off << 24 | self.var << 39 | self.reg << 42
             | self.align << 46 | self.spec << 47)
        if self.name is not None:
            return [w, text_word(self.name)]
        if self.lit2 is not None:
            return [w, self.lit, self.lit2]
        if self.lit is not None:
            return [w, self.lit]
        return [w]

    def __repr__(self):
        return ' '.join('%016o' % w for w in self.words())


def parse_items(words):
    """a list of words -> items"""
    out = []
    i = 0
    while i < len(words):
        w = words[i]
        i += 1
        it = Item(w & 0o777, off=w >> 24 & 0o77777, reg=w >> 42 & 15,
                  var=bool(w >> 39 & 1), align=bool(w >> 46 & 1),
                  spec=bool(w >> 47 & 1))
        n = w >> 22 & 3             # the number of words that follow
        if w >> 15 & 1:
            it.lit = words[i]
            if n == 2:
                it.lit2 = words[i + 1]
        elif n:
            it.name = word_text(words[i])
            if n == 2:              # EQU: name, then what it is equal to
                it.lit2 = word_text(words[i + 1])
        i += n
        out.append(it)
    return out


def line(label='', reg='', op='', operand='', colon=None):
    """one line of Madlen text"""
    if colon is None:
        colon = bool(label)
    s = ' %-8s%s%2s,%s,' % (label, ':' if colon else ' ', reg,
                            op if len(op) > 4 else ' ' + op.ljust(4))
    if operand:
        s += (operand if operand[0] == '=' else ' ' + operand
              if operand[0] == '-' else '  ' + operand)
    return s.rstrip() if not operand else s


def octal_lit(v):
    return '= %08o %08o' % (v >> 24, v & 0o77777777)


def signed(off):
    return off - 0o100000 if off & 0o40000 else off


class Unit:
    """What the renderer needs besides the two lists (the original GLINK
    takes it from the tables of the compiler, which stay in memory)."""
    def __init__(self, main=False, update=(), implicit=()):
        self.main = main            # a main program
        self.update = list(update)  # variables with index update routines *Unnnn
        self.implicit = list(implicit)  # undeclared variables that get memory


def code_words(items):
    """number of words taken by a sequence of code items"""
    h = 0                           # half-words
    for it in items:
        if it.op == LABEL or it.align:
            h += h & 1
        if it.op in (LABEL, STMT, SUBP, SECT):
            continue
        h += 1
        if it.op in (0o30, 0o31, CALL):
            h += h & 1
    return (h + 1) // 2


def render(decl, out, unit):
    """DECLIST and OUTLIST items -> lines of Madlen text"""
    head, subp, data, code, bss = [], [], [], [], []
    name = None

    arrays = []         # DATA for arrays: [name, [values], repeat]

    def split(items, dest):
        sect = False
        for it in items:
            if it.op == SECT:
                sect = not sect
                if sect and it.name != '*':
                    arrays.append([it.name, [], 1])
                    sect = 2
            elif sect == 2:
                if it.op == OCT:
                    arrays[-1][1].append(it)
                elif it.op == 0o61:
                    arrays[-1][2] = it.off
            elif it.op == SUBP:
                if it.name not in subp:
                    subp.append(it.name)
            elif sect:
                data.append(it)
            else:
                dest.append(it)

    dcl = []
    split(decl, dcl)
    split(out, code)
    for it in dcl:
        if it.op == NAME:
            name = it.name
            head.append(line(it.name, op='NAME'))
        elif it.op == 0o50:
            head.append(line('*%s*' % it.name, 'LC', 'BLOCK'))
        elif it.op == 0o51:
            head.append(line(op='CONT', operand='%-6s(%d)' % (it.name, it.off)))
        elif it.op == 0o55:
            off = signed(it.off)
            head.append(line(it.name, op='EQU',
                             operand=it.lit2 + ('+%d' % off if off else '')))
        elif it.op == BSS:
            bss.append(it)
    lines = head + [line(s, op='SUBP') for s in subp]

    nerr = 0
    body = []
    for it in code:
        if it.spec:
            if it.name == '*RELCN' or it.name not in unit.update:
                continue
            if it.op == 0o31:
                it = Item(0o31, '*U%04d' % unit.update.index(it.name), reg=it.reg)
        if it.name == 'ERASER':
            nerr = max(nerr, it.off + 1)
            it = Item(it.op, '*ERR%02d' % it.off, reg=it.reg, align=it.align)
        body.append(it)

    ndata = sum(1 for it in data if it.op == OCT)
    prolog = [Item(0o24, name, reg=14), Item(0o30, '*BEGIN')]
    lines.append(line('*C', op='EQU',
                      operand='*+%d' % (code_words(prolog + body) + ndata)))
    if unit.main:
        lines.append(line('PROGRAM', op='ENTRY'))
    nstmt = 0
    label = ''
    seq = prolog + body + data
    for n, it in enumerate(seq):
        if it.op == STMT:
            nstmt += 1
            lines.append('C*****HAЧAЛO  OПEPATOPA %d' % nstmt)
            continue
        if it.op == LABEL:
            if n + 1 < len(seq) and seq[n + 1].op == OCT:
                label = it.name
            else:
                lines.append(line(it.name, op='BSS'))
            continue
        if it.op == OCT:
            v = it.lit if it.lit is not None else text_word(it.name)
            lines.append(line(label, op='OCT',
                              operand='%08o %08o' % (v >> 24, v & 0o77777777)))
            label = ''
            continue
        if it.op == CALL:
            opn = 'CALL'
        elif it.op >= 0o100:
            opn = SHORT[it.op - 0o100]
        else:
            opn = LONG[it.op]
        more = None
        if it.lit2 is not None:
            operand = '=D%08o %08o*' % (it.lit >> 24, it.lit & 0o77777777)
            more = ' ' * 21 + '%08o %08o' % (it.lit2 >> 24, it.lit2 & 0o77777777)
        elif it.lit is not None:
            operand = octal_lit(it.lit)
        elif it.name is not None:
            off = signed(it.off)
            operand = it.name + ('+%d' % off if off > 0 else '%d' % off if off else '')
        else:
            operand = str(signed(it.off)) if it.off else ''
        lines.append(line(reg=str(it.reg) if it.reg else '', op=opn,
                          operand=operand, colon=it.align))
        if more:
            lines.append(more)
    for i in range(nerr):
        lines.append(line('*ERR%02d' % i, op='BSS', operand='1'))
    for v in unit.implicit:
        lines.append(line(v, op='BSS', operand='1'))
    for it in bss:
        if it.off == 1:
            lines.append(line(it.name, op='BSS', operand='1'))
    for it in bss:
        if it.off != 1:
            lines.append(line(it.name, op='BSS', operand=str(it.off)))
    if arrays:
        # the values, then where they go: n words from *DATA, repeated
        # (this part was seen for one form of DATA only)
        lines.append(line(op='DATA'))
        lines.append(line('*DATA', op='BSS'))
        for a in arrays:
            for it in a[1]:
                v = it.lit if it.lit is not None else text_word(it.name)
                lines.append(line(op='OCT', operand='%08o %08o'
                                  % (v >> 24, v & 0o77777777)))
        off = 0
        for a in arrays:
            lines.append(' %8s %3d, SET ,  *DATA%s'
                         % ('', len(a[1]), '+%d' % off if off else ''))
            lines.append(' %8s %3d,     ,  %s' % ('', a[2], a[0]))
            off += len(a[1])
        lines.append(' %8s %3s, END ,  %s' % ('', '', name))
    else:
        lines.append(line(op='END', operand=name))
    return lines
