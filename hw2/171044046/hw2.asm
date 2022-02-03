.data

arr:			.space 400	# Allocated 400 bytes of space (100 element integer array (MAX_SIZE))
size:			.space 4	#int size : 32 bit = 4 byte = 1 word
num:			.space 4	#int num

printWelcome:		.asciiz "--------- WELCOME ---------\n"
printSize:		.asciiz "Enter the array size : "
printNum:		.asciiz "Enter the target number: "
printInputArray:	.asciiz "Enter array elements: "
printPossible:		.asciiz "\nPossible!\n"
printNotPossible:	.asciiz "\nNot possible!\n"


.text
j main


forLoop:
	li $v0, 5		# Get the user input for array elements
	sll $t1, $t0, 2		# $t1 = i * 4
	add $t2, $s0, $t1	# $t2 = &arr[i]
	syscall
	sw $v0, 0($t2)		# arr[i] = user_input which is $v0
	addi $t0, $t0, 1	# ++i
	slt $t3, $t0, $a1	# $t3 = (i < size)
	bne $t3, $zero, forLoop	# $t3 != 0 ->  forLoop


CheckSumPossibility:
	beq $a2, $zero, Else2
	addi $v0, $zero, 1
	jr $ra

Else2:
	bne $a1, $zero, Else3
	addi $v0, $zero, 0
	jr $ra

Else3:
	addi $sp, $sp, -24	# adjust stack for 6 items
	sw $ra, 20($sp)		# save return adress
	sw $a2, 16($sp)		# save num argument
	sw $a1, 12($sp)		# save size argument
	sw $s0, 8($sp)		# save arr argument (base adress)
	sw $s1, 4($sp)		# temp1
	sw $s2, 0($sp)		# temp2

	sll $t0, $a1, 2		# $t0 = size*4
	add $t1, $t0, $s0	# $t1 = arr + (size*4)
	lw $t2, -4($t1)		# $t2 = arr[size-1]
	slt $t3, $a2, $t2	# if( $a2 < $t2 ) = $t3  (arr[size-1] > num)
	beq $t3, $zero, Else4	# $te==0 ->Else4'e

	# num and arr OK
	# make size = size -1;
	addi $a1, $a1, -1		# size = size-1
	jal CheckSumPossibility		# call recursive function

	lw $a1, 12($sp)		# restore original size
	addi $sp, $sp, 24
	jr $ra


Else4:
	addi $sp, $sp, -24	# adjust stack for 6 items
	sw $ra, 20($sp)		# save return adress
	sw $a2, 16($sp)		# save num argument
	sw $a1, 12($sp)		# save size argument
	sw $s0, 8($sp)		# save arr argument (base adress)
	sw $s1, 4($sp)		# temp1
	sw $s2, 0($sp)		# temp2

	############	Return1	##########
	# num , arr OK
	# make size = size-1
	addi $a1, $a1, -1		# size = size-1;
	jal CheckSumPossibility


	lw $a1, 12($sp)		# restore original size
	lw $ra, 20($sp)		# restore return adress
	add $s1, $zero, $v0	# s1 = CheckSumPossibility(num, arr, size-1)

	############	Return2	##########
	# arr , size-1 OK
	sll $t4, $a1, 2		# $t4 = size*4
	add $t5, $t4, $s0	# $t5 = arr + (size*4)
	lw $a2, -4($t5)		# num = arr[size-1]
	jal CheckSumPossibility

	####	OR	####
	or $v0, $v0, $s1	# $v0 = CheckSumPossibility(num, arr, size-1) || CheckSumPossibility(num-arr[size-1], arr, size-1)
	jr $ra


notPossible:
	la $a0, printNotPossible
	li $v0, 4
	syscall 


main:
	li $v0, 4	# syscall for print_string
	la $a0, printWelcome
	syscall

##########	read data	##########
	la $a0, printSize
	syscall
	li $v0, 5	# Get the user input for array size
	la $a1, size
	syscall		# $v0 now contains read in integer
	move $a1, $v0	# save size

	li $v0, 4
	la $a0, printNum
	syscall
	li $v0, 5	# Get the user input for target num
	la $a2, num
	syscall
	move $a2, $v0	# save num

	li $v0, 4
	la $a0, printInputArray
	syscall

	la $s0, arr

	move $t0, $zero
	jal forLoop		# Call forLoop function


##########	call recursive function    ##########
	jal CheckSumPossibility

	beq $v0, $zero, notPossible
	la $a0, printPossible
	li  $v0, 4
	syscall
