.data
prompt: .asciiz "Input: "
buffer: .space 256
count: .word 0:256 # declare an array of 256 integers to store the frequencies of characters
space:  .asciiz " "
beg: .asciiz ""
mid: .asciiz ""
end: .asciiz ""
generated_end: .asciiz ""  

.text
.globl main

main:
    # display prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # read string input
    li $v0, 8
    la $a0, buffer
    li $a1, 256
    syscall

    # pass string input to print_string procedure
    la $a0, buffer
    jal longestPalindrome
    
    
    # stop program
    li $v0, 10
    syscall

longestPalindrome:
    li $s1, 0      # initialize length counter to 0
    move $s0, $a0        # move argument to callee-saved register
    jal loopStr
    
    addi $t0, $zero, 'a' # initialize loop counter to 'a'
    jal char_loop
    
    # loop to reverse the string
    li $t1, 0              # initialize loop counter to 0
    li $t2, 0              # initialize end string index to 0
    la $t3, beg            # load address of beg string into $t2
    la $t4, end            # load address of end string into $t3
    
    jal loop_beg
    
    jal generate_end
    
    # print the concatenated string
    la $a0, beg            # load beg into $a0
    li $v0, 4              # syscall code for print string
    syscall
    
    la $a0, mid            # load mid into $a0
    li $v0, 4              # syscall code for print string
    syscall
    
    la $a0, generated_end  # load generated_end into $a0
    li $v0, 4              # syscall code for print string
    syscall
                
    jr $ra                 # return


loop_beg:
    lb $t5, ($t3)          # load byte from beg string into $t4
    beqz $t5, end_beg_loop      # if byte is null, exit loop
    
    addi $t1, $t1, 1       # increment loop counter
    addi $t2, $t2, -1      # decrement end string index
    add $t6, $t4, $t2      # calculate address of byte in end string
    sb $t5, ($t6)          # store byte in end string
    
    addi $t3, $t3, 1       # increment beg string pointer
    
    # jump back to start of loop
    j loop_beg
    
end_beg_loop:
    # save the generated end string
    la $t1, generated_end   # load address of generated_end label into $t6
    la $t2, end             # load address of end string into $t7
    li $t3, 0               # initialize loop counter to 0
    jr $ra
    

generate_end:
    lb $t4, ($t2)           # load byte from end string into $t9
    sb $t4, ($t1)           # store byte in generated_end string
    addi $t2, $t2, 1        # increment end string pointer
    addi $t1, $t1, 1        # increment generated_end string pointer
    addi $t3, $t3, 1        # increment loop counter
    bne $t4, $zero, generate_end # if byte is not null, continue loop
  
    jr $ra

loopStr:

    lb $t0, ($s0)    # load current byte of string into $t0
    beqz $t0, endloop  # if byte is null, end loop
    
    li $t1, 65     # load 'A' ASCII code into $t1
    bge $t0, $t1, is_letter   # if $t0 >= $t1, check if it's a letter
    j not_letter    # if $t0 < $t1, it's not a letter
    
    addi $s1, $s1, 1  # increment length counter
    addi $s0, $s0, 1  # increment string pointer
    
    # jump back to the start of the loop
    j loopStr

is_letter:
    li $t2, 122    # load 'z' ASCII code into $t2
    ble $t0, $t2, check_case   # if $t0 <= $t2, it's a letter, check case
    j not_letter    # if $t0 > $t2, it's not a letter

not_letter:
    addi $s1, $s1, 1  # increment length counter
    addi $s0, $s0, 1  # increment string pointer
    # jump back to the start of the loop
    j loopStr

check_case:
    # check if current character is uppercase
    li $t1, 64      # load 64 into $t1
    slt $t2, $t1, $t0      # set $t1 to 1 if $t0 is greater than 64
    slti $t3, $t0, 91     # set $t2 to 1 if $t0  is less than 91
    and $t4, $t2, $t3     # set $t3 to 1 if both $t1 and $t2 are 1
    beq $t4, 1, convert_lower # jump to convert_lower if $t3 equals 1
    
    li $t1, 96
    slt $t2, $t1, $t0      # set $t1 to 1 if $t0 is greater than 96
    slti $t3, $t0, 123     # set $t2 to 1 if $t0 is less than 123
    and $t4, $t2, $t3     # set $t3 to 1 if both $t1 and $t2 are 1
    
    beq $t4, 1, add_to_array  # jump to add_to_array if $t4 equals 1
    
    beq $t4, $zero, not_letter  # branch to "not_letter" if $t3 is 0
   

add_to_array:
    sll $t1, $t0, 2         # multiply the ASCII code by 4 to get the byte offset into the count array
    lw $t2, count($t1)      # load the current count for this character
    addi $t2, $t2, 1        # increment the count
    sw $t2, count($t1)      # store the updated count back into the array
    
    addi $s1, $s1, 1  # increment length counter
    addi $s0, $s0, 1  # increment string pointer
    
    j loopStr
			
convert_lower:
    # convert uppercase to lowercase by adding 32 to ASCII code
    addi $t0, $t0, 32
    j check_case
    
    
char_loop:

    # character in $t0 here
    # load count[ch] into $t4
    add $t3, $zero, $t0
    lbu $t4, count($t3)

    addi $t0, $t0, 1 # increment loop counter
   
    # check if loop counter is still within range
    addi $t1, $zero, 'z'
    slt $t2, $t0, $t1
    
    # check if count[ch] is odd
    andi $t5, $t4, 1
    bne $t5, $zero, is_odd
    
    # count[ch] is even, push n/2 characters to beg string
    # and store rest in end string
    addi $t5, $t0, -1  # calculate n-1 (for even count)
    addi $t6, $zero, 0 # initialize loop counter
    la $t7, beg        # load address of beg string
    
    jal even_loop
    
    bne $t2, $zero, char_loop # repeat loop if counter <= 'z'


is_odd:
    # mid will contain only 1 character
    addi $sp, $sp, -4 # reserve space on stack
    sb $t4, ($sp) # push current character onto stack
    la $t6, mid # load address of mid string
    sb $t4, ($t6) # store current character in mid

    # decrement the character freq to make it even
    addi $t4, $t4, -1 # decrement count[ch]
    sb $t4, count($t3) # store updated count[ch]

    
    jr $ra
    

even_loop:
    # append current character to beg string
    sb $t3, ($t7)
    addi $t6, $t6, 1 # increment loop counter

    # check if we have reached n/2 iterations
    beq $t6, $t5, end_even_loop

    # increment string pointer and continue loop
    addi $t7, $t7, 1
    j even_loop

end_even_loop:
    jr $ra
	

endloop:
    jr $ra
    
