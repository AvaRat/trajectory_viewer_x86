section .text

;# r10 -> x_coordinate
;# r11 -> y_coordinate
;# rdx -> rowstride
;# rcx -> n_channels
;# r8 -> pixel_array_address
%macro WRITE_XY 0
    push rax
    push rdx
    push r11
    push r10
    push r8
		mov rax, rdx	;# rax = rowstride
		mul r11
		mov r11, rax	;# r11 = rowstride*y
		mov rax, rcx	;# rax = n_channels
		mul r10
		mov r10, rax	;# r10 = n_channels*x
		add r10, r11	;# r10 = r10 + r11
		add r8, r10		;# r8 = pixel_array + r10
		mov dl, 255
		mov [r8], dl	;# save dl pixel to r8
    pop r8
    pop r10
    pop r11
    pop rdx
    pop rax
%endmacro