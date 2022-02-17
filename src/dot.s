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


loop_start:
	# exit if length less than 1 
	# exit if stride less than 1 
	# N stride = multiply the Nth terms (pattern) of 
	# 	the arrays
	# set the total_sum register to 0




loop_continue:
	# main branch for looping through a0 and a1
	# jump loop_arr0
	# jump loop_arr1
	# send to reset_stride counter
	# send to loop continue (exiting handled 
	# in loop_arr0, loop_arr1)


loop_arr0:
	# iterates until next stride location reached
	# send to loop_end if past end of arr0 array is reached
	# return to loop_continue



loop_arr1:
	# iterates until next stride location reached
	# send to loop_end if past end of arr0 array is reached
	# return to loop_continue



reset_stride_counter:
	# set stride counter to 0
	# multiplies the values at the two pointers
	# adds product to total_sum register
	# return to loop_continue




loop_end:


	# Epilogue

	# needs to return the total_sum register value
	ret
