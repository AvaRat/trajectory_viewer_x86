;# @params:
;# rdi -> X(0)-coordinate
;# rsi -> Y(0)-coordinate
;# rdx -> xmm2 Vx(0)	=	 speed[x] at the beginning
;# rcx -> xmm3 Vy(0)	=	 speed[y] at the beginning
;# rbp-8  -> pixel_array address
;##
;# retval:
;# rdi -> X(0)- last x coordinate
;# rsi -> Y(0)-last y coordinate
;# rdx -> xmm2 Vx(0)	=	 speed[x] at the end
;# rcx -> xmm3 Vy(0)	=	 speed[y] at the end
;# void -> it draws a function until it reaches one of the edges
;# dt = 0.1s
;# (x,y) = (10,10) equals (1m,1m)

SECTION .TEXT

%macro DRAW_UNTIL_HIT 0
;#	mov rdi, 0
;#	mov rsi, 0
;#	mov rdx, [rbp-16]
;#	mov rcx, [rbp-24]

	  mov r8, [rbp-8]    ;# r8 = pixel buffer address

  %%drawing_loop:


    add rdx, 0    ;# dx = const
    add rcx, 1    ;# dy += 1 (g = 10m/s^2)
  ;#  cvtss2si rdx, xmm2  ;# x_speed
  ;#  cvtss2si rcx, xmm3  ;# y_speed

    add rdi, rdx  ;# x += dx
    add rsi, rcx  ;# y += dy

    cmp rdi, 512
    jge max_x_reached
    cmp rsi, 255
    jge %%max_y_reached
    cmp rsi, 0
    jle %%max_y_reached

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

;#    cvtsi2ss xmm2, rdx
;#    cvtsi2ss xmm3, rcx


    jmp %%drawing_loop
	


%%max_y_reached:
  mov rax, 1111111
  PRINT_INT
  %endmacro
