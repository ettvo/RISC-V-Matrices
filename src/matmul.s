.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

	# Error checks
	# error if dimensions are invalid (0, <0, NaN, etc.)
	# error if dimensions of both are invalid (axb, bxc = axc)


	# Prologue


error:
	# exit 38 


outer_loop_start:
	# outer loop fills in entries of the finished matrix
	# allocate space for array (?)
	# iterate over rows
	# --> iterate over columns
	# send row array to dot method
	# send column array to dot method
	# get value from inner loop
	# set new array value to be value from inner loop




inner_loop_start:
	# inner loop computes the dot product of each entry
	# sends the given arrays to dot method 
	# --> always ends at correct end 



inner_loop_end:
	# returns a value




outer_loop_end:


	# Epilogue


	ret
