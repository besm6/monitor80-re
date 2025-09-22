WORKVOL = 80

cmp.out: gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin duread.sym
	disbesm6 -a6746 -e6756 -nduread.sym $< > $@

gold.dis: gold.bin duread.sym
	disbesm6 -a6746 -e6756 -nduread.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

gold.ovl:
	besmtool dump 2048 --start=0375 --length=6 --to-file=$@.
	dd bs=192 skip=13 < $@. > $@
	rm $@.

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol 
	besmtool write $(WORKVOL) --start=0 --length=6 --from-file=/dev/zero
	../tools/overlay.pl -o ' fake(duread*)' $(WORKVOL) fake *.asm *.f
	besmtool dump $(WORKVOL) --start=1 --length=5 --to-file=$@.
	dd bs=192 skip=2 < $@. > $@
	rm $@.

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
