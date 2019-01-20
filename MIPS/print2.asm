global _start ; punkt wejścia – inf. dla konsolidatora

section .data
    prompt: db "Hello, world!", 10
    prompt_len: equ $ - prompt

    end_msg: db 10, "Game Over!", 10
    end_msg_len: equ $ - end_msg

section .bss
        var: resw 1

section .text
_start:

    mov eax, 18

;32-bit number is in eax
print_int:
    mov ecx, 0   ;counter
    mov edx, 0   ;rest
    mov ebx, 10  ;
 loop1:
 ;   cdq
    idiv ebx      ; Divides eax by 10. edx = rest and eax = next_value
    add eax, 48
    mov [var], eax

    mov ecx, var    ; pointer to the value being passed
        ; print a byte to stdout
    mov eax, 4           ; the system interprets 4 as "write"
    mov ebx, 1           ; standard output (print to terminal)

    mov edx, 1           ; length of output (in bytes)
    int 0x80             ; call the kernel
end:
    mov eax, 1
    xor ebx, ebx
    int 0x80