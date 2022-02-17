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
	# exit if length of array is less than 1
	# set a register equal to the array length
	# set a counter register equal to the array length
	# sets a register to 0 (representing max value index)
	# sets a register to the value at 0th index 
	# sends to loop continue
	# note: args given in the text above
	# need to save the previous registers' value then restore at end
	# (depends on calling conventions)
	


loop_start:
	# compare values
	# send to cond_increase if the value at the new index is greater
	# 	than the one at the old index
	# sends to loop continue


loop_continue:
	# increases the counter by 1 
	# sends to loop end if counter == array length
	# else sends the next element of the array to loop start

cond_increase:
	# set the max value index to the current counter value
	# set the max value register to the current value at index counter
	# return to loop_start



loop_end:
	# Epilogue

	ret
