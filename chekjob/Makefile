WORKVOL = 80

cmp.out: gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin chekjob.sym
	disbesm6 -a1760 -e1770 -nchekjob.sym $< > $@

gold.dis: gold.bin chekjob.sym
	disbesm6 -a1760 -e1770 -nchekjob.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

gold.ovl:
	besmtool dump 2048 --start=0373 --length=3 --to-file=$@.
	dd bs=192 skip=9 < $@. > $@
	rm $@.

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol *.asm
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	../tools/overlay.pl -o ' chekjob*(newsxx)' $(WORKVOL) 'chekjob*' *.asm newsxx.f
	besmtool dump $(WORKVOL) --start=1 --length=3 --to-file=$@

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
