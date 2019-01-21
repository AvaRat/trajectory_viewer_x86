%include "print.asm"
%include "bounce.asm"
extern	printf
extern scanf
SECTION .DATA
	hello:     db 'read by assembly:',10
	helloLen:  equ $-hello
	fmt:    db " %ld", 10, 0	;# The printf format, "\n",'0'
	pixel_addres: dq 64
	x_speed: dq 64
	y_speed: dq 64
	speed_loss: dq 64
	rowstride: dq 64
	n_channels: dq 64

	minus_one:	dq -1.0



SECTION .TEXT
	GLOBAL draw

;------------------------
;
;
;void extern draw(guchar *pixel_array, 
;								int x_speed, int y_speed, 
;								int speed_loss, int rowstride, 
;								int n_channels);
;
;--------------------------
draw:
;#prolog
;#	pusha
	push rbp 			;# zapamiętanie wskaźnika ramki procedury wołającej
	push rbx
	mov rbp, rsp 	;# ustanowienie własnego wskaźnika ramki
;#cialo
;#zapisuje argumenty na stosie
	push rdi	;# pixel_array	rbp-8
	push rsi	;# x_speed			rbp-16
	push rdx	;# y_speed			rbp-24
	push rcx	;# speed_loss[%]		rbp-32
	push r8		;# rowstride		rbp-40
	push r9		;# n_channels		rbp-48

	mov rax, 100
	sub rax, rcx
	mov rcx, 100
	cvtsi2ss xmm1, rax	;# xmm1 = 100 - speed_loss
	cvtsi2ss xmm2, rcx
	divss xmm1, xmm2		;# xmm1 = (1000-speed_loss)/100
	cvtsi2ss xmm2, [rbp-16]	;# xmm2 = x_speed
	cvtsi2ss xmm3, [rbp-24]	;# xmm3 = y_speed

;#	addss xmm1, xmm2


	push r10	;# rbp-56
	push r11	;# rbp-64
	push r12	;# rbp-72
	push r13	;# rbp-80


	cvtss2si rdx, xmm2	;# rdx = x_speed
	cvtss2si rcx, xmm3	;# rcx = y_speed

	xor rdi, rdi
	xor rsi, rsi


main_loop:

;# @params:
;# rdi -> X(0)-coordinate
;# rsi -> Y(0)-coordinate
;# xmm2 -> Vx(0)	=	 speed[x] at the beginning
;# xmm3 -> Vy(0)	=	 speed[y] at the beginning
;# rbp-8  -> pixel_array address
;#	mov rdi, 0
;#	mov rsi, 0
	DRAW_UNTIL_HIT
;# rdi -> X(0)- last x coordinate
;# rsi -> Y(0)-last y coordinate
;# xmm2 rdx -> Vx(0)	=	 speed[x] at the end
;# xmm3 rcx -> Vy(0)	=	 speed[y] at the end

	mov rsi, 254
	cvtsi2ss xmm2, rdx	;#xmm2 = new_x_speed
	cvtsi2ss xmm3, rcx	;#xmm3 = new_y_speed

;#	cmp rdx, 512
;#	jge max_x_reached

;# speed
	mov rax, rdx
	PRINT_INT
	mov rax, rcx
	PRINT_INT
;# coordinates
	mov rax, rdi
	PRINT_INT
	mov rax, rsi
	PRINT_INT

	mulss xmm2, xmm1
	mulss xmm3, xmm1
;#	movss xmm4, [minus_one]
;#	mulss xmm3, xmm4		;# zmiana znaku y_speed

	cvtss2si rdx, xmm2	;# rdx = x_speed
	cvtss2si rcx, xmm3	;# rcx = y_speed
	mov rax, -1
	imul rcx, rax





 ;#speed after multiplication
;#	mov rax, rdx
;#	PRINT_INT
;#	mov rax, rcx
;#	PRINT_INT

;#	cvtss2si rax, xmm2	;# rdx = x_speed
;#	PRINT_INT
;#	cvtss2si rax, xmm3	;# rcx = y_speed
;#	PRINT_INT


	jmp main_loop



end:
	mov rax, 8888
		PRINT_INT


	
max_x_reached:	
		mov rax, 22222222
		PRINT_INT

		add rsp, 80		; release the stack
	;#epilog
		pop rbx
		pop rbp
	;#	popa
	  ret                        ;# Return control




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
	
