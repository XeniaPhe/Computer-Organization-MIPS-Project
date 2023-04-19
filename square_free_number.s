# Talha SEZER 
# Mehmet Fatih Erdem
# Mustafa Tunahan Baş
# Sadık Akgedik

# In this question, our goal is to find if the input number is a square-free number or not.

# Data Section
.data
input_prompt: .asciiz "Enter an integer grater than 1: "
output_not_square_free: .asciiz " is not square-free number"  
output_square_free_message: .asciiz " is a square-free number and has " 
output_square_free_message2: .asciiz " distinct prime factors: "
seperator: .asciiz " "  # Separator for outputting prime factors
input_error_message: .asciiz "Your input must be greater than 1."

# Text Section
.text
.globl main

# Main function
main:
    li $v0, 4  #Enter an integer message
    la $a0, input_prompt
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0   # Save input number in $s0
    move $s1, $v0   # Save input number in $s1
    
    
    # Error if input is lower than 2
    li $t0, 2
    blt $s0, $t0, error_for_wrong_input
    
    # Initialize counter for prime factors. How many times the same prime number used
    li $t0, 0
    
    # Initialize counter for how many prime counter used
    li $t3, 0 
    
    # Find prime factors of input number
    li $t1, 2   # Start with smallest prime number, 2
    
    jal find_prime_factors
    
    li $v0, 10 # Finish the program
    syscall

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
    beq $s0, $t7, exit # if the modified input is 1, that means we printed every prime factor
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
    
    li $v0, 10   # terminate program
    syscall
    
    
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
    
    li $v0, 10
    syscall
            
exit:
    li $v0, 10
    syscall
