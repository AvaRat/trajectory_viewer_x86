section .text
global f


f:
	push EBP
	mov EBP, ESP
	mov EAX, [EBP+8]
	
begin:
	mov cl, [EAX]
	cmp cl, 0
	jz end

	add cl, 1
	mov [EAX], cl
	inc EAX
	jmp begin
end:
