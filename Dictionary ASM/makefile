ASM=nasm
ASMFLAGS=-f elf64

%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

dict.o:	dict.asm
lib.o:	lib.asm
words.inc:	colon.inc

main.o: lib.o dict.o main.asm words.inc
	nasm -f elf64 -o main.o main.asm

app: main.o 
	ld -o app main.o lib.o dict.o

.PHONY: clean
clean:
	rm *.o