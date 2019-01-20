segment .data
msg db "Hello World!", 0Ah

segment .text
    global _start
_start:
    mov eax, 2
    mov ebx, 42 ;exit status=42
    mov ecx, 0
power:
    ; Print 'A' character 
    mov   eax, 4      ; __NR_write from asm/unistd_32.h (32-bit int 0x80 ABI)
    mov   ebx, 1      ; stdout fileno

    push  'A'
    mov   ecx, esp    ; esp now points to your char
    mov   edx, 1      ; edx should contain how many characters to print
    int   80h         ; sys_write(1, "A", 1)

; return value in EAX = 1 (byte written), or error (-errno)
    
    
