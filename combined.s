.data
	welcometext:	.asciiz "Welcome to our MIPS project!\n"
	menutext:		.asciiz "Main Menu:\n1.Find Palindrome\n2.Reverse Vowels\n3.Find Distinct Prime\n4.Lucky Number\n5.Exit\nPlease select an option: "
	invalidtext:	.asciiz "Invalid Input!\n"
	exittext:		.asciiz "Program ends. Bye :)\n"
	proc_1text:		.asciiz "Find Palindrome\n"
	proc_3text:		.asciiz "Find Distinct Prime\n"
	proc_4text:		.asciiz "Lucky Number\n"

#Reverse Vowels
	input_msg:		.asciiz "Input: "
	output_msg:		.asciiz "Output: "
	vowels:			.asciiz "eaoiu"
	buffer_size:	.word 256

#Square-free Number
        input_prompt: 		      .asciiz "Enter an integer greater than 1: "
        output_not_square_free:      .asciiz " is not square-free number\n"  
        output_square_free_message:  .asciiz " is a square-free number and has " 
        output_square_free_message2: .asciiz " distinct prime factors: "
        seperator: 		      .asciiz " "  # Separator for outputting prime factors
        input_error_message: 	      .asciiz "Your input must be greater than 1.\n"
        new_line:		      .asciiz "\n"

.text
	.globl main_menu
	.globl proc_1
	.globl proc_4

#Reverse Vowels
	.globl reverse_vowels
	.globl read_string
	.globl is_vowel

#Square free
        .globl square_free
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
	jal reverse_vowels
	j main_loop
third:
	jal square_free
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
	
proc_4:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	li $v0, 4
	la $a0, proc_4text
	syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra


square_free:
	li $v0, 4  #Enter an integer message
	la $a0, input_prompt
	syscall
    
	li $v0, 5
	syscall
	move $s0, $v0   # Save input number in $s0
	move $s1, $v0   # Save input number in $s1
    
    
	#Error if input is lower than 2
	li $t0, 2
	blt $s0, $t0, error_for_wrong_input
    
	#Initialize counter for prime factors. How many times the same prime number used
	li $t0, 0
    
	#Initialize counter for how many prime counter used
	li $t3, 0 
    
	#Find prime factors of input number
	li $t1, 2   # Start with smallest prime number, 2
    
	j find_prime_factors
    
find_prime_factors:
	div $s1, $t1  # divide the input by current prime
	mfhi $t2      # store reminder to t2
	bnez  $t2,  increment_prime_number # if t2 is not zero that means we have to try with another prime
	mflo $s1  # store divided to s1
	addi $t3, $t3, 1 # add distinct prime counter 1
	addi $t0, $t0 , 1 # add prime counter 1
	li $t7, 1 
	bgt $t0, $t7, is_not_square_free # if prime counter 2, that means same prime number used more than one
	beq $s1, $t7, is_square_free # if modified input is 1, that means number has distinct prime factors
	j find_prime_factors #  continue loop
    
find_prime_for_print:
    
	div $s0, $t1 # divide the input by current prime
	mfhi $t2
	bnez  $t2,  increment_prime_number_for_print # if t2 is not zero that means we have to try with another prime
	mflo $s0
    
	move $a0, $t1 # print prime factor
	li $v0, 1
	syscall
    
	li $v0, 4
	la $a0, seperator # print first square free message
	syscall
    
	li $t7, 1
	beq $s0, $t7, exit_square_free # if the modified input is 1, that means we printed every prime factor
	j find_prime_for_print
    
is_square_free:
	move $a0, $s0  # print input
	li $v0, 1 
	syscall
    
	li $v0, 4
	la $a0, output_square_free_message #print first square free message
	syscall
    
	move $a0, $t3  # print how many prime factor
	li $v0, 1
	syscall
    
	li $v0, 4
	la $a0, output_square_free_message2 # print second square free message
	syscall
    
	li $t1 , 2  # set t1 to 2 again. Smallest prime
    
	j find_prime_for_print
    
is_not_square_free:
	move $a0, $s0  # print is not square free message
	li $v0, 1
	syscall
    
	li $v0, 4
	la $a0, output_not_square_free
	syscall
    
	jr $ra
    
increment_prime_number:
	addi $t1, $t1 , 1 # increment prime
	li $t0, 0 # set prime counter to 0
	j find_prime_factors
    
increment_prime_number_for_print:
	addi $t1, $t1 , 1 # increment prime
	j find_prime_for_print
      
error_for_wrong_input:
	li $v0 , 4
	la $a0, input_error_message
	syscall
    
	jr $ra
            
exit_square_free:
	li $v0, 4
	la $a0, new_line
	syscall
	jr $ra

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
	addi $sp, $sp, 12

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
