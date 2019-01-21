

;# writing values (OLD)
	mov eax,4            ;# write()
	mov ebx,1            ;# STDOUT
	mov ecx,hello
	mov edx,helloLen
	int 80h                 ;# Interrupt


;#write to buffer
head:
	mov rcx, 6
pop_loop:
	pop rax
	push rcx
	mov	rdi,fmt		;# format for printf  powinno byc n_channels = 3
	mov	rsi,rax         ; first parameter for printf
	mov	rdx,rax         ; second parameter for printf
	mov	rax,0		; no xmm registers
  call    printf		; Call C function
	pop rcx
	loop pop_loop



;# trajectory bounce tryout
;# @params:
;# rdi -> X(0)-coordinate
;# rsi -> Y(0)-coordinate
;# rdx -> Vx(0)	=	 speed[x] at the beginning
;# rcx -> Vy(0)	=	 speed[y] at the beginning
;# rbp-8  -> pixel_array address
;##
	mov rdi, 0
	mov rsi, 0
	mov rdx, [rbp-16]
	mov rcx, [rbp-24]

	  mov r8, [rbp-8]    ;# r8 = pixel buffer address



  drawing_loop:

		mov rax, rcx
		PRINT_INT

    add rdx, 0    ;# dx = const
    add rcx, 1    ;# dy += 1 (g = 10m/s^2)

    add rdi, rdx  ;# x += dx
    add rsi, rcx  ;# y += dy

    cmp rdi, 250
    jge max_x_reached
    cmp rsi, 250
    jge max_x_reached

	mov r12, rdx
	mov r13, rcx

;# r10 -> x_coordinate
;# r11 -> y_coordinate
;# rdx -> rowstride
;# rcx -> n_channels
;# r8 -> pixel_array_address
		mov r10, rdi
		mov r11, rsi
    mov rdx, [rbp-40]     ;#rdx = rowstride
    mov rcx, [rbp-48]     ;#rcx = n_channels


    WRITE_XY

		mov rdx, r12
		mov rcx, r13

    jmp drawing_loop
	
