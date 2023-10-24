app:	hello_mmap.asm hello.txt
	nasm -f elf64 -o hello_mmap.o hello_mmap.asm
	ld -o app hello_mmap.o

.PHONY: clean
clean:
	rm *.o