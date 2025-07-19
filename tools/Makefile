# cosy2txt is a helper tool for the disassembly process
cosy2txt: cosy2txt.o encoding.o
	$(CXX) $(CFLAGS) -o $@ $^

encoding.o: encoding.cpp encoding.h gost10859.h

cosy2txt.o: cosy2txt.cpp encoding.h

clean:
	rm -f *.o

clobber: clean
	rm cosy2txt
