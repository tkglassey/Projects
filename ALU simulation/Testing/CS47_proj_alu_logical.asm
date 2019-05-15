.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes: This program does not make use of creating a frame and storing it due to not 
#	 changing any registers in the RTE besides the t and v registers.
#####################################################################
au_logical:
	move 	$t0, $a0 #initial numbers
	move	$t1, $a1 #initial numbers
	
	beq	$a2, '+', addition
	beq 	$a2, '-', subtration
	beq	$a2, '*', multiplication
	beq	$a2, '/', division
	
#-----------------------------------------------------------------------------------------------------------------
addition:
	log_add($t0, $t1, $t2, $t3)
	move 	$v0, $t0
	j	fin
	
	
#------------------------------------------------------------------------------------------------------------------
subtration:
	seq	$t4, $zero, $zero
	flip_2s($t1, $t4, $t2, $t3)
	log_add($t0, $t1, $t2, $t3)
sub_end:
	move 	$v0, $t0
	j	fin
	
#------------------------------------------------------------------------------------------------------------------
multiplication:	#  $t0 = sum(HI), $t1 = mult 2, $t2 = temp, $t3 = temp, $t4 = 1, $t5 = mult 1, $t6 = mult 2, 
		#$t7 = counter, $t8 store whether mult will be negative, $t9 LO
	#j	fin
	seq	$t4, $zero, $zero	#set $t4 to 1
	move	$t7, $t4		#set counter
	flip_if_neg($t0, $t4, $t2, $t3, $t5)
	flip_if_neg($t1, $t4, $t2, $t3, $t6)
	xor	$t8, $t5, $t6
	move 	$t5, $t0		#store first arg in $t5
	move	$t6, $t1		#store second arg in $t6
	move	$t0, $zero		#$t0 is now 0
mult_loop:
	and	$t2, $t4, $t5		# check LSB in $t5
	move	$t1, $t6		#reset $t1 to $a1
	beq	$t2, $t4, mult_add_loop
	bne	$t2, $t4, mult_shift
	
mult_add_loop:
	log_add($t0, $t1, $t2, $t3)
	j	mult_shift

mult_shift:
	and	$t2, $t4, $t0		# get whether LSB of Hi is 1 or 0
	sll	$t2, $t2, 31		# move 1 to the MSB slot
	srl	$t9, $t9, 1		# move LO right
	or	$t9, $t9, $t2		# make t2 the MSB of LO
	srl	$t0, $t0, 1		# Shift Hi 1 right
	srl	$t5, $t5, 1		# move mult 1 right to new LSB
	sll	$t7, $t7, 1		# counter
	beqz	$t7, mult_end		#check if done
	j 	mult_loop		#restart loop
	
mult_neg:
	move	$t8, $zero
	not	$t0, $t0
	bnez	$t9, neg_con
	log_add($t0, $t4, $t2, $t3)	# If hypothetically the lower register was all 0's, the +1 would need to be carried over to the HI register
neg_con:
	flip_2s($t9, $t4, $t2, $t3)
	j	mult_end
	
mult_end:
	beq	$t4, $t8 mult_neg	#check if mult was originally neg
	move	$v0, $t9
	move	$v1, $t0
	j	fin
	
	
#------------------------------------------------------------------------------------------------------------------
division:
	seq	$t4, $zero, $zero	#set $t4 to 1
	move 	$t9, $zero
	flip_if_neg($t0, $t4, $t2, $t3, $t5)
	flip_if_neg($t1, $t4, $t2, $t3, $t6)
	xor	$t8, $t5, $t6
	move	$t7, $t5
	move	$v1, $t1
	max_shift_value($t1, $t4, $t2, $t6)
	
div_loop:
	blt	$t0, $t1, div_shift
	move	$t5, $t1
	flip_2s($t5, $t4, $t2, $t3)
	log_add($t0, $t5, $t2, $t3)
	move	$v0, $t6
	log_add($t9, $v0, $t2, $t3)
	
div_shift:
	beq	$t1, $v1, div_end
	srl	$t1, $t1, 1
	srl	$t6, $t6, 1
	j	div_loop
	
Q_neg:
	flip_2s($t9, $t4, $t2, $t3)
	move	$t8, $zero
	j	div_end
R_neg:
	flip_2s($t0, $t4, $t2, $t3)
	move	$t7, $zero
	j	div_end
	
div_end:
	bnez	$t8, Q_neg
	bnez	$t7, R_neg
	move	$v0, $t9
	move	$v1, $t0
	j fin
	
#----------------------------------------------------------------------------------------
fin:
	
	jr 	$ra
