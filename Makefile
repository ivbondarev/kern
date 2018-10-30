mbr: mbr.s
	nasm -f bin mbr.s -o bin/mbr.bin

qemu:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin
qemu-gdb:
	qemu-system-i386 -drive format=raw,file=bin/kern.bin -S -gdb tcp::9000
