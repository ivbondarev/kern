CC=gcc
CFLAGS=-O0 -m32 -march=i386 -nostdlib -nostartfiles -nodefaultlibs \
	-fno-builtin -Wall -Werror

qemu:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin

qemu-gdb:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin -S -gdb tcp::9000

mbr: mbr.asm
	nasm -f bin mbr.asm -o bin/mbr.bin

lib.o: lib.c
	$(CC) $(CFLAGS) -c lib.c -o obj/lib.o

elf32.o: elf32.c
	$(CC) $(CFLAGS) -c elf32.c -o obj/elf32.o

bootloader.o: bootloader.c
	$(CC) $(CFLAGS) -c bootloader.c -o obj/bootloader.o

bootloader: lib.o elf32.o bootloader.o
	ld obj/bootloader.o obj/elf32.o obj/lib.o \
		-o bin/bootloader.bin -format=binary -Ttext=0x20000 -melf_i386

kernel: mbr bootloader
	cat bin/mbr.bin bin/bootloader.bin > bin/kern.bin

clean_bins:
	rm bin/* && rm obj/*
