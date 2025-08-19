#!/usr/bin/env python3
"""
compare_octals.py

Given two text files, each containing somewhere a contiguous block of lines
where each line is a 16‑digit octal number, compare the two blocks line by line.
Print the octal number when the lines match, otherwise print a single '*'.

Usage:
    python compare_octals.py file1.txt file2.txt
"""

import sys
import re
from pathlib import Path

OCTAL_RE = re.compile(r'^ *[0-7]{16}$')   # exactly 16 octal digits


def read_block(path: Path):
    """
    Return the first contiguous block of 16‑digit octal numbers found in *path*.
    """
    block = []
    in_block = False

    with path.open('r', encoding='utf-8') as f:
        for raw_line in f:
            line = raw_line.rstrip('\n')
            if OCTAL_RE.fullmatch(line):
                if not in_block:
                    in_block = True          # start of the block
                block.append(line)
            else:
                if in_block:                # we were inside the block and now left it
                    break

    if not block:
        raise ValueError(f'No 16‑digit octal block found in {path}')
    return block


def main():
    if len(sys.argv) != 3:
        print(f'Usage: {sys.argv[0]} FILE1 FILE2', file=sys.stderr)
        sys.exit(1)

    file1 = Path(sys.argv[1])
    file2 = Path(sys.argv[2])

    try:
        block1 = read_block(file1)
        block2 = read_block(file2)
    except Exception as e:
        print(f'Error reading blocks: {e}', file=sys.stderr)
        sys.exit(1)

    if len(block1) != len(block2):
        print('Error: blocks have different lengths', file=sys.stderr)
        sys.exit(1)

    out_lines = []
    for line1, line2 in zip(block1, block2):
        out_lines.append(line1 if line1 == line2 else '*')

    # Print result – one item per line
    sys.stdout.write('\n'.join(out_lines))
    if out_lines:                     # ensure final newline for nicer CLI output
        sys.stdout.write('\n')


if __name__ == '__main__':
    main()
