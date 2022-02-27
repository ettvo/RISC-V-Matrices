.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
	# set a counter register equal to the array length
	# sets a register to 0 (representing max value index)
	# sets a register to the value at 0th index 
	# sends to loop continue
	# note: args given in the text above
	# need to save the previous registers' value then restore at end
	# (depends on calling conventions)
    
    # use as placeholder for 1
    addi t0, x0, 1
    
    # exit if length of array is less than 1
	blt a1, t0, exit_error
    
    # set up saved registers
    addi sp, sp, -16
    
    # set 0(sp) to be the index of the largest element
    sw s0, 0(sp)
    
    # set the initial index of the largest element to be 0
    add s0, x0, x0
    
    # set s1 --> 4(sp) to be the value of the current largest value
    sw s1, 4(sp) 
    
    # set s1 to be a0[0]
    lw s1, 0(a0)
    
    # set s2 --> 8(sp) to be the value of the current index
    sw s2, 8(sp)
    
    # set s1 to be a0[0]
    lw s2, 0(a0)
    
    # set s3 --> 12(sp) to be the counter for the index of the array
    sw s3, 12(sp)
    
    # set counter s3 to 0
    add s3, x0, x0
    
	# jumps to start
	j loop_start

	# use s2-s11


exit_error:
	li a0 36
	j exit
	

loop_start:

	# set s2 to be the value of the current index
    lw s2, 0(a0)
    
	# compare values
	# send to cond_increase if the value at the new index is greater
	# 	than the one at the old index
    bgt s2, s1, cond_increase
    
	# sends to loop continue
    j loop_continue


loop_continue:
	# increases the counter by 1 
    addi s3, s3, 1
    
	# sends to loop end if counter == array length
    beq s3, a1, loop_end
    
    # increases the pointer for a0 by 4 to go to the next index
    addi a0, a0, 4
    
	# else sends the next element of the array to loop start
    j loop_start


cond_increase:
	# set the max value index to the current counter value
    add s0, x0, s3
    
	# set the max value register to the current value at index counter
    lw s1, 0(a0)
    
	# jump to loop_continue
    j loop_continue


loop_end:
	# Epilogue
    
    # set a0 to be the index of the largest value
    add a0, x0, s0
    
    # reset the saved registers
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    
    addi sp, sp, 16

	ret
