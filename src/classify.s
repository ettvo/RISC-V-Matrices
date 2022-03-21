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
	addi sp, sp, -24

	# set s0 be the command line args a1
	sw s0, 0(sp)
	add s0, x0, a1

	# set s1 to be a2
	sw s1, 4(sp)
	add s1, x0, a2

	# set s2 to be the row # pointer
	sw s2, 8(sp)

	# set s3 to be the col # pointer
	sw s3, 12(sp)

	# set s4 to be the pointer for matrix output H (later O)
	sw s4, 16(sp)

	# store ra
	sw ra, 20(sp)

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

	# Read pretrained m0, store in 4(s0)
	lw a0, 4(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 4(s0)

	# Read pretrained m1, store in 8(s0)
	lw a0, 8(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 8(s0)

	# Read input matrix, store in 12(s0)
	lw a0, 12(s0)
	add a1, x0, s2
	add a2, x0, s3
	jal ra, read_input_matrices
	sw a0, 12(s0)

	# Compute h = matmul(m0, input)



	# Compute h = relu(h)


	# Compute o = matmul(m1, h)


	# Write output matrix o


	# Compute and return argmax(o)


	# If enabled, print argmax(o) and newline


	# Epilogue

	# free row pointer in s2
	add a0, x0, s2
	jal ra, free

	# free col pointer in s3
	add a0, x0, s3
	jal ra, free

	# restore saved registers
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw ra, 20(sp)

	# restore stack pointer
	addi sp, sp, 24


	ret
	


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