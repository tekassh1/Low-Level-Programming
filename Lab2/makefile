dict.o: dict.asm
	nasm -f elf64 -o dict.o dict.asm

lib.o: lib.asm
	nasm -f elf64 -o lib.o lib.asm

main.o: lib.o dict.o main.asm words.inc colon.inc
	nasm -f elf64 -o main.o main.asm

app: main.o
	ld -o app main.o lib.o dict.o