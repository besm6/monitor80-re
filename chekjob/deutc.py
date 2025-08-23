#!/usr/bin/env python3
"""
UTC‑pair evaluator (numeric part only).

For a pair
        ,UTC,<string1>
        <S containing a comma>,<string2>

* if <string2> is empty, it is taken as "0".
* the program evaluates the arithmetic expression  <string1> + "+" + <string2>.
* the result is printed as   S,<value>
All other lines are copied verbatim.
The function evaluate_arith is the same as in the first program.
"""

import sys
import re

# ----------------------------------------------------------------------
# evaluate_arith – unchanged from the first program
CONST_EXPR_RE = re.compile(
    r'(?<![A-Za-z0-9*/])'          # not preceded by identifier‑like char
    r'([0-9]+(?:[+-][0-9]+)+)'    # at least one '+' or '-'
    r'(?![A-Za-z0-9*/])'           # not followed by identifier‑like char
)

def evaluate_arith(text: str) -> str:
    """Replace each pure numeric sub‑expression (e.g. 12+3‑5) with its value."""
    def repl(m):
        expr = m.group(1)
        return str(eval(expr))          # safe: only digits, +, -
    return CONST_EXPR_RE.sub(repl, text)


# ----------------------------------------------------------------------
def process(lines):
    """Generator yielding the output lines (including their original newline)."""
    i = 0
    n = len(lines)

    while i < n:
        line = lines[i].rstrip('\n')

        # --------------------------------------------------------------
        # Is this the first line of a UTC pair?
        m1 = re.match(r'^(.*),UTC,(.*)$', line)
        if m1 and i + 1 < n:                     # need a second line
            string1 = m1.group(2)                # may be any text (including empty)

            # ----- second line of the pair -----
            line2 = lines[i + 1].rstrip('\n')
            if ',' in line2:
                S, string2 = line2.rsplit(',', 1)   # split on the last comma

                # ----- treat empty string2 as 0 -----
                if string2 != '':

                    # ----- build the expression string1 + "+" + string2 -----
                    expr = f"{string1}+{string2}"

                    # ----- evaluate numeric fragments (if any) -----
                    value = evaluate_arith(expr)
                else:
                    value = string1

                if ':' in m1.group(1):
                    yield m1.group(1) + ",BSS,\n"

                # ----- output the required single line -----
                yield f"{S},{value}\n"

                i += 2          # skip the whole pair
                continue

        # --------------------------------------------------------------
        # Not a UTC pair → copy line unchanged (including its original newline)
        yield lines[i]
        i += 1


# ----------------------------------------------------------------------
def main():
    # read the whole input (preserve original newlines)
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r', encoding='utf-8') as f:
            data = f.readlines()
    else:
        data = sys.stdin.readlines()

    for out_line in process(data):
        sys.stdout.write(out_line)


if __name__ == '__main__':
    main()
