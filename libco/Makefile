all: test
CC=gcc
CPPFLAGS=-Wall -ggdb -DLOCAL_MACHINE -pedantic -Wextra
# SANFLAGS=-fsanitize=address -static-libasan -g

.PHONY: clean

test: test.c co.c
	@$(CC) $(CPPFLAGS) $^ -o $@ $(SANFLAGS) -U_FORTIFY_SOURCE

clean:
	rm test
