[BITS 16]
[ORG 0x7C00]

segment .text
global asm_main
asm_main:
text_start:
	cli
	; Disable NMI
	in al, 0x70
	or al, 0x80
	out 0x70, al
	xor ax, ax
	; cs must be 0 already
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, 0x7C00 ; 30KB hole
	; Read 2'nd bootloader
	mov si, DAP
	mov ah, 0x42
	int 0x13
	; Fast A20
	in al, 0x92
	or al, 2
	out 0x92, al
	; Enable PM
	lgdt [gdt_info]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp 0x08:0x8000 ; _start() function, 0x7E00 + 0x200v
	jmp $

segment .data
DAP:
	db 0x10 ; DAP size
	db 0 ; unused
	dw 10 ; number of sectors
	dw 0x7E00 ; offset
	dw 0 ; segment
	dq 1 ; start sector
gdt:
gdt_null:
	dq 0
gdt_code_seg:
	dw 0xFFFF
	dw 0
	db 0
	db 10001101b
	db 11001111b
	db 0
gdt_data_seg:
	dw 0xFFFF
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0
gdt_info:
	dw 23
	dd gdt
gdt_end:
	times 404 db 0
	db 0x55
	db 0xAA
