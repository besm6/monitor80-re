#!/usr/bin/env python3
"""
compare_shifted.py

Given
  * file A – a block of N lines, each a 16‑digit octal number,
  * file B – a block of M lines (M < N) containing octal numbers or '*',
find the offset 0 … N‑M at which B matches A best.
A line matches when B contains '*', or when the two octal strings are equal.

Usage:
    python compare_shifted.py fileA.txt fileB.txt
"""

import sys
import re
# import random
# import math
from pathlib import Path

# ----------------------------------------------------------------------
# 1. Block extraction (identical to the first problem)
# ----------------------------------------------------------------------
OCTAL_RE = re.compile(r'^ *[0-7]{16}$')


def read_block(path: Path):
    block = []
    inside = False
    with path.open('r', encoding='utf-8') as f:
        for raw in f:
            line = raw.rstrip('\n')
            if OCTAL_RE.fullmatch(line):
                if not inside:
                    inside = True
                block.append(line)
            else:
                if inside:
                    break
    if not block:
        raise ValueError(f'No octal block found in {path}')
    return block

def read_pattern(path: Path):
    block = []
    with path.open('r', encoding='utf-8') as f:
        for raw in f:
            line = raw.rstrip('\n')
            block.append(line)
    if not block:
        raise ValueError(f'No octal block found in {path}')
    return block


# ----------------------------------------------------------------------
# 2. Helper: next power of two (for FFT length)
# ----------------------------------------------------------------------
def next_pow2(x: int) -> int:
    return 1 << (x - 1).bit_length()


# ----------------------------------------------------------------------
# 3. Main logic – tries to use NumPy, otherwise falls back to O(N·M)
# ----------------------------------------------------------------------
def best_offset_fft(A, B):
    """Return (best_offset, best_match_count) using FFT (requires numpy)."""
    import numpy as np

    N = len(A)
    M = len(B)

    # ---- 2.1 Build the set of distinct tokens (ignore '*') ----
    tokens = set(A)
    tokens.update(tok for tok in B if tok != '*')

    # ---- 2.2 Random unit‑complex code for each token ----
    random.seed(0xC0FFEE)          # make runs reproducible
    token_code = {}
    for t in tokens:
        angle = random.random() * 2.0 * math.pi
        token_code[t] = complex(math.cos(angle), math.sin(angle))

    # ---- 2.3 Build numeric arrays a (A) and b (B) ----
    a = np.empty(N, dtype=np.complex128)
    for i, tok in enumerate(A):
        a[i] = token_code[tok]                     # raw complex

    b = np.empty(M, dtype=np.complex128)
    wildcards = 0
    for i, tok in enumerate(B):
        if tok == '*':
            b[i] = 0.0
            wildcards += 1
        else:
            b[i] = np.conj(token_code[tok])        # conjugate

    # ---- 2.4 Cross‑correlation via FFT ----
    rev_b = b[::-1]                                # reversed B
    n = next_pow2(N + M - 1)
    A_f = np.fft.rfft(a, n=n)
    B_f = np.fft.rfft(rev_b, n=n)
    C_f = A_f * B_f
    conv = np.fft.irfft(C_f, n=n)                  # real‑valued (tiny imag)

    # ---- 2.5 Scan offsets and pick the best ----
    best_off = 0
    best_match = -1
    for off in range(N - M + 1):
        # convolution index that corresponds to this offset:
        idx = off + M - 1
        # rounding is safe because the true value is an integer plus tiny noise
        match_nonwild = int(round(conv[idx].real))
        total_match = match_nonwild + wildcards
        if total_match > best_match:
            best_match = total_match
            best_off = off

    return best_off, best_match, wildcards


def best_offset_bruteforce(A, B):
    """Simple O(N·M) version – used only if NumPy is missing."""
    N, M = len(A), len(B)
    wild = sum(1 for x in B if x == '*')
    best_off = 0
    best_match = -1
    best_zeros = -1
    for off in range(N - M + 1):
        match = wild
        zeros = 0
        for i in range(M):
            if B[i] != '*' and B[i] == A[off + i]:
                match += 1
                if B[i] == ' 0000000000000000':
                    zeros += 1
        if match > best_match:
            best_match = match
            best_zeros = zeros
            best_off = off
    return best_off, best_match, best_zeros, wild


def compute_best(A, B):
    """Select the fastest available implementation."""
    try:
        return best_offset_fft(A, B)
    except Exception as exc:          # includes ImportError, etc.
    # Fallback – still correct
    #    sys.stderr.write(f'Warning: FFT path failed ({exc}); using brute force.\n')
        return best_offset_bruteforce(A, B)


# ----------------------------------------------------------------------
# 4. Entry point
# ----------------------------------------------------------------------
def main():
    if len(sys.argv) != 4:
        print(f'Usage: {sys.argv[0]} base_offset FILE_A FILE_B', file=sys.stderr)
        sys.exit(1)

    base = int(sys.argv[1], 8)
    file_a = Path(sys.argv[2])
    file_b = Path(sys.argv[3])

    try:
        block_a = read_block(file_a)
        block_b = read_pattern(file_b)
    except Exception as e:
        print(f'Error reading blocks: {e}', file=sys.stderr)
        sys.exit(1)

    if len(block_b) > len(block_a):
        print('Error: block B is longer than block A', file=sys.stderr)
        sys.exit(1)

    offset, matches, zeros, wild = compute_best(block_a, block_b)
    total = len(block_b)
    percent = 100.0 * (matches-wild-zeros) / (total-wild-zeros)
    offset += base
    # Output – offset first, then percentage with two decimals
    if matches > wild and percent > 50:
        actual = total - wild - zeros
        matches -= wild+zeros
        print(file_b, f'{offset:05o} : {percent:.2f}% of {total:4o}/{actual:4o}/{matches:4o}')


if __name__ == '__main__':
    main()
