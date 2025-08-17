#!/bin/sh
if [ ! -s silver.bin ]; then
        echo '\033[1;31mBAD' \(Compilation failed\)  '\033[22;39m'
        exit 1
else
        a=`cmp -l gold.bin silver.bin | tee cmp.out | tail -1 | awk '{print $1}'`
        # Differences in the overlay header (the first 8 words = 48 bytes) are expected
        if [ $a -ge 48 ]; then
                echo '\033[1;31mBAD' \(`wc -l < cmp.out` bytes differ\) '\033[22;39m'
                exit 1
        fi
        echo '\033[1;32mGOOD' \(`wc -l < cmp.out` bytes differ in the header\) '\033[22;39m'
fi
