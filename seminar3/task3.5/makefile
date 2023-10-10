ASM=nasm
ASMFLAGS=-f elf64

%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $+

main: lib.o main.o
	ld -o $@ $+
	clean

.PHONY: clean
clean:
	rm lib.o
	rm main.o