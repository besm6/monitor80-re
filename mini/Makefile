WORKVOL = 80

MODULES = mini minipr g75000

cmp.out: gold.bin silver.bin gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin mini.sym
	disbesm6 -a74000 -e74010 -nmini.sym $< > $@

gold.dis: gold.bin mini.sym
	disbesm6 -a74000 -e74010 -nmini.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $<  > $@

gold.ovl:
	besmtool dump 2048 --start=0354 --length=2 --to-file=$@.
	dd bs=192 skip=17 < $@. > $@
	rm $@.

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol *.asm
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	../tools/overlay.pl -o ' //mini(//minipr)' $(WORKVOL) '//mini' $(addsuffix .asm,$(MODULES))
	besmtool dump $(WORKVOL) --start=1 --length=2 --to-file=$@.
	dd bs=192 skip=1 < $@. > $@
	rm $@.

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
