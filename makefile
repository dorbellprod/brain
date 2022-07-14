all:
	nasm -f elf64 -gdwarf main.asm
	ld -m elf_x86_64 main.o -o main
