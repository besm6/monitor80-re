export WORKVOL = 80
MODULES = \
	дай%си%м \
	overlay \
	overlay% \
	newplace 

LOADLIBR = \
	g02771 \
	statsum \
	loadlibr \
	os_besm6 \
	pt6_g \
	savelist \
	tail

.PRECIOUS: %.orig %.dis

all: $(addsuffix .diff,$(MODULES)) reduol.diff loadlibr.diff

reduol.orig:
	besmtool dump 2048 --start=0207 --length=1 > $@

loadlibr.orig:
	besmtool dump 2048 --start=0206 --length=1 > $@

boot.orig:
	 besmtool dump 2048 --start=0210 --length=1 | head -100 > $@
	sed -i '100,$$d' $@

reduol.dis: reduol.obj
	../tools/linker.pl -zone 0207 -top reduol reduol.obj

loadlibr.dis: $(addsuffix .obj,$(LOADLIBR))
	../tools/linker.pl -zone 0206 -top loadlibr $^

boot.dis: boot.obj
	../tools/linker.pl -zone 0210 -top boot $^
	sed -i '100,$$d' $@

%.diff: %.dis %.orig
	diff -C 3 $^ && touch $@

%.dis: %.masm
	../tools/asm.pl $<

%.dis: %.asm
	../tools/asm.pl $<

%.obj: %.asm
	../tools/tostar.pl $<

%.orig:
	../tools/disas.pl -zone 1350 $(basename $@)

clean:
	rm -f *.b6 *.diff

clobber: clean
	rm -f *.dis *.orig *~
