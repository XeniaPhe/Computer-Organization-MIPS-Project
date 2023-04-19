.data
	welcometext:	.asciiz "Welcome to our MIPS project!\n"
	menutext:		.asciiz "Main Menu:\n1.Find Palindrome\n2.Reverse Vowels\n3.Find Distinct Prime\n4.Lucky Number\n5.Exit\nPlease select an option: "
	invalidtext:	.asciiz "Invalid Input!\n"
	exittext:		.asciiz "Program ends. Bye :)\n"
	proc_1text:		.asciiz "Find Palindrome\n"
	proc_2text:		.asciiz "Reverse Vowels\n"
	proc_3text:		.asciiz "Find Distinct Prime\n"
	proc_4text:		.asciiz "Lucky Number\n"

.text
	.globl main_menu
	.globl proc_1
	.globl proc_2
	.globl proc_3
	.globl proc_4
main:
	jal main_menu

	li $v0 10
	syscall

main_menu:
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)

	li $v0, 4
	la $a0, welcometext
	syscall

	j main_loop

error:
	li $v0, 4
	la $a0, invalidtext
	syscall

main_loop:
	li $v0, 4
	la $a0, menutext
	syscall

	li $v0, 5
	syscall

	add $t0, $zero, $zero

	slti $t0, $v0, 1
	bne $t0, $zero, error

	slti $t0, $v0, 6
	beq $t0, $zero, error

	slti $t0, $v0, 2
	bne $t0, $zero, first

	slti $t0, $v0, 3
	bne $t0, $zero, second

	slti $t0, $v0, 4
	bne $t0, $zero, third

	slti $t0, $v0, 5
	bne $t0, $zero, fourth

	j exit

first:
	jal proc_1
	j main_loop
second:
	jal proc_2
	j main_loop
third:
	jal proc_3
	j main_loop
fourth:
	jal proc_4
	j main_loop
exit:
	li $v0, 4
	la $a0, exittext
	syscall

	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8

	jr $ra


proc_1:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	li $v0, 4
	la $a0, proc_1text
	syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra

proc_2:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	li $v0, 4
	la $a0, proc_2text
	syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra


proc_3:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	li $v0, 4
	la $a0, proc_3text
	syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra


proc_4:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	li $v0, 4
	la $a0, proc_4text
	syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra