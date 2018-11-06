[BITS 16]
[ORG 0x7C00]

%define roundup(size) ((size + 3) & ~3)

global asm_main

segment .text
asm_main:
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
	smsw ax
	or ax, 1
	lmsw ax
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:0x8000 ; _start() function, 0x7E00 + 0x200

text_sect_size equ roundup(($ - $$))

segment .data
align 4
align_size equ ($$ - text_sect_size)
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
	db 10011010b
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
	times  (510 - text_sect_size - ($ - $$)) db 0
	db 0x55
	db 0xAA
