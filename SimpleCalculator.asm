.data
    myTip1:.asciiz "Choose binary or decimal calculator: \n(Enter 2(binary) or 10(decimal))\n"
    myTip2:.asciiz "Enter first number: "
    myTip3:.asciiz "Enter second number: "
    myTip4:.asciiz "Enter your operation (+, -, *, /): "
    myTip5:.asciiz "Please choose the operation sign:\n    1:'+'\n    2:'-'\n    3:'*'\n    4:'/'\nPlease Enter the number'1,2,3,4'\n"
    myTip6:.asciiz "Enter first binary number: "
    myTip7:.asciiz "Enter second binary number: "
    
    errorTip1:.asciiz "Please reselect calculator (Press 2 or 10)\nOr enter '666' to exit the program"
    errorTip2:.asciiz "Please choose again or enter '666' to exit the program\n"
    errorTip3:.asciiz "Denominator is 0!\n"
    errorTip4:.asciiz "Wrong Input"
    errorTip5:.asciiz "Overflow!\n"
    
    yourChoice1:.asciiz "You choose the binary calculator.\n"
    yourChoice2:.asciiz "You choose the decimal calculator.\n"
    
    result:.asciiz "\nThe final Result is: \n"
    decresult:.asciiz "The result of decimal is: \n"
    
    # Binary number buffer
    binbuf:.space 33
    
.text
  main:
    # Print the tip1 to let user choose the 
    li $v0, 4
    la $a0, myTip1
    syscall
    
    # Set the $f28 as +Infinity and $30 as -Infinity
    li $t0, 0x7f800000
    mtc1 $t0, $f28
    li $t0, 0xff800000
    mtc1 $t0, $f30
    
  chooseCalculator:
    # chooseCalculator
    # To get the user input
    li $v0, 5
    syscall
    
    # To check the user's input and decide the flow
    beq $v0, 2, L1
    beq $v0, 10, L2
    beq $v0, 666, Exit
    
    # If the user input the other number, print the error and let user enter again
    li $v0, 4 
    la $a0, errorTip1
    syscall
    
    j main
    
  L1:
    # Print the choice of the user
    li $v0, 4
    la $a0, yourChoice1
    syscall
    
    # Print the tip to let user input the first data
    li $v0, 4
    la $a0, myTip6
    syscall
    
    # Jump to the function to transfer first binary number to decimal number and store in $t2
    jal two2ten
    move $t0, $a0
    
    # Test function to check if the number is stored in $t0 or not
    #move $a0, $t0
    #li $v0, 1
    #syscall
     
    # Print the tip to let user input the second data
    li $v0, 4
    la $a0, myTip7
    syscall
    
    # Jump to the function to transfer binary number to decimal number and store in $t2
    jal two2ten
    move $t2, $a0
    
    # Test function to check if the number is stored in $t2 or not
    #move $a0, $t2
    #li $v0, 1
    #syscall
    
    # Print the tip5 to let user choose the operation type
    li $v0, 4
    la $a0, myTip5
    syscall
    
  selectintOperation:
    # To get the user input
    li $v0, 5
    syscall
    
    # To compare the input operation sign
    beq $v0, 1, plusint
    beq $v0, 2, subtractionint
    beq $v0, 3, multipleint
    beq $v0, 4, divisionint
    beq $v0, 666, Exit
    
    # If the user input the other number, print the error and let user enter again
    li $v0, 4 
    la $a0, errorTip2
    syscall
    
    j selectintOperation
    # Code forfloat number
    
    j Exit
    
    
  L2:
    # Print the choice of the user
    li $v0, 4
    la $a0, yourChoice2
    syscall
    
    # To get the first input from the user
    # Print myTip2 first
    li $v0, 4
    la $a0, myTip2
    syscall
    
    # System has to read the users data (input)
    # The first number would be saved in $f4
    li $v0, 6 
    syscall
    mov.s $f4, $f0
    
    # Test Function
    # Print the read float
    #mov.s $f12, $f4
    #li $v0, 2
    #syscall
    
    # To get the second input from the user
    # Print myTip2 first
    li $v0, 4
    la $a0, myTip3
    syscall
    
    # Test Function
    # System has to read the users data (input)
    # The second number would be saved in $f6
    li $v0, 6 
    syscall
    mov.s $f6, $f0
    
    # Test Function
    #print the read float
    #mov.s $f12, $f6
    #li $v0, 2
    #syscall
    
    # Print the tip to let user input the operation sign
    #li $v0, 4
    #la $a0, myTip4
    #syscall
    
  chooseOperation:
    # chooseOperation
    # Load operation sign into registers
    #li $t1, '+'
    #li $t2, '-'
    #lw $t3, multi
    #lw $t4, divi
    
    # Print the tip5 to let user choose the operation type
    li $v0, 4
    la $a0, myTip5
    syscall
    
  selectOperation:
    # chooseOperation
    # To get the user input
    li $v0, 5
    syscall
    
    # To compare the input operation sign
    beq $v0, 1, plus
    beq $v0, 2, subtraction
    beq $v0, 3, multiple
    beq $v0, 4, division
    beq $v0, 666, Exit
    
    # If the user input the other number, print the error and let user enter again
    li $v0, 4 
    la $a0, errorTip2
    syscall
    
    j selectOperation
    # Code for float number
    
  plus:
    # The operation of add
    # Print the tips of here is the result
    li $v0, 4
    la $a0, result
    syscall
    
    # Here is the $f12 = $f4 + $f6
    add.s $f12, $f4, $f6
    
    # Another Thought: use add.s to substitude move but use 0.0 failed
    # add.s $f12, $f8, 0.0
    
    # To check if the result is overflow
    c.eq.s $f12, $f28
    bc1t overFlow
    c.eq.s $f12, $f30
    bc1t overFlow
    
    li $v0, 2
    syscall
    
    j Exit
    
  subtraction:
    # The operation of subtraction
    # Print the tips of here is the result
    li $v0, 4
    la $a0, result
    syscall
    
    # Here is the $f12 = $f4 - $f6
    sub.s $f12, $f4, $f6
    
    # To check if the result is overflow
    c.eq.s $f12, $f28
    bc1t overFlow
    c.eq.s $f12, $f30
    bc1t overFlow
    
    li $v0, 2
    syscall
    
    j Exit
    
  multiple:
    # The operation of multiplication
    # Print the tips of here is the result
    li $v0, 4
    la $a0, result
    syscall
    
    # Here is the $f12 = $f4 * $f6
    mul.s $f12, $f4, $f6
    
    # To check if the result is overflow
    c.eq.s $f12, $f28
    bc1t overFlow
    c.eq.s $f12, $f30
    bc1t overFlow
    
    li $v0, 2
    syscall
    
    j Exit
    
  division:
    # The operation of subtraction
    # Print the tips of here is the result
    li $v0, 4
    la $a0, result
    syscall
    
    # Here is the $f12 = $f4 / $f6
    div.s $f12, $f4, $f6
    
    # To check if the result is overflow
    c.eq.s $f12, $f28
    bc1t overFlow
    c.eq.s $f12, $f30
    bc1t overFlow
    
    li $v0, 2
    syscall
    
    j Exit
    
#Code for integer
  plusint:
    # The operation of add
    # Print the tips of here is the decimal result
    li $v0, 4
    la $a0, decresult
    syscall
    
    # Here is the $a0 = $t0 + $t2
    add $a0, $t0, $t2
    # Store the final result for transfer
    
    # To check if overflow happens
    jal binCheck
    
    # Print the decimal result
    li $v0, 1
    syscall
    
    move $t0, $a0
    
    # Print the tips of here is the binary result
    li $v0, 4
    la $a0, result
    syscall
    
    # Transfer the decimal number to binary number
    j dec2bin
    
  subtractionint:
    # The operation of subtraction
    # Print the tips of here is the decimal result
    li $v0, 4
    la $a0, decresult
    syscall
    
    # Here is the $a0 = $t0 - $t2
    sub $a0, $t0, $t2
    
    # To check if the operation is overflow
    jal binSubCheck
    
    # Print the decimal result
    li $v0, 1
    syscall
    
    # Store the final result for transfer
    move $t0, $a0
    
    # Print the tips of here is the binary result
    li $v0, 4
    la $a0, result
    syscall
    
    # Transfer the decimal number to binary number
    j dec2bin
    
  multipleint:
    # The operation of subtraction
    # Print the tips of here is the decimal result
    li $v0, 4
    la $a0, decresult
    syscall
    
    # Here is the $a0 = $t0 * $t2
    mul $a0, $t0, $t2
    
    # To check if overflow happens
    jal binCheck
    
    # Print the decimal result
    li $v0, 1
    syscall
    
    # Store the final result for transfer
    move $t0, $a0
    
    # Print the tips of here is the binary result
    li $v0, 4
    la $a0, result
    syscall
    
    # Transfer the decimal number to binary number
    j dec2bin
    
  divisionint:
    # The operation of subtraction
    # Print the tips of here is the decimal result
    li $v0, 4
    la $a0, decresult
    syscall
    
    jal binDivCheck2
    
    # Here is the $a0 = $t0 / $t2
    div $a0, $t0, $t2
    
    # To check if overflow happens
    jal binCheck
    
    #Print the decimal result
    li $v0, 1
    syscall
    
    # Store the final result for transfer
    move $t0, $a0
    
    # Print the tips of here is the binary result
    li $v0, 4
    la $a0, result
    syscall
    
    # Transfer the decimal number to binary number
    j dec2bin
    
  two2ten:
  # This code used to transfer binary numbers to decimal numbers
    li $v0,8
    la $a0,binbuf
    li $a1,33
    syscall
	
    li $a0,0x0a # 0x0a = 10 ,means '\n'
    li $v0,11
    syscall
	
    li $t1,0x0a
    li $t4,0x30	# 0x30 is '0'
    li $t5,0x31	# 0x31 is '1'
    la $t3,binbuf
    move $a0,$0
	
  redo:
    lb $t2,0($t3)
    
    # If $t2 = '\n' or space ,means the end of the string
    beq $t2,0x0a,finish
    beq $t2,$0,finish
    
    # If $t2 <'0' or > '1' ,the input is invalid
    blt $t2,$t4,err 
    bgt $t2,$t5,err
    
    # Transfer the char to int 
    addi $t2,$t2,-0x30
    sll $a0,$a0,1 # $a0 << 1
    add $a0,$a0,$t2
    addi $t3,$t3,1 # Binbuf pointer + 1
    j redo
	
  err:
    # If there are error print the errorTip and Exit
    la $a0,errorTip4
    li $v0,4
    syscall
    
    j Exit
	
  finish:
    # Go back for further operation
    jr $ra 

# This function mainly transfer the final result from decimal to binary	
  dec2bin:
    blt $t1, 0, Exit
    srlv $t2, $t0, $t1 # Shift the bit to right most position
    and $t2, 1 # Extract the bit by ANDING 1 with it
    
    # Display the extracted bit
    li $v0, 1
    move $a0, $t2
    syscall
    
    #Decrement the bit no.
    sub $t1, $t1, 1
    b dec2bin
    
  overFlow:
    # Print the error code of overflow
    li $v0, 4
    la $a0, errorTip5
    syscall
    j Exit
    
  binCheck:
    # To check if the add operation is negative, if is then overflow
    slti $t7, $a0, 0
    beq $t7, 1, overFlow
    
    j goBack
    
  binSubCheck:
    # Check if $t2 >$t0, if mot then overflow
    slti $t7, $a0, 0
    beq $t7, 0, goBack
    
    slt $t6, $t0, $t2
    beq $t6, 1, overFlow
    
    j goBack
    
  binDivCheck2:
    # Check if the denominator is zero 0, if then overflow
    beq $t2, 0, overFlow
    
    j goBack
  
  goBack:
    # If the situations do not meet, then go back to function
    jr $ra
  
    # Deno0:
    # Print the error code of the denominator is 0
    # This code can be substitude by the overFlow 
      #li $v0, 4
      #la $a0, errorTip3
      #syscall
      #j Exit
	
  Exit:
    # To exit the program
    li	$v0, 10
    syscall
    
    
