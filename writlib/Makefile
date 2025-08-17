WORKVOL = 80

cmp.out: gold.bin silver.bin
	../tools/cmp.sh

silver.dis: silver.bin writlib.sym
	disbesm6 -a1760 -e1770 -nwritlib.sym $< > $@

gold.dis: gold.bin writlib.sym
	disbesm6 -a1760 -e1770 -nwritlib.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

gold.ovl:
	besmtool dump 2048 --start=0252 --length=2 --to-file=$@.
	dd bs=192 skip=12 < $@. > $@
	rm $@.

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol *.asm
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	../tools/overlay.pl $(WORKVOL) 'writlib*' *.asm
	besmtool dump $(WORKVOL) --start=1 --length=2 --to-file=$@

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
