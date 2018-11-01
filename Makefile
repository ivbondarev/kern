qemu:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin

qemu-gdb:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin -S -gdb tcp::9000

mbr: mbr.asm
	nasm -f bin mbr.asm -o bin/mbr.bin

bootloader: bootloader.c
	gcc -O0 -m32 -march=i386 -c bootloader.c -o obj/bootloader.o
	ld obj/bootloader.o -o bin/bootloader.bin -format=binary -Ttext=0x200 -melf_i386

kernel: mbr bootloader
	cat bin/mbr.bin bin/bootloader.bin > bin/kern.bin

clean_bins:
	rm bin/*
