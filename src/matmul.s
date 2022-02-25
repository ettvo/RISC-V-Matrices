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
    
    

set_row_ptrs_stride:
	# use row counter s4
    
    #   a0 (int*) is the pointer to the start of arr0
    
    # set a3 to stride 1
    addi a3, x0, 1
    # values determined in 


set_col_ptrs_stride:
	# use col counter s5
    
	#   a1 (int*) is the pointer to the start of arr1
    
    # set a3 to stride 1
    addi a4, x0, 1



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
    
    # set row pointers
    jal ra, set_row_ptrs_stride
    
    # restore the return address
    add ra, x0, t5
    
    # set col pointers
    jal ra, set_col_ptrs_stride
 
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
    j outer_loop_end
    
    

# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1

set_row_neg1:
	# set s4 to be -1 so it is incremented to 0
    addi s4, x0, -1
	

set_col_neg1:
	# set s5 to be -1 so it is incremented to 0
    addi s5, x0, -1

reset_row:
	# set s4 to be the current row of arr0
    
	

reset_col:
	# set s5 to be the current col of arr1
    
    

outer_loop_end:
	# increases all iterating variables
    # save the return address in t5
    add t5, x0, ra
    
    # reset row # for arr0
    # beq s4, a1, reset_row
    jal ra, reset_row
    
    # restores the return address
    add ra, x0, t5
    
    # reset col # for arr1
    # beq s5, a5, reset_col
    jal ra, reset_col
    
    # restores the return address
    add ra, x0, t5
    
    # stores dot product in current pos in C
    sw s6, 0(a6)
    
    # move pointer of array C to next entry
    addi a6, a6, 4
    
    # increase entry counter
    addi s3, s3, 1
    
    # restart loop
    j outer_loop_end
    


epilogue:
	
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    
    addi sp, sp, -28
    
    

	# Epilogue


	ret
