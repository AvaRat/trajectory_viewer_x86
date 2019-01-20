%include "print.asm"

SECTION .DATA
	hello:     db 'Hello world!',10
	helloLen:  equ $-hello
	int_: dw 1

SECTION .TEXT
	GLOBAL sum

;------------------------
;int64_t sum(int64_t *a, int64_t b)
;save result of *a + b to a
;
;--------------------------
sum:
;#prolog
	push rbp 			;# zapamiętanie wskaźnika ramki procedury wołającej
	mov rbp, rsp 	;# ustanowienie własnego wskaźnika ramki
;#cialo
	mov eax,4            ; write()
	mov ebx,1            ; STDOUT
	mov ecx,hello
	mov edx,helloLen
	int 80h                 ; Interrupt

	
	mov rax, [rdi]
;	lea rcx, rax
;	mov rcx, 150
	PRINT_INT 1
	mov rcx, 123
	mov [rdi], dword 340
	add rdi, 8
	mov [rdi], dword 120
	add rdi, 8
	mov [rdi], dword 190

;#epilog
	pop rbp
  ret                        ; Return control