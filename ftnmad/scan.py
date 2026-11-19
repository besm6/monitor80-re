"""The checks SCANSTMT of the original compiler makes when it reads a
statement, before the statement is compiled: what kind of statement it
is (an assignment, or one beginning with a word of its table) and the
lexical errors of its constants, names, parentheses and characters.

scan(text) takes the text of a statement without blanks (but those in
Hollerith constants, front.unblank) and returns (warnings, error, split):
the codes of the warnings (a name longer than 6 characters, a constant
too small), the code of the first error or None (the warnings are then
not printed), and for a logical IF the position after its condition,
where the statement it governs begins (it is scanned as a statement of
its own), else None.  Codes are those printed (class digit and message
number, octal)."""
import re

# the words of SCANSTMT's table (04045-04117 of the root), in its order;
# the long ones are matched in full
KEYWORDS = ['FORMAT', 'END', 'DOUBLEPRECISION', 'EQUIVALENCE', 'SUBROUTINE',
            'BACKSPACE', 'DIMENSION', 'BLOCKDATA', 'EXTERNAL', 'FUNCTION', 'CONTINUE',
            'ENDFILE', 'COMPLEX', 'LOGICAL', 'INTEGER', 'PROGRAM', 'DECODE', 'ENCODE',
            'REWIND', 'RETURN', 'COMMON', 'ASSIGN', 'WRITE', 'PAUSE', 'PRINT', 'PUNCH',
            'ENTRY', 'REAL', 'READ', 'DATA', 'STOP', 'GOTO', 'CALL', 'IF', 'DO']
OPERATOR = re.compile(r'\.(EQ|NE|GT|LT|GE|LE|AND|OR|NOT|TRUE|FALSE)\.')


class ScanError(Exception):
    def __init__(self, code, pos=0):
        Exception.__init__(self, '%05o' % code)
        self.code = code
        self.pos = pos          # where in the text it was found


def top_level(text):
    """(an = outside parentheses, a comma outside parentheses), Hollerith
    constants and quoted texts skipped; ScanError 15007 for a ) too many"""
    level, eq, comma, i = 0, False, False, 0
    while i < len(text):
        c = text[i]
        if c == "'":
            k = text.find("'", i + 1)
            i = len(text) if k < 0 else k + 1
            continue
        m = re.match(r'\d+H', text[i:])
        if m and (i == 0 or not text[i - 1].isalnum()):
            i += m.end() + int(m.group()[:-1])
            continue
        if c.isalnum():
            # a name or a number: not the start of a Hollerith constant
            while i < len(text) and text[i].isalnum():
                i += 1
            continue
        level += (c == '(') - (c == ')')
        if level < 0:
            raise ScanError(0o15007, i)
        if level == 0:
            eq |= c == '='
            comma |= c == ','
        i += 1
    return eq, comma


def classify(text):
    """-> None for an assignment (or a statement function), else the word
    of the table it begins with; ScanError 15002 if neither"""
    if text.startswith('IF(') and text[closing(text, 2):][:1].isalpha():
        return 'IF'     # (IF(X)=... is an assignment)
    eq, comma = top_level(text)
    if eq and not comma and text[:1].isalpha():
        return None
    for kw in KEYWORDS:
        if text.startswith(kw):
            return kw
    raise ScanError(0o15002)


def number(s, i, warnings):
    """a constant at s[i:] -> its end"""
    j = i
    while j < len(s) and s[j].isdigit():
        j += 1
    digits = s[i:j]
    c = s[j:j + 1]
    if digits and c == 'H':
        n = int(digits)
        if n == 0 or j + 1 + n > len(s):
            raise ScanError(0o15025, j)     # (or past the end of the statement)
        return j + 1 + n
    if digits and c == 'B':
        if any(d in '89' for d in digits):
            raise ScanError(0o15023, j)
        if len(digits) > 16:
            raise ScanError(0o15021, j)
        j += 1
        if s[j:j + 1].isalnum():
            raise ScanError(0o15024, j)
        return j
    real = False
    exp_at = None
    if c == '.':
        nxt = s[j + 1:j + 2]
        if nxt.isalpha():
            if OPERATOR.match(s, j):
                return j                # an integer before .EQ. ...
            if nxt == 'E' and (s[j + 2:j + 3].isdigit() or s[j + 2:j + 3] in ('+', '-')) \
                    or nxt == 'D':
                real = True
                exp_at = j + 1
                j += 1
            else:
                raise ScanError(0o15026, j)
        else:
            real = True
            j += 1
            while j < len(s) and s[j].isdigit():
                j += 1
    mant = s[i:j].rstrip('.') or '0'
    if mant.startswith('.'):
        mant = '0' + mant
    exp = 0
    if exp_at is not None or s[j:j + 1] in ('E', 'D'):
        real = True
        j += 1
        sign = 1
        if s[j:j + 1] in ('+', '-'):
            sign = -1 if s[j] == '-' else 1
            j += 1
            if s[j:j + 1].isalpha():
                raise ScanError(0o15013, j)
        if not s[j:j + 1].isdigit():
            raise ScanError(0o15013 if s[j:j + 1].isalpha() else 0o15015, j)
        k = j
        while j < len(s) and s[j].isdigit():
            j += 1
        exp = sign * int(s[k:j])
    nxt = s[j:j + 1]
    if nxt == 'H' and real:
        raise ScanError(0o15025, j)
    if nxt.isalpha():
        raise ScanError(0o15013, j)
    if nxt == '.' and not OPERATOR.match(s, j):
        raise ScanError(0o15026, j)
    if real:
        x = float(mant) * 10.0 ** exp if exp < 400 else float('inf')
        if x >= 2.0 ** 63:
            raise ScanError(0o15022, j)
        if 0 < x < 2.0 ** -65:
            warnings.append(0o5022)
    elif int(digits) >= 2 ** 63:
        raise ScanError(0o15022, j)
    return j


def lex(s, label=False, at=0):
    """the lexical errors of s (raised: ScanError, the position plus at)
    -> the warnings; label: s follows a word of the table, a number at its
    start is a label (any letters after it start a name)"""
    try:
        return lex1(s, label)
    except ScanError as e:
        e.pos += at
        raise


def lex1(s, label):
    warnings = []
    level, i = 0, 0
    operand = False             # the last thing was a name, constant or )
    if label:
        while i < len(s) and s[i].isdigit():
            i += 1
    while i < len(s):
        c = s[i]
        if c.isalpha():
            j = i
            while j < len(s) and s[j].isalnum():
                j += 1
            if j - i > 6:
                warnings.append(0o5011)
            i = j
            operand = True
        elif c.isdigit() or c == '.' and s[i + 1:i + 2].isdigit() and not operand:
            i = number(s, i, warnings)
            operand = True
        elif c == '.':
            m = OPERATOR.match(s, i)
            if m:
                i = m.end()
                operand = m.group(1) in ('TRUE', 'FALSE')
            elif s[i + 1:i + 2].isalnum():
                raise ScanError(0o15026, i)     # .X... not an operator, A.5
            else:
                i += 1          # (a point before anything else passes)
        elif c == "'":
            k = s.find("'", i + 1)
            if k < 0 or k == i + 1:
                raise ScanError(0o15025, i)
            i = k + 1
            operand = True
        elif c in '()':
            level += 1 if c == '(' else -1
            if level < 0:
                raise ScanError(0o15007, i)
            i += 1
            operand = c == ')'
        elif c in '+-*/=,':
            i += 1
            operand = False
        else:
            raise ScanError(0o15006, i)
    if level > 0:
        raise ScanError(0o15017, len(s))
    return warnings


def closing(s, i):
    """the position after the parenthesis that closes the one at s[i]"""
    level = 0
    for j in range(i, len(s)):
        level += (s[j] == '(') - (s[j] == ')')
        if level == 0:
            return j + 1
    return len(s)


def scan(text):
    """-> (warnings, error code or None, split of a logical IF or None,
    the position of the error)"""
    try:
        kw = classify(text)
        if kw is None:
            return lex(text), None, None, 0
        if kw == 'IF' and text.startswith('IF('):
            end = closing(text, 2)
            rest = text[end:]
            if rest[:1].isalpha():
                # a logical IF: the condition, then a statement of its own
                return lex(text[2:end], True, 2), None, end, 0
        if kw == 'FORMAT':
            return [], None, None, 0
        rest = text[len(kw):]
        at = len(kw)
        if kw in ('INTEGER', 'REAL', 'LOGICAL', 'DOUBLEPRECISION', 'COMPLEX') and \
                rest.startswith('FUNCTION'):
            rest = rest[8:]
            at += 8
        return lex(rest, True, at), None, None, 0
    except ScanError as e:
        return [], e.code, None, e.pos


def mask(text):
    """text with the insides of Hollerith constants and '...' replaced by
    X (to look for punctuation)"""
    out, i = [], 0
    while i < len(text):
        c = text[i]
        if c == "'":
            k = text.find("'", i + 1)
            k = len(text) if k < 0 else k + 1
            out.append("'" + 'X' * (k - i - 1))
            i = k
            continue
        m = re.match(r'\d+H', text[i:])
        if m and (i == 0 or not text[i - 1].isalnum()):
            n = m.end() + int(m.group()[:-1])
            out.append('X' * min(n, len(text) - i))
            i += n
            continue
        if c.isalnum():
            j = i
            while j < len(text) and text[j].isalnum():
                j += 1
            out.append(text[i:j])
            i = j
            continue
        out.append(c)
        i += 1
    return ''.join(out)


def commas(text):
    """the errors of OPERAND (CONTROL) in the lists of an executable
    statement: 15041 two commas, 15042 a comma before ), 15043 one after
    ( -> the code of the first, or None"""
    m = re.search(r',,|,\)|\(,', mask(text))
    if m:
        return {',,': 0o15041, ',)': 0o15042, '(,': 0o15043}[m.group()]
    return None
