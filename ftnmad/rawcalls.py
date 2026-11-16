#!/usr/bin/env python3
"""rawcalls.py file.f - the calls of PUTAWAY made by the original compiler:
w1 and w2 in octal, then the symbolic form (see calls.py)."""
import sys
import calls
for t, w1, w2 in calls.calls(open(sys.argv[1]).read()):
    print('%16o %16o  %s' % (w1, w2, t))
