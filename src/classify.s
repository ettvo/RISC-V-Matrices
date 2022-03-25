.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

	# check for command line args #
	addi t0, x0, 5
	bne a0, t0, incorrect_args

	# set up saved registers
	addi sp, sp, -36

	# set s0 be the command line args a1
	# values:
	# 	m0 at 4(s0)
	#	m1 at 8(s0)
	# 	input at 12(s0)
	# 	output at 16(s0)
	sw s0, 0(sp)
	add s0, x0, a1

	# set s1 to be a2 (silent mode)
	sw s1, 4(sp)
	add s1, x0, a2

	# set s2 to be the row # pointer
	sw s2, 8(sp)

	# set s3 to be the col # pointer
	sw s3, 12(sp)

	# set s4 to be the pointer for matrix output H 
	sw s4, 16(sp)

	# set s5 to hold the dimensions for matrices m0, m1, input
	# dimensions of m0, m1, input in s5
	# 	matrix	|   row	 |   col  |
	#	  m0	|  0(s5) |  4(s5) |
	#	  m1	|  8(s5) | 12(s5) |
	#	 input	| 16(s5) | 20(s5) |
	sw s5, 20(sp)

	# set s6 to be pointer for matrix output O
	sw s6, 24(sp)

	# set s7 to be the return value from argmax(o)
	sw s7, 28(sp)

	# store ra
	sw ra, 32(sp)

	# malloc space for row pointer
	addi a0, x0, 4
	jal ra, malloc
	
	# check for malloc error
	beq a0, x0, malloc_error

	# store row pointer in s2
	add s2, x0, a0

	# malloc space for col pointer
	addi a0, x0, 4
	jal ra, malloc
	
	# check for malloc error
	beq a0, x0, malloc_error

	# store col pointer in s3
	add s3, x0, a0

	# malloc space for dimensions of m0, m1, input in s5
	# 	matrix	|   row	 |   col  |
	#	  m0	|  0(s5) |  4(s5) |
	#	  m1	|  8(s5) | 12(s5) |
	#	 input	| 16(s5) | 20(s5) |
	addi a0, x0, 24
	jal ra, malloc

	# check for malloc error
	beq a0, x0, malloc_error

	# store dimensions pointer in s5
	add s5, x0, a0

	# Read pretrained m0, store in 4(s0)
	lw a0, 4(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 4(s0)

	# store dimensions for m0 in s5
	lw t0, 0(s2) # row #
	lw t1, 0(s3) # col #
	sw t0, 0(s5)
	sw t1, 4(s5)
	
	# Read pretrained m1, store in 8(s0)
	lw a0, 8(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 8(s0)
	
	# store dimensions for m1 in s5
	lw t0, 0(s2) # row #
	lw t1, 0(s3) # col #
	sw t0, 8(s5)
	sw t1, 12(s5)

	# Read input matrix, store in 12(s0)
	lw a0, 12(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 12(s0)

	# store dimensions for input in s5
	lw t0, 0(s2) # row #
	lw t1, 0(s3) # col #
	sw t0, 16(s5)
	sw t1, 20(s5)


	# Compute h = matmul(m0, input)
	# malloc space for output array in s4
	# malloc 4(rows of m0 * cols of input) for s4
	lw t0, 0(s5)
	lw t1, 20(s5)
	addi t2, x0, 4
	mul a0, t0, t1
	mul a0, t2, a0
	jal ra, malloc
	beq a0, x0, malloc_error
	
	# store pointer to h in s4
	add s4, x0, a0


	# prepare for matmul
	# set a0 to be pointer to m0
	lw a0, 4(s0)
	# set a1 to be rows of m0
	lw a1, 0(s5)
	# set a2 to be columns of m0
	lw a2, 4(s5)
	# set a3 to be pointer to input
	lw a3, 12(s0)
	# set a4 to be rows of input
	lw a4, 16(s5)
	# set a5 to be columns of input
	lw a5, 20(s5)
	# set a6 to be s4
	add a6, x0, s4

	# call matmul
	jal ra, matmul

	# Compute h = relu(h)
	# prepare for relu
	# set a0 to be s4
	add a0, x0, s4
	# set a1 to be # of elements in s4 = rows of m0 * cols of input
	lw t0, 0(s5)
	lw t1, 20(s5)
	mul a1, t0, t1

	# call relu
	jal ra, relu

	# malloc space matrix O
	# total: 4(# of rows in O * # of columns in O)
	#	= 4(rows of m1 * cols of input)
	lw t0, 8(s5)
	lw t1, 20(s5)
	addi t2, x0, 4
	mul a0, t0, t1
	mul a0, a0, t2

	# call malloc
	jal ra, malloc

	# check for malloc error
	beq a0, x0, malloc_error

	# store O matrix pointer in s6
	add s6, x0, a0

	# Compute o = matmul(m1, h)
	# prepare for matmul
	# malloc space for dimensions of m0, m1, input in s5
	# 	matrix	|   row	 |   col  |
	#	  m0	|  0(s5) |  4(s5) |
	#	  m1	|  8(s5) | 12(s5) |
	#	 input	| 16(s5) | 20(s5) |
	#
	# set s0 be the command line args a1
	# values:
	# 	m0 at 4(s0)
	#	m1 at 8(s0)
	# 	input at 12(s0)
	# 	output at 16(s0)

	# set a0 to be pointer to m1
	lw a0, 8(s0)
	# set a1 to be rows of m1
	lw a1, 8(s5)
	# set a2 to be columns of m1
	lw a2, 12(s5)
	# set a3 to be pointer to h
	add a3, x0, s4
	# set a4 to be rows of h (rows of m0)
	lw a4, 0(s5)
	# set a5 to be columns of h (cols of input)
	lw a5, 20(s5)
	# set a6 to be s6
	add a6, x0, s6

	# Call matmul to write output matrix o
	jal ra, matmul

	# store O (s6) in output file 
	# prepare for write_matrix

	# set a0 to be the output filename string at 16(s0)
	lw a0, 16(s0)
	# set a1 to be s6 (pointer to matrix O)
	add a1, x0, s6
	# set a2 to be # of rows in O (rows of m1)
	lw a2, 8(s5)
	# set a3 to be # of columns in O (cols of h = cols of input)
	lw a3, 20(s5)	

	# call write_matrix 
	jal ra, write_matrix

	# Compute and return argmax(o)
	# prepare for argmax
	# set a0 to be pointer to matrix O (s6)
	add a0, x0, s6
	# set a1 to be the number of entries in O (# row of O * # col of O)
	# 	row of O * # col of O = rows of m1 * cols of input (h)
	lw t0, 8(s5)
	lw t1, 20(s5)
	mul a1, t0, t1
	
	# call argmax
	jal ra, argmax

	# set return value to be return from argmax
	# return register (a0) already set to be return from argmax
	# store return value from argmax in s7
	add s7, x0, a0

	# If enabled, print argmax(o) and newline
	beq s1, x0, not_silent_mode

	j epilogue



epilogue:
	# free pointers in s0
	# s0[1] to s0[4]
	lw a0, 4(s0)
	jal ra, free
	lw a0, 8(s0)
	jal ra, free
	lw a0, 12(s0)
	jal ra, free
	lw a0, 16(s0)
	jal ra, free

	# free input matrix in s0
	add a0, x0, s0
	jal ra, free

	# free row pointer in s2
	add a0, x0, s2
	jal ra, free

	# free col pointer in s3
	add a0, x0, s3
	jal ra, free

	# free H pointer in s4
	add a0, x0, s4
	jal ra, free

	# free dimensions pointer in s5
	add a0, x0, s5
	jal ra, free

	# free O pointer in s6
	add a0, x0, s6
	jal ra, free

	# restore saved value from s7
	add a0, x0, s7

	# restore saved registers
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw s7, 28(sp)
	lw ra, 32(sp)

	# restore stack pointer
	addi sp, sp, 36


	ret

not_silent_mode:
	# runs if silent mode entry is set to 0
	# input:
	# 	a0	The value returned from argmax(o)

	# call print_int
	jal ra, print_int

	# prepare for print_char
	li a0 '\n'

	# call print_char
	jal ra, print_char

	# restore a0 to be return value from argmax(o) 
	add a0, x0, s7
	j epilogue



read_input_matrices:
	# Input:
	# 	a0 Pointer to filename string
	#	a1 Pointer to row # (allocated)
	# 	a2 Pointer to col # (allocated)
	# Return:
	# 	a0 Pointer to matrix in memory (output of read_matrix)
	
	# set up saved registers
	addi sp, sp, -4
	sw ra, 0(sp)

	# call read_matrix (same args as read_input_matrices)
	jal ra, read_matrix

	# restore saved registers
	lw ra, 0(sp)

	# restore stack pointer
	addi sp, sp, 4

	ret


incorrect_args:
	li a0 31
	j exit

malloc_error:
	li a0 26
	j exit

free_error:
	li a0 31
	j exit