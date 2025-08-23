#!/usr/bin/env python3
"""
IR‑array manager.

- Stores strings coming from lines  "<n>,VTM,<string1>"  (1 ≤ n ≤ 6).
- For lines "<n>,<XXX>,<string2>" (XXX = any three characters)
  prints a transformed line that always begins with " ,".
- All other lines are echoed unchanged.
The numeric‑sub‑expression evaluator is identical to the one used in the
first program (evaluate_arith).
"""

import sys
import re

# ----------------------------------------------------------------------
# evaluate_arith – unchanged from the first program
CONST_EXPR_RE = re.compile(
    r'(?<![A-Za-z0-9*/])'          # not preceded by identifier‑like char
    r'([0-9]+(?:[+-][0-9]+)+)'    # at least one + or -
    r'(?![A-Za-z0-9*/])'           # not followed by identifier‑like char
)

def evaluate_arith(text: str) -> str:
    """Replace each maximal constant integer sub‑expression with its value."""
    def repl(m):
        expr = m.group(1)
        return str(eval(expr))          # safe: only digits, +, -
    return CONST_EXPR_RE.sub(repl, text)


# ----------------------------------------------------------------------
def process(lines):
    """Generator that yields the required output lines (including newlines)."""
    # IR[1] .. IR[6]  – initialise with empty strings
    IR = [""] * 7                     # index 0 unused

    vtmmatch   = re.compile(r'^(.*[^1])([1-6]),VTM,(.*)$')
    genericmatch = re.compile(r'^\s*([1-6]),([A-Za-z0-9/*]{3}),(.*)$')
    data_seen = 0
    for raw in lines:
        line = raw.rstrip('\n')

        if ',DATA,' in line:
            data_seen = 1
            yield line + "\n"
            continue

        if data_seen:
            yield line + "\n"
            continue

        # --------------------------------------------------------------
        # 1) VTM definition
        m = vtmmatch.match(line)
        if m:
            n = int(m.group(2))
            IR[n] = m.group(3)            # store, do not output
            if ':' in m.group(1):
                yield m.group(1) + ",BSS,\n"
            continue
        # --------------------------------------------------------------
        # 2) generic <n>,<XXX>,<string2>
        m = genericmatch.match(line)
        if m:
            n   = int(m.group(1))
            xxx = m.group(2)
            s2  = m.group(3)               # may be empty

            ir_value = IR[n]
            if s2 == "":
                out_line = f" ,{xxx},{ir_value}\n"
            else:
                eff_addr = evaluate_arith(f"{ir_value}+{s2}")
                out_line = f" ,{xxx},{eff_addr}\n"

            yield out_line
            continue

        # --------------------------------------------------------------
        # 3) any other line – copy verbatim
        yield raw


# ----------------------------------------------------------------------
def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r', encoding='utf-8') as f:
            data = f.readlines()
    else:
        data = sys.stdin.readlines()

    for out in process(data):
        sys.stdout.write(out)


if __name__ == '__main__':
    main()

