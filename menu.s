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
#save the callee saved registers used in this procedure to the stack, (eventhough they're not used in main procedure)
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)

#print the welcome text before entering the main menu loop
	li $v0, 4
	la $a0, welcometext
	syscall

	j main_loop

#print error message and go back to main menu loop
error:
	li $v0, 4
	la $a0, invalidtext
	syscall

main_loop:
#print the menu
	li $v0, 4
	la $a0, menutext
	syscall

#take integer input from the user
	li $v0, 5
	syscall

	add $t0, $zero, $zero

#print error message if the input is less than 1
	slti $t0, $v0, 1
	bne $t0, $zero, error

#print error message if the input is greater than 5
	slti $t0, $v0, 6
	beq $t0, $zero, error

#input == 1
	slti $t0, $v0, 2
	bne $t0, $zero, first

#input == 2
	slti $t0, $v0, 3
	bne $t0, $zero, second

#input == 3
	slti $t0, $v0, 4
	bne $t0, $zero, third

#input == 4
	slti $t0, $v0, 5
	bne $t0, $zero, fourth

#input == 5
	j exit

#We either had to handle the $ra register manually using the bne instructions not to branch here but to the 
#individual procedures directly, or create 4 new labels for each procedure and use the jal instruction and we went with the simpler one which is the latter
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

#restore the values of the callee saved registers from the stack
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