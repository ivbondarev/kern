Build depends:
nasm

To build bootsector:
	nasm bootloader.s
It will produce 512-bytes boot sector for 8086 arch.

xxd bootsector
objdump -D -b binary -m i386 bootsector

Run qemu:
qemu-system-i386 -drive format=raw,file=bootloader
