WORKVOL = 80

MODULES := $(shell ../tools/ovsplit.py modules)
ASM = $(addsuffix .asm,$(MODULES))
# CBDPR is a sub-overlay of FORTR*: its modules refer to the modules, entries
# and common blocks of the root by name, so the root is built along with it.
ROOTASM := $(addprefix ../fortr/,$(addsuffix .asm,$(shell cd ../fortr; ../tools/ovsplit.py modules)))

cmp.out: gold.dis silver.dis
	../tools/cmp.sh

silver.dis: silver.bin cbdpr.sym
	disbesm6 -a35064 -e35074 -ncbdpr.sym $< > $@

gold.dis: gold.bin cbdpr.sym
	disbesm6 -a35064 -e35074 -ncbdpr.sym $< > $@

gold.bin: gold.ovl
	../tools/ovl2bin < $< > $@

silver.bin: silver.ovl
	../tools/ovl2bin < $< > $@

# CBDPR of FORTR*: catalog 2048/0250, zone 0262, block 034
gold.ovl:
	besmtool dump 2048 --start=0262 --length=4 --to-file=$@.
	dd bs=192 skip=28 < $@. > $@
	rm $@.

# The overlay is rebuilt from the Madlen sources (*.asm) alone.
# `make asm` regenerates them from the disassembly: gold.dis -> *.be
# (ovsplit.py be, layout in layout.py) -> BEMSH + DTRAN -> *.asm (ovsplit.py
# asm adds the common blocks and their DATA sections). It needs a terminal
# for the dispak listing, and ../fortr/*.be for the entry names of the root.
asm: gold.dis gold.bin
	../tools/ovsplit.py be gold.dis
	for m in $(MODULES); do \
	  WORKVOL=$(WORKVOL) ../tools/debemsh.sh $$m.be | ../tools/ovsplit.py asm $$m > $$m.asm; done

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

# The catalog printed at the end of the listing tells where CBDPR landed
# (zone and block, octal).
silver.ovl: workvol $(ASM) $(ROOTASM)
	besmtool write $(WORKVOL) --start=0 --length=10 --from-file=/dev/zero
	../tools/overlay.pl -o ' fortr*(cbdpr)' $(WORKVOL) 'fortr*' $(ROOTASM) $(ASM) > build.lst
	sed -n '/END RECORD/,/CALL OCATALOG/p' build.lst | grep -v '^ *$$' | sed '1d;$$d' > loadmap
	set -- `awk '$$1 == "CBDPR" && $$2 == 60 { print $$3, $$4 }' build.lst`; \
	besmtool dump $(WORKVOL) --start=0$$1 --length=4 --to-file=$@. && \
	dd bs=192 skip=$$((0$$2)) < $@. > $@
	rm $@.

# loadmap keeps the load table (symbol table) printed by *CALL OVERLAY.
# after a build: which module or common block is misplaced or different
modcmp: silver.bin
	../tools/ovsplit.py cmp

clean:
	rm -f *.o silver.* *.b6 *~ *.out build.lst

clobber: clean
