.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
insertion_sort:
	# Caller RTE store (TBD)
	# Unecessary

	add $t0, $zero, $zero
for:	add $t0, $t0, 1		# $t0 = i
	beq $t0, $a1, insertion_sort_end
	add $t1, $t0, $zero	# $t1 = j = i
while:	blt $t1, 1, for		# while j>0
	sll $t7, $t1, 2		# j*4 to make it move by j word addresses
	add $t7, $t7, $a0	# A[j] address
	lw $t2, 0($t7)		# A[j]
	lw $t3, -4($t7)		# A[j-1]
	blt $t3, $t2, for	# while A[j-1]>A[j]
	sw $t2, -4($t7)		#swap
	sw $t3, 0($t7)
	add $t1, $t1, -1	# j=j-1
	j while
	
	
insertion_sort_end:
	# Caller RTE restore (TBD)
	# unecessary
	
	# Return to Caller
	jr	$ra
