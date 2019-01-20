	.data
prompt: .asciiz "put a string of digits\n"
input: .space 100
output: .space 100
lenght: .byte 0

	.text
	.globl main
main:
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $s1, '0'
	li $s2, '9'
	li $s3, '\n'
	la $s4, input
	la $s5, lenght
	lb $t7, ($s5)
read:	
	li $v0, 12
	syscall
	beq $v0, $s3, next
	bgt $v0, $s2, read
	blt $v0, $s1, read	
	sb $v0, ($s4)
	addi $s4, $s4, 1
	addi $t7, $t7, 1
	b read
	
next:
	sb $t7, ($s5)
	li $s4, '1'
	li $t7, 0
	la $s6, lenght
	lb $t6, ($s6)	#input lenght
		 
	la $s1, input
	la $s2, output
loop:
	lb $t1, ($s1)
	
	sub $t2, $s2, $t1
	#addi $t1, $t2, $s1
	add $t1, $t2, $s1
	sb $t1, ($s2)
	
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	addi $t7, $t7, 1	#counter incrementation
	beq $t7, $t6, end
	b loop


end:
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 4
	la $a0, output
	syscall
	
	li $v0, 10
	syscall
