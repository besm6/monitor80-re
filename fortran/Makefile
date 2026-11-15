# The Fortran compiler: root overlay FORTR* and its sub-overlay CBDPR
# (catalog 2048/0250). Both are cut into modules and common blocks by
# ../tools/ovsplit.py; the layouts are fortr.layout.py and cbdpr.layout.py.
WORKVOL = 80
OVSPLIT = ../tools/ovsplit.py

FORTR := $(addsuffix .asm,$(shell $(OVSPLIT) fortr modules))
CBDPR := $(addsuffix .asm,$(shell $(OVSPLIT) cbdpr modules))

# name, load address, first code address of each overlay
dis = disbesm6 -a$(2) -e$(3) -n$(1).sym

all: fortr.silver.dis cbdpr.silver.dis
	@$(OVSPLIT) fortr check; $(OVSPLIT) cbdpr check

fortr.%.dis: fortr.%.bin fortr.sym
	$(call dis,fortr,1760,1770) $< > $@

cbdpr.%.dis: cbdpr.%.bin cbdpr.sym
	$(call dis,cbdpr,35064,35074) $< > $@

%.bin: %.ovl
	../tools/ovl2bin < $< > $@

# FORTR*: zone 0260, block 04; CBDPR: zone 0262, block 034
fortr.gold.ovl:
	besmtool dump 2048 --start=0260 --length=4 --to-file=$@.
	dd bs=192 skip=4 < $@. > $@
	rm $@.

cbdpr.gold.ovl:
	besmtool dump 2048 --start=0262 --length=4 --to-file=$@.
	dd bs=192 skip=28 < $@. > $@
	rm $@.

# The error messages of the compiler: zones 0202-0205 of the system volume
errmsg.txt:
	besmtool dump 2048 --start=0202 --length=4 --to-file=/dev/stdout | ../tools/ftnerr.py > $@

# The overlays are rebuilt from the Madlen sources (*.asm) alone.
# `make asm` regenerates them from the disassembly: OV.gold.dis -> *.be
# (ovsplit.py be) -> BEMSH + DTRAN -> *.asm (ovsplit.py asm adds the common
# blocks and their DATA sections). It needs a terminal for the dispak listing.
# fortr goes first: cbdpr uses the entry names found in its .be files.
asm: fortr.gold.dis fortr.gold.bin cbdpr.gold.dis cbdpr.gold.bin
	for o in fortr cbdpr; do $(OVSPLIT) $$o be; \
	  for m in `$(OVSPLIT) $$o modules`; do \
	    WORKVOL=$(WORKVOL) ../tools/debemsh.sh $$m.be `test -f $$m.dtr && echo $$m.dtr` | $(OVSPLIT) $$o asm $$m > $$m.asm; \
	  done; done

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL)

# One link makes both overlays: the overlay data are ANYTHING(FORTR*) and
# FORTR*(CBDPR). loadmap keeps the load table (symbol table) that
# *CALL OVERLAY prints; the catalog at the end of the listing tells where
# each overlay landed on the scratch volume (zone and block, octal).
build.lst: $(FORTR) $(CBDPR) | workvol
	besmtool write $(WORKVOL) --start=0 --length=10 --from-file=/dev/zero
	../tools/overlay.pl -o ' fortr*(cbdpr)' $(WORKVOL) 'fortr*' $(FORTR) $(CBDPR) > $@
	sed -n '/END RECORD/,/CALL OCATALOG/p' $@ | grep -v '^ *$$' | sed '1d;$$d' > loadmap

extract = set -- `awk '$$1 == "$(1)" && $$2 == 60 { print $$3, $$4 }' build.lst`; \
	besmtool dump $(WORKVOL) --start=0$$1 --length=4 --to-file=$@. && \
	dd bs=192 skip=$$((0$$2)) < $@. > $@; rm -f $@.

fortr.silver.ovl: build.lst
	$(call extract,FORTR*)

cbdpr.silver.ovl: build.lst
	$(call extract,CBDPR)

# after a build: which module or common block is misplaced or different
modcmp: fortr.silver.bin cbdpr.silver.bin
	-$(OVSPLIT) fortr cmp
	-$(OVSPLIT) cbdpr cmp

.SECONDARY:

clean:
	rm -f *.o *.silver.* *.b6 *~ *.out build.lst

clobber: clean
