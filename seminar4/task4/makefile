CFLAGS     = -g -O2 -Wall -Werror -std=c17 -Wdiscarded-qualifiers -Wincompatible-pointer-types -Wint-conversion
CC         = gcc
LD         = gcc
ASM        = nasm
ASMFLAGS   =-felf64 -g

main:	main.o lib.o 
	$(LD) -o $@ $^

main.o: main.c
	$(CC) -c $(CFLAGS) -o $@ $<

lib.o: lib.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	$(RM) *.o

.PHONY: clean