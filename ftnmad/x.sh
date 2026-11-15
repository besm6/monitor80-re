#!/bin/sh
# x.sh - compile a Fortran text from stdin with the original and show the Madlen text
t=$(mktemp --suffix=.f); cat > $t; ./ref.py "$@" $t; rm $t
