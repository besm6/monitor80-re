export WORKVOL = 80
MODULES = \
	newplace 

.PRECIOUS: %.orig %.dis

all: $(addsuffix .diff,$(MODULES))

%.diff: %.dis %.orig
	diff -C 3 $^ && touch $@

%.dis: %.masm
	../tools/asm.pl $<

%.dis: %.asm
	../tools/asm.pl $<

%.orig:
	../tools/disas.pl -lib $(basename $@)

clean:
	rm -f *.b6 *.diff

clobber: clean
	rm -f *.dis *.orig *~
