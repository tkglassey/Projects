.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	beq	$a2, '+', addition
	beq 	$a2, '-', subtration
	beq	$a2, '*', multiplication
	beq	$a2, '/', division
	j	fin
addition:
	add 	$v0, $a0, $a1
	j	fin
subtration:
	sub	$v0, $a0, $a1
	j	fin
multiplication:
	mul	$v0, $a0, $a1
	mfhi	$v1
	j	fin
division:
	div	$a0, $a1
	mflo	$v0
	mfhi	$v1
	j	fin
fin:
	jr	$ra
