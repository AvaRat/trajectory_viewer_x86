global _start ; punkt wejścia – inf. dla konsolidatora

section .data
    prompt: db "write 10 digits!", 10
    prompt_len: equ $ - prompt

    end_msg: db 10, "End of pragram!", 10
    end_msg_len: equ $ - end_msg

section .bss
     variable: resw 1
     input_buff: resb 64
     int_out: resb 64
     int_out_len: resw 1

; asemblacja: nasm -f elf32 print.asm -o print.o
; konsolidacja: ld -m elf_i386 -o out print.o

section .text
_start:
print_massage:
    mov edx, prompt_len
    mov ecx, prompt
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; read 5 a byte from stdin
    mov eax, 3		 ; 3 is recognized by the system as meaning "read"
    mov ebx, 0		 ; read from standard input
    mov ecx, variable        ; address to pass to
    mov edx, 5		 ; input length (one byte)
    int 0x80                 ; call the kernel

    mov esi, variable
    mov ecx, 4
    call string_to_int


 ;   mov eax, 123456789
;32-bit number is in eax
print_int:
    mov ecx, 0   ;counter
    mov edx, 0   ;rest
    mov ebx, 10  ;
 loop1:
    cdq
    idiv ebx      ; Divides eax by 10. edx = rest and eax = next_value
    add edx, '0'
    push edx
    inc ecx
    cmp eax, 10
    jae loop1

    add eax, '0'
    push eax ; save first digit
    mov [int_out_len], ecx  ; save number of digits
    xor ebx, ebx    ;ebx = 0
    inc ecx
save_int:
    pop eax
    mov [int_out+ebx], eax
    inc ebx
    loop save_int

    mov eax, 1
    sub [int_out_len], eax

write_int:
    mov edx, int_out_len
    mov ecx, int_out
    mov ebx, 1
    mov eax, 4
    int 0x80

print_goodby:
    mov edx, end_msg_len
    mov ecx, end_msg
    mov ebx, 1
    mov eax, 4
    int 0x80

return_0:
    mov eax, 1
    xor ebx, ebx
    int 0x80


; Input:
; ESI = pointer to the string to convert
; ECX = number of digits in the string (must be > 0)
; Output:
; EAX = integer value
string_to_int:
  xor ebx,ebx    ; clear ebx
.next_digit:
  movzx eax,byte[esi]
  inc esi
  sub al,'0'    ; convert from ASCII to number
  imul ebx,10
  add ebx,eax   ; ebx = ebx*10 + eax
  loop .next_digit  ; while (--ecx)
  mov eax,ebx
  ret
