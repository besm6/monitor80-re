#!/usr/bin/env python3
"""
sixbytes_to_octal.py

Read a binary file, interpret each successive group of 6 bytes as a
big‑endian unsigned integer, and print the value as a 16‑digit octal
number (one per line).

Usage:
    python3 sixbytes_to_octal.py INPUT_FILE > OUTPUT.txt
"""

import sys
import os

CHUNK = 6                     # 6 bytes = 48 bits = 16 octal digits


def file_to_octal(path: str):
    """Yield octal strings for each 6‑byte block of *path*."""
    with open(path, "rb") as f:
        while True:
            data = f.read(CHUNK)
            if not data:
                break                     # EOF
            if len(data) != CHUNK:
                # Incomplete trailing bytes – decide what to do.
                # Here we simply ignore the partial block.
                # (Alternative: pad with zeros or raise an error.)
                break

            # Convert big‑endian bytes to an integer
            value = int.from_bytes(data, byteorder="big", signed=False)

            # Format as exactly 16 octal digits, leading zeros included
            octal_str = format(value, "016o")
            yield octal_str


def main():
    if len(sys.argv) != 2:
        prog = os.path.basename(sys.argv[0])
        print(f"Usage: {prog} INPUT_BINARY_FILE", file=sys.stderr)
        sys.exit(1)

    infile = sys.argv[1]
    for octal in file_to_octal(infile):
        print("", octal)


if __name__ == "__main__":
    main()
