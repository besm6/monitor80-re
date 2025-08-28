WORKVOL = 80

MODULES = _tewr d21567 g20461 g20505 g20560 \
g20677 g21062 g21203 g21207 g21227 g21274 g21362 \
g21577 g22112 g22235 g22265 g22361 g23327 g23345 \
g23424 g23462 g23503 g23537 g23603 iso_gost tewr

FORTRAN = g20112.f

cmp.out: gold.bin silver.bin gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin tewr.sym
	disbesm6 -a17770 -e20000 -ntewr.sym $< > $@

gold.dis: gold.bin tewr.sym
	disbesm6 -a17770 -e20000 -ntewr.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

gold.ovl:
	besmtool dump 2048 --start=0354 --length=3 --to-file=$@.
	dd bs=192 skip=31 < $@. > $@
	rm $@.

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol *.asm
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	../tools/overlay.pl -s -o ' //tewr*/(//tewr*)' $(WORKVOL) '//tewr*/' $(FORTRAN) $(addsuffix .asm,$(MODULES))
	besmtool dump $(WORKVOL) --start=1 --length=3 --to-file=$@.
	dd bs=192 skip=1 < $@. > $@
	rm $@.

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out *.

clobber: clean

update:
	git add $(addsuffix .asm,$(MODULES))
