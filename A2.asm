#####################################################################
#                                                                   #
# Name: Aycan Deniz Vit                                             #
# KUSIS ID: 		                                            #
#####################################################################

# This file serves as a template for creating 
# your MIPS assembly code for assignment 2

.eqv MAX_LEN_BYTES 400
.eqv CMD_LEN	   3
#====================================================================
# Variable definitions
#====================================================================

.data
input_data:        .space     MAX_LEN_BYTES     #Define length of input list
reducted_list:     .space	  MAX_LEN_BYTES
msg:               .asciiz    "CORRECT COMMAND...Indicate Array Size:"
right_bracket:	   .asciiz    "[ "
left_bracket:	   .asciiz    "]\n"
blank: 	           .asciiz    " "
cmd:	           .asciiz    "-n"		           # string variable to validate input command
cmd_input:	   .space     CMD_LEN	           # cmd input

arg_err_msg:       .asciiz   "Argument error"
input_msg:         .asciiz   "Input integers"
sorted_msg:	   .asciiz   "Sorted List\n"
sorted_wo_d_msg:   .asciiz   "Sorted List without Duplicates\n"
list_sum_msg:	   .asciiz   "List Sum\n"
enter_int_msg:     .asciiz   "Enter Integers:\n"
dimErr_msg:        .asciiz   "Dimension cannot be larger than 100. Type again:\n"
fnshd:             .asciiz   "\nProgram Finished"


#  You can define other data as per your need. 


#==================================================================== 
# Program start
#====================================================================

.text
.globl main

main:
   # Check for command line arguments count and validity
    j Get_Argument				# jump to get "-n 6" argument
	o.k.:						# after getting the argument, return to the main function.
	jal Data_Input
	jal sort_data
	jal print_w_dup
	jal remove_duplicates
	j print_wo_dup
	


   # Check for first argument to be n
Get_Argument:
	li $v0, 8				# to get user's text input
	la $a0, cmd_input
	li $a1, CMD_LEN			# to limit input size to 3 bytes including "\0"
	syscall
	
	addi $t1, $zero, 0		# i = 0. to be used for selecting input's elements
	
	loop:
	lb $t3, cmd_input($t1)		# input's i th element
	lb $t4, cmd($t1)			# "-n" string's i th element. to be compared with input for verification
	bne $t3, $t4, Arg_Err		# jump to Argument Error if they are not equal
	addi $t1, $t1, 1
	beq $t1, 2, endLoop			# i = 2, exit loop. (First two bytes of the string is taken into account)
	j loop						#if i != 2, loop again.
	
	endLoop:
	li $v0, 4
	la $a0, msg					# Display "CORRECT ARGUMENT"
	syscall

	addi $t1, $zero, MAX_LEN_BYTES	# i = 400
	srl $t1, $t1, 2				# i = 100
	enterSize:
		li $v0, 5				# input integer
		syscall		
		move $s0, $v0
		blt $t1, $s0, dimErr	# if input is not less than 100, go to Error
		j o.k.					# return to main.
		dimErr:					# Error message shows up.
			li $v0, 4
			la $a0, dimErr_msg
			syscall
	j enterSize					# if dimension is not correct, ask it again.


Data_Input:
   # Get integers from user as per value of n
   
   ##################  YOUR CODE  ####################   
   	addi $sp, $sp, -8
   	sw $s0, 0($sp)		# Array Size can be accessed by using $sp. After function is done, $s0 is going to have its last value before $sp call.
   	sw $s1, 4($sp)		# Counter for array size 
   	mul $s0, $s0, 4		# One Integer value occupies 4 Bytes memory.
	addi $s1, $zero, 0	# Counter for elements of array (to be incremented by 4 for each cycle)

	
	li $v0, 4
	la $a0, enter_int_msg
	syscall
    loopInput:	   
   		li $v0, 5					# input integer
   		syscall
   		move $t6, $v0
   		sw $t6, input_data($s1)		# ask for an integer for the i th element of array
   		addi $s1, $s1, 4			# i = i + 1
   		bne $s0, $s1, loopInput	
   
    lw $s0, 0($sp)		# Array Size
    lw $s1, 4($sp)		# Counter for array size 
    addi $sp, $sp, 8
    jr $ra

sort_data:

	addi $sp, $sp, -28
	sw $s0,  ($sp)	# Array size
	sw $s1, 4($sp)	# counter1 (i)
	sw $s2, 8($sp)	# counter2	(j)
	sw $s3,12($sp)  # Key for insertion sort algorithm
	sw $s4,16($sp)	# counter2 + 1	(j+1)
	sw $s6,20($sp)
	sw $s7,24($sp)
	
	sll $s0, $s0, 2
	addi $s1, $zero, 4	# i = 1
	for1:						# sweep all elements of input_data by i = i + 1
		lw $s3, input_data($s1)	# key
		addi $s2, $s1, -4	# j = i - 1
		for2:
			sgt $s7, $s2, -4		# if j>-1 set $s7 to 1
			lw $s4, input_data($s2)	# arr[j]
			sgt $s6, $s4, $s3	 	# if arr[j] > arr[i], set $s6 to 1
			beqz $s7, exit2			# if j<0, go to exit2
			beqz $s6, exit2			# if arr[j] <= arr[i] go to exit2
			
			addi $s2, $s2, 4		# Inside of second loop. j = j + 1
			sw $s4, input_data($s2)	# arr[j+1]
			addi $s2, $s2, -8		# j = j-1
		j for2						# jump inside loop
		exit2:
		addi $s2, $s2, 4			
		sw $s3, input_data($s2)		# swap of the elements of the array occurs here.
		addi $s2, $s2, -4			
		addi $s1, $s1, 4			# i = i + 1, it is for "for1"			
		blt $s1, $s0, for1
		
		addi $s0, $zero, 0	
	
	lw $s0,  ($sp)					# restoring the variables back to stack.
	lw $s1, 4($sp)	
	lw $s2, 8($sp)	
	lw $s3,12($sp)  
	lw $s4,16($sp)
	lw $s6,20($sp)
	lw $s7,24($sp)
	addi $sp, $sp, 28
	jr $ra
	
remove_duplicates:
   
   ##################  YOUR CODE  ####################

# Print sorted list with and without duplicates
	addi $sp, $sp, -28
	sw $s0,  ($sp)	# Array size
	sw $s1, 4($sp)	# counter1 (i)
	sw $s2, 8($sp)	# counter2	(j)
	sw $s3,12($sp)  # Key for insertion sort algorithm
	sw $s4,16($sp)	# counter2 + 1	(j+1)
	sw $s6,20($sp)
	sw $s7,24($sp)

	
	sll $s0, $s0, 2
	addi $s1, $zero, 0	# i = 1
	addi $s2, $zero, 0	# counter of new array = 0
	
	
	lw $s4, input_data($s1)
	sw $s4, reducted_list($s2)	# new array without duplicates
	add $t3, $zero, $s4
	for:
		beq $s1, $s0, exit
		addi $s1, $s1, 4	# i++
		addi $s3, $s1, -4	# j = i - 1
		lw $s5, input_data($s1)
		lw $s6, input_data($s3)
		beq $s5, $s6, false			# if consecutive elements are equal, jump to false
		addi $s2, $s2, 4			# increment counter by 1
		lw $s7, input_data($s1)
		sw $s7, reducted_list($s2)	# new array without duplicates
		add $t3, $t3, $s7			# SUM OF THE ELEMENTS OF ARRAY IS HERE. In every loop,
		false:						# when numbers stored in reducted_list, sum = sum + arr[i]
		j for
	exit:
	
	move $t2, $s2
	
	lw $s0,  ($sp)	
	lw $s1, 4($sp)	
	lw $s2, 8($sp)	
	lw $s3,12($sp)  
	lw $s4,16($sp)
	lw $s6,20($sp)
	lw $s7,24($sp)
	addi $sp, $sp, 28
	jr $ra
print_w_dup:

   ##################  YOUR CODE  ####################
   	addi $sp $sp, -8
   	sw $s0, ($sp)
   	sw $s7, 4($sp)
   	
   	addi $s7, $zero, 0
	sll $s0, $s0, 2
 	 	
 	li $v0, 4				# displaying header
 	la $a0, sorted_msg
 	syscall
 	
 	li $v0, 4
 	la $a0, right_bracket	# insert bracket
 	syscall
   	
   	while_dup:
   		li $v0, 1
   		lw $a0, input_data($s7)		# displaying first sorted array
   		syscall						# with duplicates
   		li $v0, 4
 		la $a0, blank				# inserting a blank between elements of the array
 		syscall
   		addi $s7, $s7, 4
   		bne $s7, $s0, while_dup		# return back to loop
	
	li $v0, 4
 	la $a0, left_bracket	# insert bracket
 	syscall
   	
   	lw $s0, ($sp)
   	lw $s7, 4($sp)  
   	addi $sp, $sp, 8
   	
   	jr $ra	
print_wo_dup:

   ##################  YOUR CODE  ####################

# Perform reduction
   	addi $s7, $zero, 0
   	
 	li $v0, 4
 	la $a0, sorted_wo_d_msg				# displaying header
 	syscall
 	
 	li $v0, 4
 	la $a0, right_bracket				# insert bracket
 	syscall
   	
   	while_wo_dup:
   		li $v0, 1
   		lw $a0, reducted_list($s7)		# new array without duplicates
   		syscall
   		li $v0, 4
 		la $a0, blank					# inserting a blank between elements of the array
 		syscall
   		addi $s7, $s7, 4
   		bne $s7, $t2, while_wo_dup		# return back to loop
	
	li $v0, 4
 	la $a0, left_bracket				# insert bracket
 	syscall
 	li $v0, 4
 	la $a0, list_sum_msg
 	syscall
   ##################  YOUR CODE  ####################

#print_sum:
   li  $v0, 1
   addi $a0, $t3, 0      # $t3 contains the sum  
   syscall
   li $v0, 4
   la $a0, fnshd
   syscall

   j Exit 
   
Arg_Err:
   # Error message when no input arguments specified
   # or when argument format is not valid
    la $a0, arg_err_msg
    li $v0, 4
    syscall
    j Exit

Exit:   
   # Jump to this label at the end of the program
    li $v0, 10
    syscall
