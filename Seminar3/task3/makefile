lib.o: lib.asm
	nasm -f elf64 -o lib.o lib.asm

main.o: main.asm
	nasm -f elf64 -o main.o main.asm

main: lib.o lib.inc main.o
	ld -o main lib.o  main.o