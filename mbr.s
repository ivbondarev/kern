[BITS 16]
[ORG 0x7C00]

segment .text
global asm_main
asm_main:
	cli
	xor ax, ax
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, 0x7C00 ; 30KB hole
	mov si, DAP
	mov ah, 0x42
	int 0x13
	call 0x8000 ; _start() function, 0x7E00 + 0x200

segment .data
DAP:
	db 0x10 ; DAP size
	db 0 ; unused
	dw 10 ; number of sectors
	dw 0x7E00 ; offset
	dw 0 ; segment
	dq 1 ; start sector
	resb 466
	db 0x55
	db 0xAA
