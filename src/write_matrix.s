.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue

	# set up saved registers
	addi sp, sp, -28

	# set s0 to be the file descriptor
	sw s0, 0(sp)

	# set s1 to be the pointer to the matrix
	sw s1, 4(sp)
	add s1, x0, a1

	# set s2 to be the row #
	sw s2, 8(sp)
	add s2, x0, a2

	# set s3 to be the col #
	sw s3, 12(sp)
	add s3, x0, a3

	# set s4 to be the pointer to the row #
	sw s4, 16(sp)

	# set s5 to be the pointer to the col # 
	sw s5, 20(sp)

	# store ra
	sw ra, 24(sp)

	# prepare for fopen
	# a0 already with filename string pointer
	# set a1 to 1 for write-only 
	addi a1, x0, 1

	# open file with write permissions
	jal ra, fopen

	# test for fopen error
	addi t0, x0, -1
	beq t0, a0, fopen_error

	# store the file descriptor from fopen in s0
	add s0, x0, a0
    
    ebreak # after storing file descriptor in s0

	# set up the row pointer
	addi a0, x0, 4
	jal ra, malloc
	
	# check for malloc error
	beq a0, x0, malloc_error

	# store the row pointer in s4
	add s4, x0, a0

	# set up the col pointer
	addi a0, x0, 4
	jal ra, malloc
	
	# check for malloc error
	beq a0, x0, malloc_error

	# store the col pointer in s5
	add s5, x0, a0

	# prepare for fwrite for row #
	# set a0 to be the file descriptor in s0
	add a0, x0, s0

	# set a1 to be the row pointer in s4
	add a1, x0, s4

	# store the row # in 0(s4)
	sw s2, 0(s4)
	
	# set a2 to be 1
	addi a2, x0, 1

	# set a3 to be the size of an int 
	addi a3, x0, 4

	# call fwrite
	jal ra, fwrite

	# check for fwrite error
	addi t0, x0, 1
	bne t0, a0, fwrite_error

	# prepare for fwrite for col #
	# set a0 to be the file descriptor in s0
	add a0, x0, s0

	# set a1 to be the col pointer in s5
	add a1, x0, s5

	# store the col # in 0(s5)
	sw s3, 0(s5)
	
	# set a2 to be 1
	addi a2, x0, 1

	# set a3 to be the size of an int 
	addi a3, x0, 4

	# call fwrite
	jal ra, fwrite

	# check for fwrite error
	addi t0, x0, 1
	bne t0, a0, fwrite_error


	# prepare to fwrite contents of entire matrix
	# set a0 to be the file descriptor in s0
	add a0, x0, s0
	# set a1 to be the pointer to the matrix in s1
	add a1, x0, s1

	# set a2 to be the number of elements in the matrix
	mul a2, s2, s3

	# set a3 to be the size of an int
	addi a3, x0, 4

	# call fwrite
	jal ra, fwrite

	# check for fwrite error
	mul t0, s2, s3
	bne t0, a0, fwrite_error



	# Epilogue

	# prepare for fclose
	add a0, x0, s0

	# ebreak # before fclose

	# fclose file in s2
	jal ra, fclose

	# check for fclose error
	addi t0, x0, -1
	beq t0, a0, fclose_error

	# prepare for free row
	add a0, x0, s4
	# free the space 
	jal ra, free

	# prepare for free col
	add a0, x0, s5
	# free the space 
	jal ra, free

	# restore saved registers
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw ra, 24(sp)

	# restore stack pointer
	addi sp, sp, 28

	ret




fopen_error:
	li a0 27
	j exit

fclose_error:
	li a0 28
	j exit

fwrite_error:
	li a0 30
	j exit

malloc_error:
	li a0 26
	j exit

free_error: 
	li a0 31
	j exit
