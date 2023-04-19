.data
	input_msg:		.asciiz "Input: "
	output_msg:		.asciiz "Output: "
	vowels:			.asciiz "eaoiu"
	buffer_size:	.word 128

.text
	.globl reverse_vowels
	.globl read_string
	.globl is_vowel
main:
	jal reverse_vowels

	li $v0 10
	syscall


reverse_vowels:
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $ra, 4($sp)
	sw $s0, 0($sp)

	li $v0, 4
	la $a0, input_msg
	syscall

	jal read_string						#take user input and store the vowels in the stack
	move $s0, $v0						#s0 = address of the input

	li $v0, 4
	la $a0, output_msg
	syscall

#move the sp to the beginning of the vowels
	addi $sp, $sp, -32
	sub $sp, $sp, $v1

print_modified_string:
	lbu $a0, 0($s0)						#a0 = current character
	addi $s0, $s0, 1					#increment the address
	beq $a0, $zero, done				#if the current character is null
	jal is_vowel
	bne $v0, $zero, switch_vowels		#if the current character is a vowel
	j print_char
switch_vowels:
	lbu $a0, 0($sp)						#get the vowel from end of the string
	addi $sp, $sp, 1					#increment the sp
print_char:
	li $v0, 11
	syscall
	j print_modified_string				#continue loop
	
done:
	
	li $a0, 10							#t0 = '\n'
	syscall								#print new line character
	
	addi $sp, $sp, 32					#restore the sp

	lw $a0, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8

	jr $ra


read_string:
	addi $sp, $sp, -32
	sw $a0, 28($sp)
	sw $a1, 24($sp)
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)

#allocate buffer_size bytes of memory for the string input
	la $a0, buffer_size
	lw $a0, 0($a0)						#a0 = buffer_size
	li $v0, 9
	syscall

	move $a1, $a0						#a1 = buffer_size
	move $a0, $v0						#a0 = address of the input buffer
	li $v0, 8
	syscall
	
	move $s0, $a0						#s0 = address of the input buffer
	li $s1, 0							#s1 = current index
	li $s2, 10							#s2 = '\n'
	li $s3, 0							#s3 = number of vowels

read_loop:
	add $s4, $s0, $s1					#t0 = address of the current character
	lbu $a0, 0($s4)						#a0 = current character
	beq $a0, $s2, exit_read_string		#if current character is '\n'
	beq $a0, $zero, exit_read_string	#if current character is '\0'
	addi $s1, $s1, 1					#increment index

	jal is_vowel

	bne $v0, $zero, add_vowel			#if the current character is vowel
	j read_loop
add_vowel:
	addi $s3, $s3, 1					#increment number of vowels by 1
	addi $sp, $sp, -1					#decrement sp for the vowel
	sb $a0, 0($sp)						#store the vowel in the stack
	j read_loop							#continue loop

exit_read_string:
	sb $zero, 0($s4)					#override if the current character is '\n'
	move $v0, $s0						#v0 = input address
	move $v1, $s3						#v1 = number of vowels

	add $sp, $sp, $v1					#restore the stack position before the vowels were entered

	lw $a0, 28($sp)
	lw $a1, 24($sp)
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	lw $s3, 4($sp)
	lw $s4, 0($sp)
	addi $sp, $sp, 32

	jr $ra


is_vowel:
	li $t0, 0							#t0 = current index
	la $t1, vowels						#t1 = address of the vowels
	li $v0, 0							#if(a0 is vowel) v0 = 0; else v0 = 1

vowel_loop:
	add $t2, $t1, $t0					#t2 = address of the current vowel
	lbu $t3, 0($t2)						#t3 = current vowel (lowercase)
	beq $t3, $zero, exit_vowel			#exit when null
	beq $t3, $a0, vowel					#if a0 is vowel (lowercase)
	addi $t3, $t3, -32					#t3 = current vowel (uppercase)
	beq $t3, $a0, vowel					#if a0 is vowel (uppercase)
	addi $t0, $t0, 1					#increment index
	j vowel_loop

vowel:
	addi $v0, $v0, 1					#v0 is vowel
exit_vowel:
	jr $ra