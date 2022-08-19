all: diy
CC=gcc
CPPFLAGS=-Wall -ggdb -DLOCAL_MACHINE -pedantic -Wextra
SANFLAGS=-fsanitize=address -static-libasan -g

.PHONY: clean

diy: test.c co.c save_restore.s setjmp.h
	@as --64 -o save_restore.o save_restore.s
	@gcc $(CPPFLAGS) -c co.c -o co.o
	@gcc $(CPPFLAGS) -c test.c -o test.o
	@gcc $(CPPFLAGS) test.o co.o save_restore.o -o test

clean:
	rm *.o
	rm test
