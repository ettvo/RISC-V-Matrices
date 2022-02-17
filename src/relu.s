.globl relu

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
	# exit if length of array is less than 1
	# set a register equal to the array length
	# set a counter register equal 0
	# sends the first element of the array to loop start


loop_start:
	# sets the current element to the positive version
	# sends to loop continue






loop_continue:
	# increases the counter by 1 
	# sends to loop end if counter == array length
	# else sends the next element of the array to loop start



loop_end:


	# Epilogue


	ret
