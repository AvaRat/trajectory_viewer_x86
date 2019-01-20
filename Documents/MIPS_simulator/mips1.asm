	.data
prompt:	.asciiz "insert a string ended with enter\n"
text: .space 30
buff: .space 30
max: .byte 'z'

	.text
	.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8	#string is in $v0
	la $a0, buff	
	li $a1, 20
	syscall
	
	la $t0, buff	#string is in $t0
	la $t5, text	#new string is in $t5
	li $t6, 0	#counter in $t6
	la $a0, max
loop:	
	lb $t1, 0($t0)
	beqz $t1, sort		#	sb $t1, $t5
	add $t0, $t0, 1
	add $t6, $t6, 1
	j loop

sort:

	
	la $t0, buff	#current byte is in $t0
	
	li $v1, 'z'	#min value is in $v1
	# j find_min
	
	
#####
find_min:	#previous min value in $v1
	lb $t2, 0($t0)
	beqz $t2, end		# returns min value in $v0
	blt $t2, $v1, new_min	##if $t1 < $v0

	add $t0, $t0, 1	#next byte from buff in $t0
	j find_min
	
new_min:
	la $v1, ($t2)	#new min value is in $v0
	add $t0, $t0, 1		#next byte from buff in $t0
	j find_min
#####	
end:
#	sb $v1, ($t5)
	
	la $a3, text #prints min value from find_min
	lb $a0, ($a3)
	li $v0, 11
	syscall 
	
#	lb $a0, ($t6)	#prints counter
#	li $v0, 1
#	syscall	
	
	li $v0, 4
	la $a0, text
	syscall
	
	li $v0, 10
	syscall
