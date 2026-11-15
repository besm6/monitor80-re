WORKVOL = 80

MODULES := $(shell ../tools/ovsplit.py modules)
ASM = $(addsuffix .asm,$(MODULES))
# The root is linked together with its sub-overlay CBDPR:
# the overlay data are ANYTHING(FORTR*) and FORTR*(CBDPR).
SUBASM := $(addprefix ../cbdpr/,$(addsuffix .asm,$(shell cd ../cbdpr; ../tools/ovsplit.py modules)))

cmp.out: gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin fortr.sym
	disbesm6 -a1760 -e1770 -nfortr.sym $< > $@

gold.dis: gold.bin fortr.sym
	disbesm6 -a1760 -e1770 -nfortr.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

# FORTR*: catalog 2048/0250, zone 0260, block 04
gold.ovl:
	besmtool dump 2048 --start=0260 --length=4 --to-file=$@.
	dd bs=192 skip=4 < $@. > $@
	rm $@.

# The overlay is rebuilt from the Madlen sources (*.asm) alone.
# `make asm` regenerates them from the disassembly: gold.dis -> *.be
# (ovsplit.py be) -> BEMSH + DTRAN -> *.asm (ovsplit.py asm adds the common
# blocks and their DATA sections). It needs a terminal for the dispak listing.
asm: gold.dis gold.bin
	../tools/ovsplit.py be gold.dis
	for m in $(MODULES); do \
	  WORKVOL=$(WORKVOL) ../tools/debemsh.sh $$m.be | ../tools/ovsplit.py asm $$m > $$m.asm; done

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

silver.ovl: workvol $(ASM) $(SUBASM)
	besmtool write $(WORKVOL) --start=0 --length=10 --from-file=/dev/zero
	../tools/overlay.pl -o ' fortr*(cbdpr)' $(WORKVOL) 'fortr*' $(ASM) $(SUBASM) > build.lst
	sed -n '/END RECORD/,/CALL OCATALOG/p' build.lst | grep -v '^ *$$' | sed '1d;$$d' > loadmap
	besmtool dump $(WORKVOL) --start=1 --length=4 --to-file=$@

# loadmap keeps the load table (symbol table) printed by *CALL OVERLAY.
# after a build: which module or common block is misplaced or different
modcmp: silver.bin
	../tools/ovsplit.py cmp

clean:
	rm -f *.o silver.* *.b6 *~ *.out build.lst

clobber: clean
