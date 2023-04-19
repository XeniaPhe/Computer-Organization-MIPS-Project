# Declare memory locations for input variables
    .data
prompt_rows: .asciiz "Enter the number of rows: "
prompt_cols: .asciiz "Enter the number of columns: "
prompt_matrix: .asciiz "Enter the elements of the matrix: "
result_msg: .asciiz "The lucky number is: "
    .align 2
input_rows: .space 100
input_cols: .space 100
input_matrix: .space 1000

    .text
    .globl main

main:
    # Prompt user for number of rows and store input in memory
    li $v0, 4
    la $a0, prompt_rows
    syscall
    li $v0, 5
    syscall
    sw $v0, input_rows
    
    # Prompt user for number of columns and store input in memory
    li $v0, 4
    la $a0, prompt_cols
    syscall
    li $v0, 5
    syscall
    sw $v0, input_cols
    
    # Prompt user for matrix elements and store input in memory
    li $v0, 4
    la $a0, prompt_matrix
    syscall
    
    # Read matrix elements from user input and store in memory
    la $t0, input_matrix
    li $t1, 0
input_loop:
    beq $t1, 100, input_done
    li $v0, 5
    syscall
    sw $v0, ($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    j input_loop
input_done:
    
    # Load input parameters into registers
    lw $a0, input_rows
    lw $a1, input_cols
    la $a2, input_matrix
    
    # Allocate space on the stack for the result
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Call find_lucky_number with the input parameters and store the result in $t0
    jal find_lucky_number
    move $t0, $v0
    
    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    
    # Clean up the stack and exit the program
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0, 10
    syscall

find_lucky_number:
    # Load input parameters into registers
    lw $t0, 0($a0)    # Load number of rows into $t0
    lw $t1, 0($a1)    # Load number of columns into $t1
    move $t2, $a2     # Load address of matrix into $t2

    # Check each row for a lucky number
    li $t3, 0         # Initialize row counter to 0
row_loop:
    beq $t3, $t0, not_found    # If all rows have been checked, exit with not found
    li $t4, 2147483647        # Initialize min value for current row to max int value
    li $t5, -2147483648       # Initialize max value for current column to min int value
    li $t6, 0                 # Initialize column counter to 0
col_loop:
    beq $t6, $t1, check_lucky  # If all columns in current row have been checked, proceed to check for lucky number
    lw $t7, ($t2)              # Load current matrix element into $t7
    blt $t7, $t4, update_min   # If current element is less than current min, update min
    bge $t7, $t5, update_max   # If current element is greater than or equal to current max, update max
    addi $t2, $t2, 4           # Otherwise, move to next column
    addi $t6, $t6, 1           # and increment column counter
    j col_loop
update_min:
    move $t4, $t7              # Set current min to current element
    addi $t2, $t2, 4           # Move to next column
    addi $t6, $t6, 1           # and increment column counter
    j col_loop
update_max:
    move $t5, $t7              # Set current max to current element
    addi $t2, $t2, 4           # Move to next column
    addi $t6, $t6, 1           # and increment column counter
    j col_loop
check_lucky:
    ble $t4, $t5, not_lucky    # If current min is less than or equal to current max, current row is not lucky
    sll $t4, $t3, 2      # Shift $t3 left by 2 bits (equivalent to multiplying by 4)
    mult $t4, $t1        # Multiply $t4 by $t1, storing the result in HI:LO
    mflo $t5             # Move the result from LO to $t5
    add $t2, $a2, $t5    # Add $t5 to $a2 and store the result in $t2
    li $t6, 0                  # Reset column counter to 0
col_loop2:
    beq $t6, $t0, found_lucky  # If all rows in current column have been checked, current row is lucky
    lw $t7, ($t2)              # Load current matrix element into $t7
    bge $t7, $t4, not_lucky    # If current element is greater than or equal to current min, current row is not lucky
    sll $t3, $t3, 2   # multiply $t3 by 4 (shift left by 2 bits)
    mul $t3, $t3, $t1 # multiply the result with $t1
    add $t2, $a2, $t3 # add the result to $a2 and store in $t2
    addi $t6, $t6, 1           # and increment row counter
    j col_loop2
not_lucky:
    mul $t4, $t1, $t3   # multiply t1 and t3 and store the result in t4
    sll $t4, $t4, 2     # shift t4 left by 2 (multiply by 4) 
    add $t2, $a2, $t4   # add the result of the multiplication to a2 and store in t2
    addi $t3, $t3, 1           # Increment row counter
    j row_loop
found_lucky:
    # Lucky number found, return it
    move $v0, $t4 # Set return value to current min
    jr $ra # Return to calling function
not_found:
    # Lucky number not found, return -1
    li $v0, -1 # Set return value to -1
    jr $ra # Return to calling function