.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
	# Prologue
    
    # set t0 to 1 
    addi t0, x0, 1
    
	# exit if length less than 1 
    blt a2, t0, exit_length
    
	# exit if stride less than 1 
    blt a3, t0, exit_stride
    blt a4, t0, exit_stride
    
    # set up saved registers
    addi sp, sp, -24
    
    # set s0 to be current index for arr0
    # set s0 to 0
    sw s0, 0(sp)
    addi s0, x0, 0
    
    # set s1 to be current index for arr1
    # set s1 to 0
    sw s1, 4(sp)
    addi s1, x0, 0
    
    # set s2 to be total
    # set s2 to 0 
    sw s2, 8(sp)
    add s2, x0, x0
    
    # set s3 to be the stride counter for arr0
    # set s3 to 1
    sw s3, 12(sp)
    addi s3, x0, 1
    
    # set s4 to be the stride counter for arr1
    # set s4 to 1
    sw s4, 16(sp)
    addi s4, x0, 1
    
    # set s5 to hold counter for calculated elements
    # set s5 to x1
    sw s5, 20(sp)
    add s5, x0, x0
    
    # use t0 to hold the return address
    
    # use t1 to hold the current dot produt before storing in s2
    
    # jump to loop_start
    # j loop_start
    
    # jump to reset_stride_counter due to always starting with 0th term in calculations
    j reset_stride_counter
    

exit_length:
	li a0 36
    j exit

exit_stride:
	li a0 37
    j exit
    

loop_start:
	ebreak
    
    # call loop_arr0
    j loop_arr0
    
    
loop_arr0:
	# iterates until next stride location reached
    
    # need to exit if stride equal here and go to next loop
    # can chain from arr 0 --> arr 1 --> loop end 
    # currently can iterate past end
    
    # goes to loop_arr1 if stride counter equal to stride length
    beq s3, a3, loop_arr1
    
    # increase stride counter by 1
    addi s3, s3, 1
    
    # increase index by 1
    addi s0, s0, 1
    
    # send to loop_end if past end of arr0 array is reached
    # beq a2, s0, loop_end
    
    # increase pointer by 4
    addi a0, a0, 4
    
    # send to loop_arr1 again if less than stride for arr0
    blt s3, a3, loop_arr0


loop_arr1:
	# iterates until next stride location reached
    
    # need to exit if stride equal here and go to next loop
    # can chain from arr 0 --> arr 1 --> loop end 
    # currently can iterate past end
    
    # goes to reset_stride_counter if stride counter equal to stride length
    beq s4, a4, reset_stride_counter
    
    # increase stride counter by 1
    addi s4, s4, 1
    
    # increase index by 1
    addi s1, s1, 1
    
    # send to loop_end if past end of arr1 array is reached
    # beq a2, s1, loop_end
    
    # increase pointer by 4
    addi a1, a1, 4
    
    # send to loop_arr1 again if less than stride for arr1
    blt s4, a4, loop_arr1
    


reset_stride_counter:
    
	# set stride counters to 0
    add s3, x0, x0
    add s4, x0, x0
    
    ebreak
   
    # prepares for multiplying values
    lw t0, 0(a0)
    lw t1, 0(a1)
    
    # multiplies the values at the two pointers and stores in t0
    mul t0, t0, t1
    
    ebreak
	# adds product to total_sum register
    add s2, s2, t0
    
    # set t0 to the last index of arr0, arr1
    # addi t0, a2, -1
    
    # send to loop_end if end of arr0 array is reached
    # beq t0, s0, loop_end
    
    # send to loop_end if end of arr1 array is reached
    # beq t0, s1, loop_end
    
    # increase element counter
    addi s5, s5, 1
    
    # send to loop_end if expected number of terms has been calculated
    beq a2, s5, loop_end
    
	# return to loop_start to begin new cycle
    j loop_start



loop_end:


	# Epilogue
    
    ebreak
    
	# needs to return the total_sum register value
    # set a0 to s2 (total)
    add a0, x0, s2
    
    # set saved registers to x0 
    add s0, x0, x0
    add s1, x0, x0
    add s2, x0, x0
    add s3, x0, x0
    add s4, x0, x0
    add s5, x0, x0
    
    # reset SP pointer
    addi sp, sp, 24
    
	ret
