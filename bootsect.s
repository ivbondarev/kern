segment .text
global asm_main
asm_main:
	jmp $

segment .data
	resb 506
	db 0x55
	db 0xAA
