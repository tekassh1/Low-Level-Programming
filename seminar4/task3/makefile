CFLAGS     = -g -O2 -Wall -Werror -std=c17 -Wdiscarded-qualifiers -Wincompatible-pointer-types -Wint-conversion
CC         = gcc
LD         = gcc
ASM        = nasm
ASMFLAGS   =-felf64 -g

hello: hello.o string.o
	$(LD) -o $@ $^

hello.o: hello.c
	$(CC) -c $(CFLAGS) -o $@ $<

string.o: string.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	$(RM) hello hello.o string.o

.PHONY: clean