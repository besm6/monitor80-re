WORKVOL = 80

MODULES = chekjob cheknews clopen e50_100 g02346 \
g03270 g03702 g03757 dumon g04046 \
g04052 g04175 g04635 g04640 g04720 g05011 handle \
g05517 ifprio g05634 mvstack os_besm6 header

FORTRAN = g02407 newsxx

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

silver.ovl: workvol $(addsuffix .asm,$(MODULES)) $(addsuffix .f,$(FORTRAN))
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	../tools/overlay.pl -o ' chekjob*(newsxxx)' $(WORKVOL) 'chekjob*' *.asm *.f
	besmtool dump $(WORKVOL) --start=1 --length=3 --to-file=$@

header.asm: ../inputcal/header.asm
	sed 's/3\.5/3.7/' < $< > $@

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
