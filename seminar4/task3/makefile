string.o:	string.asm
	nasm -f elf64 -o string.o string.asm

app:	string.o hello.c
	gcc hello.c string.o -o hello

.PHONY: clean
clean:
	rm *.o