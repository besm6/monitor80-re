WORKVOL = 80

cmp.out: gold.bin silver.bin
	./cmp.sh
.cpp.o:
	$(CXX) $(CFLAGS) -c -o $@ $<

.bin.dis:
	disbesm6 -a1760 -e1770 -ninputcal.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

gold.ovl:
	besmtool dump 2048 --start=0251 --length=2 --to-file=$@

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol *.asm
	besmtool write $(WORKVOL) --start=0 --length=3 --from-file=/dev/zero
	./asm.pl $(WORKVOL) *.asm
	besmtool dump $(WORKVOL) --start=1 --length=2 --to-file=$@

clean:
	rm -f *.o *.bin *.ovl *.b6 *~ *.out

clobber: clean
	rm -f cosy2txt ovl2bin
