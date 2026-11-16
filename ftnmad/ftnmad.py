#!/usr/bin/env python3
"""ftnmad.py file.f - compile Fortran to Madlen text (stdout) the way the
FORTR* compiler of Monitor-80 does."""
import sys
from front import compile_text

if __name__ == '__main__':
    for l in compile_text(open(sys.argv[1]).read()):
        print(l)
