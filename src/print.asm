global _start ; punkt wejścia – inf. dla konsolidatora

section .data
    prompt: db "write 10 digits!", 10
    prompt_len: equ $ - prompt

    end_msg: db 10, "End of pragram!", 10
    end_msg_len: equ $ - end_msg

    enter: db "   ", 10
    enter_len: equ $ - enter

section .bss
     variable: resw 1
     input_buff: resb 64
     int_out: resb 64
     int_out_len: resw 1

; asemblacja: nasm -f elf32 print.asm -o print.o
; konsolidacja: ld -m elf_i386 -o out print.o

section .text

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


;64-bit number is in rax
%macro PRINT_INT 0
%%print_int:
    push rcx
    push rdx
    push rbx
    push rax
    push r8
    push r9
    push r10
    push r11
    mov rcx, 0   ;counter
    mov rdx, 0   ;rest
    mov rbx, 10  ;
 %%loop1:
    cdq
    idiv rbx      ; Divides eax by 10. edx = rest and eax = next_value
    add rdx, '0'
    push rdx
    inc rcx
    cmp rax, 10
    jae %%loop1

    add rax, '0'
    push rax ; save first digit
    mov [int_out_len], rcx  ; save number of digits
    xor rbx, rbx    ;ebx = 0
    inc rcx
%%save_int:
    pop rax
    mov [int_out+rbx], rax
    inc rbx
    loop %%save_int

    mov rax, 1
    sub [int_out_len], rax

%%print:
    mov rdx, int_out_len
    mov rcx, int_out
    mov rbx, 1
    mov rax, 4
    int 0x80

    mov rdx, enter_len
    mov rcx, enter
    mov rbx, 1
    mov rax, 4
    int 0x80
    pop r11
    pop r10
    pop r9
    pop r8
    pop rax
    pop rbx
    pop rdx
    pop rcx

%endmacro

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
