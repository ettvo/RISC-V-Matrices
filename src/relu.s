.globl relu

.import abs.s

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
    
    
    # use as placeholder for 1
    addi t0, x0, 1
    
    # exit if length of array is less than 1
	blt a1, t0, exit_error
    
    # set up saved registers
    addi sp, sp, -20
    
    # set 0(sp) to be the counter pointer equal to 0
    sw s0, 0(sp)
    
    # set s1 --> 4(sp) to be the pointer to the current index
    sw s1, 4(sp) 
    
    # set s2 --> 8(sp) to be the value of the current index
    sw s2, 8(sp)
    
    # set s3 --> 12(sp) to be the length of the array
    sw s3, 12(sp)
    
    # set s4 --> 16(sp) to be the return address
    sw s4, 16(sp)
    
    ebreak
	# set a counter register s2 equal 0
	add s0, x0, x0

	# jumps to start
	j loop_start

	# use s2-s11


exit_error:
	li a0 36
	j exit

loop_start:
	# prepares for calling ABS function from abs.s by saving a0 pointer in s1
    add s1, x0, a0
    
    ebreak
    # store value at offset(array) into a0 to pass to ABS
    lw a0, 0(s1)
    
    # stores a1 into s3 temporarily
    add s3, x0, a1
    
    # store return address
    add s4, x0, ra
    
    # need to store a0, a1 between calls
	# sets the current element to 0 if negative
    blt a0, x0, negative
    
    # restore return address
    add ra, x0, s4
    
    # restores a1
    add a1, x0, s3
    
    ebreak
    
    # store the new value of the current index (stored in a0) into s2
    # sw a0, 4(sp)
    add s2, x0, a0
    
    # restore original pointer for a0 
    add a0, x0, s1
    
    # store the new value of the current index (stored in a0) into the current position in the array
    # lw t0, 4(sp)
    # sw t0, 0(a0)
    sw s2, 0(a0)
    
	# jumps to loop continue
    j loop_continue
    
    
negative:
	# restore return address
    add ra, x0, s4
    
    # restores a1
    add a1, x0, s3
    
    ebreak
    
    # store the new value of the current index (stored in a0) into s2
    # sw a0, 4(sp)
    add s2, x0, x0
    
    # restore original pointer for a0 
    add a0, x0, s1
    
    # store the new value of the current index (stored in a0) into the current position in the array
    # lw t0, 4(sp)
    # sw t0, 0(a0)
    sw s2, 0(a0)
    
	# jumps to loop continue
    j loop_continue
	



loop_continue:
	ebreak
	# increases the counter by 1
    addi s0, s0, 1
    # lw t0, 0(sp)
	# addi t0, t0, 1
    # sw t0, 0(sp)
   
    # increases pointer --> moves to next index
    addi a0, a0, 4
    
	# sends to loop end if counter == array length
	beq s0, a1, loop_end

	# otherwise sends the next element of the array to loop start
    j loop_start


loop_end:

	# Epilogue
    
    add ra, x0, s4
    
    # set 0(sp) to be the counter pointer equal to 0
    # lw s0, 0(sp)
    add s0, x0, x0
    
    # set s1 --> 4(sp) to be the pointer to the current index
    # lw s1, 4(sp) 
    add s1, x0, x0
    
    # set s2 --> 8(sp) to be the value of the current index
    # lw s2, 8(sp)
    add s2, x0, x0
    
    # set s3 --> 12(sp) to be the length of the array
    # lw s3, 12(sp)
    add s3, x0, x0
    
    # set s4 --> 16(sp) to be the return address
    # lw s4, 16(sp)
    add s4, x0, x0

	addi sp, sp, 20

	ret
