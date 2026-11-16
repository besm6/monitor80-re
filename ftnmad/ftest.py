#!/usr/bin/env python3
"""ftest.py file.f ... - compare the Madlen text made by ftnmad with the
text made by the original compiler (ref.py); prints the differences."""
import difflib
import sys
import ref
from front import compile_text


def test(fn):
    src = open(fn).read()
    want = ref.madlen(ref.listing(src))
    try:
        got = compile_text(src)
    except Exception as e:
        import traceback
        traceback.print_exc()
        got = ['*** ' + str(e)]
    want = [l.rstrip() for l in want]
    got = [l.rstrip() for l in got]
    if want == got:
        print('%s: OK (%d lines)' % (fn, len(got)))
        return 0
    print('%s: DIFFERENT' % fn)
    for l in difflib.unified_diff(want, got, 'original', 'ftnmad', lineterm='', n=2):
        print('  ' + l)
    return 1


if __name__ == '__main__':
    sys.exit(1 if sum(test(f) for f in sys.argv[1:]) else 0)
