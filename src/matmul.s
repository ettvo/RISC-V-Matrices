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
    addi sp, sp, -40
    
    # use s0-s5 to store a0-a6
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    
    # save a0-a3 in s0-s3
    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3
    
    # a2 == a4, so s4 stores a5
    add s4, x0, a5
    # # a2 == a4, so s5 stores a6
    add s5, x0, a6
    
    # use s6 as the entry counter for how many entries in d have been filled
    sw s6, 24(sp)
    add s6, x0, x0
    
    # use s7 as arr0 row counter
    sw s7, 28(sp)
    add s7, x0, x0
    
    # use s8 as arr1 col counter
    sw s8, 32(sp)
    add s8, x0, x0
    
    # use s9 to store return address in inner loop
    sw s9, 36(sp)
    
    # need to remember to iterate these
    
	# Prologue
    j outer_loop_start
    
    
exit_error:
    li a0 38
    j exit


outer_loop_start:
	# outer loop fills in entries of the finished matrix
    # handles pointer to current elements in row major form 
    # goes 1 entry at a time 
    
    ebreak 
    
    # set t0 to be entry limit
    mul t0, a1, a5
    
    # exit if all entries in new array C filled
    beq s6, t0, epilogue
    
    # begins inner loop
    j inner_loop_start
    
    

inner_loop_start:
	# To calculate the entry at row i, column j of C, take the dot product of the ith row of A and the jth column of B. 
    # stored row major
    # get col 1 (0th indexing) by moving array pointer 1 pos forward, stride being the width of the matrix
    # get row 1 (0th indexing) by moving the array pointer [width] positions forward, stride 1, for [width] elements

	# inner loop computes the dot product of each entry
    # passes params to 
	# sends the given arrays to dot method 
	# --> always ends at correct end 
    # sets up and calls dot product to get value
    
    # save the return address in s9
    # add s9, x0, ra
    
    # move row pointer 1 space
    addi a0, a0, -4
    
    # set a1 to be the counter for set_row_ptrs
    # set to -1 to account for iterating for 0
    addi a1, x0, -1
    
    # use a2 as row limit
    # multiply col_0*(row_0 # - 1) to calculate row limit for arr0
    # issue is that this can be 0 and therefore never exit
    addi a2, s1, -1
    mul a2, a2, s2
    
    ebreak
    
    # set row pointers
    j set_ptrs_row # row ptr
    
    # restore the return address
    # add ra, x0, s9
    
inner_loop_get_col:
    
    # store the pointer to arr0 in t0
    add t0, x0, a0
    
    # need to set a0 to arr1 pointer
    
    # get rows by shifting pointer by multiples of 4 and having stride 1
    # get cols by shifting pointer as necessary and having stride depending on col
    # num elements to use for 
    
    # move into a0 for calling set_ptrs
    # move col pointer back 1 space
    addi a0, a3, -4
    
    # set a1 to be the counter for set_row_ptrs
    # set to -1 to account for iterating for 0
    addi a1, x0, -1
    
    # use a2 as col limit
    # use col_1 size as col limit for arr1
    addi a2, s4, -1
    
    ebreak 
    
    # set col pointers
    j set_ptrs_col # col ptr
    

inner_loop_end:
    # move pointer to arr1 to a1
    add t1, x0, a0
    
    # set func params for dot.s
    
    # set a0 to be pointer to m0 row
    add a0, x0, t0
        
    # set a1 to be pointer to m1 col
    add a1, x0, t1
    
    # set a2 to be # of elems --> length of row (m0 cols; s1) or height of col (m1 rows; s4)
    add a2, x0, s1
    
    # set a3 (arr0 row stride) to stride 1
    addi a3, x0, 1
    
    # set a4 (arr1 col stride) to row size (width = # cols)
    add a4, x0, a5
 
    # save the return address
    add s9, x0, ra
    
   	# calls dot.s
    jal ra, dot
    
    # restore the return address
    add ra, x0, s9
    
    ebreak
    
    # dot product always saved in a0
    # stores current dot product in t0
    add t0, x0, a0
    
    # retrieve a0-a4 from t0-t4
    add a0, x0, s0
    add a1, x0, s1
    add a2, x0, s2
    add a3, x0, s3
    add a4, x0, s2
    add a5, x0, s4
    add a6, x0, s5
    
    # jumps to outer_loop_end
    j outer_loop_end
    

set_ptrs_row:
	# input for set_row_ptrs:
	#   a0 (int*)  is the pointer to the start of the row array
	#   a1 (int)   is the counter
	#   a2 (int)   is the limit to the counter
    # return:
    # 	none (a1 pointing to the expected position in the array)
	# use total rows s4
    # move the row pointer over s4 - 1 many spaces to be at row s4
    
    # move row pointer 1 space
    addi a0, a0, 4
    
    # increase counter
    addi a1, a1, 1
    
    # restart loop
    # addi t0, a2, -1
    
    bne a1, a2, set_ptrs_row
    # goes to outer_loop_end if just here 
    # does not return
    j inner_loop_get_col
    
set_ptrs_col:
	# input for set_row_ptrs:
	#   a0 (int*)  is the pointer to the start of the row array
	#   a1 (int)   is the counter
	#   a2 (int)   is the limit to the counter
    # return:
    # 	none (a1 pointing to the expected position in the array)
	# use total rows s4
    # move the row pointer over s4 - 1 many spaces to be at row s4
    
    # move row pointer 1 space
    addi a0, a0, 4
    
    # increase counter
    addi a1, a1, 1
    
    # restart loop
    # addi t0, a2, -1
    
    bne a1, a2, set_ptrs_col
    # goes to outer_loop_end if just here 
    # does not return
    j inner_loop_end
    
    
outer_loop_end:

	# stores dot product in current pos in C
    sw t0, 0(a6)
    # issue where t0 has label used but not defined --> need to switch to using saved or func arg registers
    
    # move pointer of array C to next entry
    addi a6, a6, 4
    
    # increase entry counter
    addi s6, s6, 1
    
    # increment col counter for arr1
    addi s8, s8, 1
    
    # update row, col counters
    jal ra, update_row
    
	j outer_loop_start
    
    
######### need to fix reset 
update_row:
	# actually needs to keep increasing col until end --> then set col to 0; increase row by 1 (row major form)
    # increments row counter when end of col for arr1 reached
    
    # checks if end of col for arr1 not reached (counter < col #)
    # bne s8, a5
    beq s8, a5, incr_row
    j outer_loop_start
    

incr_row:
    # increase row counter by 1
    addi s7, s7, 1
    
	# set col counter to be 0
    add s8, x0, x0
    
    j outer_loop_start

epilogue:
    
    # does a6 still need to point to start of d?
    
    # restore s0-s7
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    
    addi sp, sp, 40

	# Epilogue


	ret
