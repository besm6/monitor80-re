#!/usr/bin/env python3
"""dtest.py [-v] file.f ... - compare what ftnmad prints for every program
unit (the cards and the diagnostics after the statements, front.
compile_listing) with the listing of the original compiler (ref.py): the
lines after the header "Ф O P T P A H /16.07.73/" up to the next page.
Prints OK or the differences; with -v also the codes of the diagnostics
of both.  The Madlen text is checked by ftest.py."""
import difflib
import sys

import ref
from front import compile_listing


# characters the listing of dispak shows otherwise
CHARS = str.maketrans({"'": '’', '$': '◇', '#': '≠', '&': '∧'})


def sections(lst):
    """the listing of the original -> [lines] for every program unit"""
    out, cur = [], None
    for l in lst.split('\n'):
        if l.rstrip() == '   /16.07.73/':
            cur = []
            out.append(cur)
        elif cur is not None:
            if l.startswith('\f') or '*END FILE' in l:
                cur = None
            else:
                cur.append(l.rstrip())
    for c in out:
        while c and not c[-1]:
            c.pop()
    return out


def test(fn, verbose=False):
    src = open(fn).read()
    want = sum(sections(ref.listing(src)), [])
    try:
        got = sum((l for l, m in compile_listing(src)), [])
    except Exception as e:
        import traceback
        traceback.print_exc()
        got = ['*** ' + str(e)]
    got = [l.translate(CHARS) for l in got]
    if verbose:
        codes = [l for l in want if l[:1] == ' ' and l[1:].isdigit() and len(l) == 6]
        print('  original:', ' '.join(codes))
    if want == got:
        print('%s: OK (%d lines)' % (fn, len(got)))
        return 0
    print('%s: DIFFERENT' % fn)
    for l in difflib.unified_diff(want, got, 'original', 'ftnmad', lineterm='', n=2):
        print('  ' + l)
    return 1


if __name__ == '__main__':
    v = '-v' in sys.argv
    sys.exit(1 if sum(test(f, v) for f in sys.argv[1:] if f != '-v') else 0)
