# The Fortran compiler: root overlay FORTR* and its sub-overlay CBDPR
# (catalog 2048/0250). Both are cut into modules and common blocks by
# ../tools/ovsplit.py; the layouts are fortr.layout.py and cbdpr.layout.py.
WORKVOL = 80
LIBVOL = 81
OVSPLIT = ../tools/ovsplit.py

FORTR := $(addsuffix .asm,$(shell $(OVSPLIT) fortr modules))
CBDPR := $(addsuffix .asm,$(shell $(OVSPLIT) cbdpr modules))
CONTROL := $(addsuffix .asm,$(shell $(OVSPLIT) control modules))
ENDPRO := $(addsuffix .asm,$(shell $(OVSPLIT) endpro modules))
GLINK := $(addsuffix .asm,$(shell $(OVSPLIT) glink modules))
SUBS = cbdpr control endpro glink

# name, load address, first code address of each overlay
dis = disbesm6 -a$(2) -e$(3) -n$(1).sym

all: fortr.silver.dis $(addsuffix .silver.dis,$(SUBS))
	@for o in fortr $(SUBS); do $(OVSPLIT) $$o check; done

fortr.%.dis: fortr.%.bin fortr.sym
	$(call dis,fortr,1760,1770) $< > $@

cbdpr.%.dis: cbdpr.%.bin cbdpr.sym
	$(call dis,cbdpr,35064,35074) $< > $@

control.%.dis: control.%.bin control.sym
	$(call dis,control,35064,35074) $< > $@

endpro.%.dis: endpro.%.bin endpro.sym
	$(call dis,endpro,35064,35074) $< > $@

glink.%.dis: glink.%.bin glink.sym
	$(call dis,glink,35064,35074) $< > $@

%.bin: %.ovl
	../tools/ovl2bin < $< > $@

# FORTR*: zone 0260, block 04; CBDPR: zone 0262, block 034;
# CONTROL: zone 0264, block 035; ENDPRO: zone 0272, block 027; GLINK: zone 0273, block 026
fortr.gold.ovl:
	besmtool dump 2048 --start=0260 --length=4 --to-file=$@.
	dd bs=192 skip=4 < $@. > $@
	rm $@.

cbdpr.gold.ovl:
	besmtool dump 2048 --start=0262 --length=4 --to-file=$@.
	dd bs=192 skip=28 < $@. > $@
	rm $@.

control.gold.ovl:
	besmtool dump 2048 --start=0264 --length=12 --to-file=$@.
	dd bs=192 skip=29 < $@. > $@
	rm $@.

endpro.gold.ovl:
	besmtool dump 2048 --start=0272 --length=4 --to-file=$@.
	dd bs=192 skip=23 < $@. > $@
	rm $@.

glink.gold.ovl:
	besmtool dump 2048 --start=0273 --length=12 --to-file=$@.
	dd bs=192 skip=22 < $@. > $@
	rm $@.

# The error messages of the compiler: zones 0202-0205 of the system volume
errmsg.txt:
	besmtool dump 2048 --start=0202 --length=4 --to-file=/dev/stdout | ../tools/ftnerr.py > $@

# The overlays are rebuilt from the Madlen sources (*.asm) alone.
# `make asm` regenerates them from the disassembly: OV.gold.dis -> *.be
# (ovsplit.py be) -> BEMSH + DTRAN -> degak.py (no EQU) -> *.asm (ovsplit.py asm adds the common
# blocks and their DATA sections). It needs a terminal for the dispak listing.
# fortr goes first: cbdpr uses the entry names found in its .be files.
asm: fortr.gold.dis fortr.gold.bin $(foreach o,$(SUBS),$(o).gold.dis $(o).gold.bin)
	for o in $${OV:-fortr $(SUBS)}; do $(OVSPLIT) $$o be; \
	  for m in `$(OVSPLIT) $$o modules`; do \
	    WORKVOL=$(WORKVOL) ../tools/debemsh.sh $$m.be `test -f $$m.dtr && echo $$m.dtr` | ../tools/degak.py -o | $(OVSPLIT) $$o asm $$m > $$m.asm; \
	  done; done

workvol:
	mkdir -p ~/.besm6; touch ~/.besm6/$(WORKVOL) ~/.besm6/$(LIBVOL)

# The modules of all the overlays do not fit into the temporary library of
# one job: the sub-overlays other than CBDPR are assembled first, into a
# personal library on a second scratch volume.
lib.lst: $(CONTROL) $(ENDPRO) $(GLINK) | workvol
	besmtool write $(LIBVOL) --start=0 --length=64 --from-file=/dev/zero
	../tools/tolib.pl $(LIBVOL) $(CONTROL) $(ENDPRO) $(GLINK) > $@

# One link makes both overlays: the overlay data are ANYTHING(FORTR*) and
# FORTR*(CBDPR). loadmap keeps the load table (symbol table) that
# *CALL OVERLAY prints; the catalog at the end of the listing tells where
# each overlay landed on the scratch volume (zone and block, octal).
build.lst: $(FORTR) $(CBDPR) lib.lst | workvol
	besmtool write $(WORKVOL) --start=0 --length=40 --from-file=/dev/zero
	../tools/overlay.pl -p $(LIBVOL) -o ' fortr*(cbdpr,control,endpro,glink)' $(WORKVOL) 'fortr*' $(FORTR) $(CBDPR) > $@
	sed -n '/END RECORD/,/CALL OCATALOG/p' $@ | grep -v '^ *$$' | sed '1d;$$d' > loadmap

extract = set -- `awk '$$1 == "$(1)" && $$2 == 60 { print $$3, $$4 }' build.lst`; \
	besmtool dump $(WORKVOL) --start=0$$1 --length=12 --to-file=$@. && \
	dd bs=192 skip=$$((0$$2)) < $@. > $@; rm -f $@.

fortr.silver.ovl: build.lst
	$(call extract,FORTR*)

cbdpr.silver.ovl: build.lst
	$(call extract,CBDPR)

control.silver.ovl: build.lst
	$(call extract,CONTROL)

endpro.silver.ovl: build.lst
	$(call extract,ENDPRO)

glink.silver.ovl: build.lst
	$(call extract,GLINK)

# after a build: which module or common block is misplaced or different
modcmp: fortr.silver.bin $(addsuffix .silver.bin,$(SUBS))
	-for o in fortr $(SUBS); do $(OVSPLIT) $$o cmp; done

# The same overlays in an older edition, on the Dubna installation tape
# monsys.9 (zones of 1024 words, no service words; catalog at zone 1, word
# 01400). The root is FORTRAN there, loaded at 01604; the sub-overlays load
# at 34570. `make monsys9` compares them with ours module by module.
MONSYS9 ?= ../../../dubna/tapes/monsys.9
# overlay, place of its RLE stream on the tape (zone, word; octal)
TAPE_fortr = 043 01740
TAPE_cbdpr = 046 01440
TAPE_control = 050 01500
TAPE_endpro = 056 01200
TAPE_glink = 057 01140

monsys9/%.bin: $(MONSYS9)
	mkdir -p monsys9
	set -- $(TAPE_$*); dd bs=6 skip=$$((0$$1 * 1024 + 0$$2)) status=none < $< | ../tools/ovl2bin > $@

monsys9: fortr.gold.bin $(addsuffix .gold.bin,$(SUBS)) $(addprefix monsys9/,$(addsuffix .bin,fortr $(SUBS)))
	../tools/ovlver.py fortr monsys9/fortr.bin
	for o in $(SUBS); do ../tools/ovlver.py $$o monsys9/$$o.bin -r monsys9/fortr.bin; done

.PHONY: monsys9

.SECONDARY:

clean:
	rm -f *.o *.silver.* *.b6 *~ *.out build.lst lib.lst

clobber: clean
