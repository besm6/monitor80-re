export WORKVOL = 80
MODULES = \
	%pascal \
	blexprin \
	clearlex \
	cosytiso \
	drumtap% \
	edit%%% \
	erriom \
	execut \
	ficmem% \
	ficmemor \
	givcall% \
	givelexx \
	givlibr% \
	givtran% \
	ident6 \
	iocont% \
	ioxgivem \
	ioxrcb \
	ioxrpt \
	ioxxdr \
	ioxxer_m \
	ioxxfmr% \
	ioxxlpwt \
	ioxxpkrt \
	ioxxpkwt \
	ioxxptwt \
	ioxxsfw% \
	ioxxsowt \
	ioxxttrt \
	ioxxttwt \
	iso_gost \
	loadango \
	loadf \
	ltable% \
	lun%mon \
	mon%itor \
	monitor% \
	monitor_ \
	monread% \
	newlis \
        paramt% \
	print8 \
	pt8read \
	rd_bt \
	sdec% \
	setftn \
	setiodcb \
	setwlexx \
	simfail% \
	stacomp% \
	star% \
	stload% \
	stop% \
	tabsimis \
	ttable%

TODO = \
	paramt%

.PRECIOUS: %.orig %.dis

all: $(addsuffix .diff,$(MODULES))

%.diff: %.dis %.orig
	diff -C 3 $^ && touch $@

%.dis: %.masm
	./asm.pl $<

%.dis: %.asm
	./asm.pl $<

%.orig:
	./disas.pl $(basename $@)

clean:
	rm -f *.b6 *.diff

clobber: clean
	rm -f *.dis *.orig *~
