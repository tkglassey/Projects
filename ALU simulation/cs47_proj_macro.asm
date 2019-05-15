# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
	# Macro: log_add
	# Usage: log_add($addend, $addend, $Unimportant register, $Unimportant register)
	.macro log_add($val1, $val2, $temp1, $temp2)	
	# Result: $val 1 = sum, $val 2 = 0, $temp1 and $temp2 will be replaced
macro_add_loop:
	xor 	$temp1, $val1, $val2 	#sum
	and	$temp2, $val1, $val2 	#carry in
	move 	$val1, $temp1      	#sum
	move	$val2, $temp2		#carry in
	sll	$val2, $val2, 1		#shift carry in 1 left
	bnez 	$val2, macro_add_loop	#end if carry in = 0
	.end_macro
	
	# Macro: flip_2s
	# Usage: flip_2s($value, $one, $Unimportant register, $Unimportant register)
	.macro flip_2s($val, $one, $temp1, $temp2)
	# Result: $val = Reversed sign of 2's complement number, $one = 1, $temp1 and $temp2 replaced
	not 	$val, $val
	log_add($val, $one, $temp1, $temp2)
	seq	$one, $zero, $zero
	.end_macro
	
	# Macro: max_shift_value
	# Usage: max_shift_value($positive value, $one, $Unimportant register, $Storage for lowest digit location)
	.macro max_shift_value($val, $one, $temp, $lowest)
	# Result: $val will be the max left shifted value without losing a leading 1, $one will be one, $temp will be changed, $lowest will be the lowest number's location
	move	$lowest, $one
	sll 	$one, $one, 31
	# and	$temp, $val, $one
	# not possible for the first sll to lose a one as the number cannot be negative
leading_loop:
	sll 	$val, $val, 1
	sll	$lowest, $lowest, 1
	and	$temp, $val, $one
	bne	$temp, $one, leading_loop
	
	srl	$val, $val, 1	#make the number no longer negative
	srl	$lowest, $lowest, 1
	seq	$one, $zero, $zero
	.end_macro
	
	# Macro: flip_if_neg
	# Usage: ($2's complement value, $one, $Unimportant register, $Unimportant register, $register to store whether number was negative)
	.macro flip_if_neg($val, $one, $temp1, $temp2, $neg)
	# Results: $positive val, $one, $unimportant, $unimportant, $0 if positive, 1 if negative
	move	$temp1, $one
	sll	$temp1, $temp1, 31
	and	$temp1, $temp1, $val
	beqz	$temp1, positive
	flip_2s($val, $one, $temp1, $temp2)
	move	$neg, $one
	j	shift_end
positive:
	move 	$neg, $zero
shift_end:
	seq	$one, $zero, $zero
	.end_macro
	
	
	
