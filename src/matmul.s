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
    # set t0 to be 1
    addi t0, x0, 1
    
	# error if invalid dimensions for each matrix
    blt a1, t0, exit_error
    blt a2, t0, exit_error
    blt a4, t0, exit_error
    blt a5, t0, exit_error
    
    # error if col of arr0 and row of arr1 aren't equal
    bne a2, a4, exit_error

	# set up saved registers
    addi sp, sp, -28
    
    # set s0 to be the pointer to the first element of m0 
	sw s0, 0(sp)
    add s0, x0, a0
    
    # set s1 to be the pointer to the first element of m1
	sw s1, 4(sp)
    add s1, x0, a3
    
    # set s2 to be the entry limit
	sw s2, 8(sp)
    add s2, x0, x0
    
    # set s3 to be the entry counter
	sw s3, 12(sp)
    mul s3, a1, a5
    
    # set s4 to be the current row of arr0
    sw s4, 16(sp)
    add s4, x0, x0
    
    # set s5 to be the current col of arr1
    sw s5, 20(sp)
    add s5, x0, x0
    
    # set s6 to be the current dot product
    sw s6, 24(sp)
    add s6, x0, x0
    
	# Prologue
    j outer_loop
    
	# To calculate the entry at row i, column j of C, take the dot product of the ith row of A and the jth column of B. 
    # stored row major
    # get col 1 (0th indexing) by moving array pointer 1 pos forward, stride being the width of the matrix
    # get row 1 (0th indexing) by moving the array pointer [width] positions forward, stride 1, for [width] elements

exit_error:
	# exit 38 
    li a0 38
    j exit

outer_loop:
	# outer loop fills in entries of the finished matrix
    # handles pointer to current elements in row major form 
    # goes 1 entry at a time 
    
    # exit if all entries in new array C filled
    beq s3, s2, epilogue
    
    # keeps track of row #, col #
    
    # get rows by shifting pointer by multiples of 4 and having stride 1
    # get cols by shifting pointer as necessary and having stride depending on col
    # num elements to use for 
    
	# allocate space for array (?)
	# iterate over rows
	# --> iterate over columns
	# send row array to dot method
	# send column array to dot method
	# get value from inner loop
	# set new array value to be value from inner loop
    
    # get rows by shifting pointer by multiples of 4 and having stride 1
    # get cols by shifting pointer as necessary and having stride depending on col
    # num elements to use for 
    
    # jumps
    j inner_loop
    
    

set_row_ptrs:
	# start:
	#   a0 (int*)  is the pointer to the start of m0
	#   a1 (int)   is the # of rows (height) of m0
	#   a2 (int)   is the # of columns (width) of m0
	# set t6 to be the counter for set_row_ptrs
	# use total rows s4
    # move the row pointer over s4 - 1 many spaces to be at row s4
    
    # move row pointer 1 space
    addi a0, a0, 4
    
    # increase counter
    addi t6, x0, 1
    
    # restart loop
    bne a3, t6, set_row_ptrs
    
    
	# end: 
    #   a0 (int*) is the pointer to the start of arr0
    
# use a3 as col limit
#    addi a3, s4, -1
    


set_col_ptrs:
	# use total cols s5
    # start:
    #   a3 (int*)  is the pointer to the start of m1
	#   a4 (int)   is the # of rows (height) of m1
	#   a5 (int)   is the # of columns (width) of m1
    # set t6 to be the counter for set_row_ptrs
    # move the col pointer over s5 - 1 many spaces to be at col s5
    
    # move col pointer 1 space
    addi a3, a3, 4
    
    # increase counter
    addi t6, x0, 1
    
    # restart loop
    bne a3, t6, set_col_ptrs
    
    # use a3 as col limit
#    addi a3, s4, -1
    
    # end:
	#   a1 (int*) is the pointer to the start of arr1
    
    
    

# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1

# use a3 as col limit
    # addi a3, s5, -1



inner_loop:
	# inner loop computes the dot product of each entry
    # passes params to 
	# sends the given arrays to dot method 
	# --> always ends at correct end 
    # sets up and calls dot product to get value
    
    # set dot product counter to 0
    add s6, x0, x0
    
    # save a0-a4 in t0-t4
    add t0, x0, a0
    add t1, x0, a1
    add t2, x0, a2
    add t3, x0, a3
    add t4, x0, a4
    
    # save the return address in t5
    add t5, x0, ra
    
    # error if col of arr0 or row of arr1 aren't equal --> use a2 = keep the same
    
    # get rows by shifting pointer by multiples of 4 and having stride 1
    # get cols by shifting pointer as necessary and having stride depending on col
    # num elements to use for 
    

    
    # set t6 to be the counter for set_row_ptrs
    add t6, x0, x0
    
    # use a3 as row limit
    # multiply col*(row # - 1) to calculate row limit
    addi a3, s4, -1
    mul a3, a2, a3
    
    # set row pointers
    jal ra, set_row_ptrs
    
    # restore the return address
    add ra, x0, t5
    
    # get rows by shifting pointer by multiples of 4 and having stride 1
    # get cols by shifting pointer as necessary and having stride depending on col
    # num elements to use for 
    
    # set t6 to be the counter for set_col_ptrs
    add t6, x0, x0
    
    # use a3 as col limit
    # use col size as col limit
    addi a3, s5, -1
    
    # set col pointers
    jal ra, set_col_ptrs
    
    # set a3 (arr0 row stride) to stride 1
    addi a3, x0, 1
    
    # set a4 (arr1 col stride) to stride col length
    addi a4, x0, a5
 
    # restore the return address
    add ra, x0, t5
    
    # change the a0-a4 to have the registers necessary to call dot.s
    
   	# calls dot.s
    jal ra, dot
    
    # restore the return address
    add ra, x0, t5
    
    # stores current dot product in s6
    add s6, x0, a0
    
    # retrieve a0-a4 from t0-t4
    add a0, x0, t0
    add a1, x0, t1
    add a2, x0, t2
    add a3, x0, t3
    add a4, x0, t4
    
    # jumps to outer_loop_end
    j outer_loop_end_beg
    
    

# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1

reset_row:
	bne s4, a4, reset_col
    
	# set s4 to be 0
    add s4, x0, x0
    
    j reset_col
	

reset_col:
	bne s5, a5, outer_loop_end
    
	# set s5 to be the current col of arr1
    # set s5 to be 0
    add s5, x0, x0
    
    j outer_loop_end
    
    
outer_loop_end_beg:

	# increases row and col counters by 1
    addi s4, s4, 1
    addi s5, s5, 1
    
    j reset_row
    

outer_loop_end:

	# stores dot product in current pos in C
    sw s6, 0(a6)
    
    # move pointer of array C to next entry
    addi a6, a6, 4
    
    # increase entry counter
    addi s3, s3, 1
    
	j outer_loop_start

    


epilogue:
	
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    
    addi sp, sp, -28
    
    # does a6 still need to point to start of d?

	# Epilogue


	ret
