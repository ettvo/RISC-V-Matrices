.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue

	# set up stack pointer
	addi sp, sp, -20
	sw ra, 0(sp)

	# use s0 to store the matrix pointer
	sw s0, 4(sp)

	# use s1 to store the row # between function calls
	sw s1, 8(sp)
	add s1, x0, a1

	# use s2 to store the col # between function calls
	sw s2, 12(sp)
	add s2, x0, a2
	# remember! a1 and a2 are pointers --> must store with sw t0, 0(a1) or smth

	# use s3 to store the file descriptor from fopen across function calls
	sw s3, 16(sp)

	# set t0 to be -1 for error testing
	addi t0, x0, -1

	# set argument parameters for fread
	# a0 already set
	add a1, x0, x0
    
    # ebreak # before fopen

	# open file from a0 with read permissions
	jal ra, fopen
    
    # ebreak # after fopen

	# set t0 to be -1 for error testing
	addi t0, x0, -1
	
	# check for fopen_error & break if detected
	beq a0, t0, fopen_error

	# store file descriptor in s3
	add s3, x0, a0

	# set arguments for fread to read col #
	# a0 already set by fopen
	# set a1 to be the pointer to rows
	add a1, x0, s1
	# set a2 to be 4 (size of int)
	addi a2, x0, 4

	# ebreak # before fread row
    
	# fread row
	jal ra, fread
    
    # ebreak # after fread row

	# check for row error
	addi t0, x0, 4
	bne a0, t0, fread_error


	# set arguments for fread to read row #
	# set a0 to be file descriptor
	add a0, x0, s3
	# set a1 to be the pointer to cols
	add a1, x0, s2
	# set a2 to be 4 (size of int)
	addi a2, x0, 4
    
    # ebreak # before fread col

	# fread col
	jal ra, fread
    
    # ebreak # after fread col

	# check for col error
	addi t0, x0, 4
	bne a0, t0, fread_error

	# calculate size of matrix = (4*col)*row = 4*col*row; store in t0
	addi t0, x0, 4
	lw t1, 0(s1) # row #
	lw t2, 0(s2) # col #
	mul t0, t0, t1
	mul t0, t0, t2

	# store size of matrix in a0 
	add a0, x0, t0

	# ebreak # before malloc
    
	# call malloc
	jal ra, malloc
    
    ebreak # after malloc

	# check malloc_error
	beq a0, x0, malloc_error

	# save the matrix pointer in s0
	add s0, x0, a0


	# already done:
	# a0 set to the pointer matrix

	# todo:
	# set a1 to the row #
	lw a1, 0(s1)
	# set a2 to the col # 
	lw a2, 0(s2)
	# set a3 to the file pointer
	add a3, x0, s3
    
    # ebreak # before read_input

	# read matrix 	
	jal ra, read_input
    
    # ebreak # after read_input

	# Epilogue

	# load arguments for fclose
	add a0, x0, s3
    
    ebreak # before fclose

	# close file
	jal ra, fclose

	ebreak # after fclose 
    
	# check for fclose_error
	addi t0, x0, -1
	beq a0, t0, fclose_error

	# store the pointer to the matrix in a0
	add a0, x0, s0
	
	# restore return register and saved register
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)

	# restore stack pointer
	addi sp, sp, 20

	# return
	ret



read_input:
	# ======
	# inputs:
	#	a0 	the pointer to the matrix
	#	a1	the row #
	#	a2	the col #
	#	a3	the file descriptor for fread
	# outputs:
	#	a0	the pointer to the matrix
	# ======
    
    # ebreak # start of read_input

	# set up registers for storing
	addi sp, sp, -24

	# store current matrix pointer in s0
	sw s0, 0(sp)
	add s0, x0, a0

	# store the file descriptor in s1
	sw s1, 4(sp)
	add s1, x0, a3

	# set up s2 to be total entries counter
	sw s2, 8(sp)
	add s2, x0, x0

	# set up s3 to be total entries limit
	sw s3, 12(sp)
	mul s3, a1, a2

	# save return address in register
	sw ra, 16(sp)

	# store start of matrix pointer in s4
	sw s4, 20(sp)
	add s4, x0, a0

	# ebreak # before read_input_loop
    
	# call read_matrix loop
	j read_input_loop


read_input_loop:
	
    # ebreak # start of read_input_loop

	# perhaps only need row counter
	# exit conditions
	beq s2, s3, read_input_end

	# set arguments for fread to read row #
	# set a0 to be file descriptor
	add a0, x0, s1
	# set a1 to be the pointer to matrix
	add a1, x0, s0
	# set a2 to be 4 (size of int)
	addi a2, x0, 4

	# ebreak # before fread entry
    
	# fread entry
	jal ra, fread
    
    # ebreak # after fread

	# check for entry error
	addi t0, x0, 4
	bne a0, t0, fread_error

	# increase matrix pointer
	addi s0, s0, 4

	# increase entry counter
	addi s2, s2, 1
    
    # ebreak # before read_input_loop restart

	# restart loop
	j read_input_loop




read_input_end:

	# ebreak # start of read_input_end 

	# set a0 to be the matrix pointer
	add a0, x0, s4

	# restore registers
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw ra, 16(sp)
	lw s4, 20(sp)

	# restore stack pointer
	addi sp, sp, 24
    
    # ebreak # end of read_input_end
    # went to malloc_error; doesn't return back
    # j ra
    ret



malloc_error:
	li a0 26
	j exit

fopen_error:
	li a0 27
	j exit

fclose_error:
	li a0 28
	j exit

fread_error:
	li a0 29
	j exit
