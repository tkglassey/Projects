#<---------------- MACRO DEFINITIONS ----------------------------->#
	# Macro : print_str
	# Usage : print_str(<address of the string>)
	.macro print_str ($arg)
	li $v0, 4    	#system call code for print_str
	la $a0, $arg 	#addres of string to print
	syscall 	#print the string
	.end_macro 
	
	# Macro : print_int
	# Usage : print_int(<value>)
	.macro print_int ($arg)
	li $v0, 1 	#system call code for print_int
	li $a0, $arg 	#integer to print
	syscall 	#print the integer
	.end_macro 
	
	# Macro : exit
	# Usage : exit
	.macro exit
	li $v0, 10 	#exit call code
	syscall 	#exit program
	.end_macro 
	
	# Macro : read_int
	# Usage : read_int(<register to store int at>)
	.macro read_int ($reg)
	li $v0, 5
	syscall 
	move $reg, $v0
	.end_macro
	
	# Macro : print_reg_int
	# Usage : print_reg_int(<register of int to be printed>)
	.macro print_reg_int ($reg)
	li $v0, 1
	move $a0, $reg
	syscall
	.end_macro 
	
	# Macro : swap_hi_lo
	# Usage : swap_hi_lo(<temporary register to hold hi content> , <temporary register to hold lo content>)
	.macro swap_hi_lo ($temp1, $temp2)
	mfhi $temp1
	mflo $temp2
	mthi $temp2
	mtlo $temp1
	.end_macro
	
	# Macro : print_hi_lo
	# Usage : print_hi_lo (<String "Hi"> , <String "="> , <String ","> , <String "Lo">)
	.macro print_hi_lo($strHi, $strEqual, $strComma, $strLo)
	mfhi $t0
	mflo $t1
	print_str($strHi)
	print_str($strEqual)
	print_reg_int($t0)
	print_str($strComma)
	print_str($strLo)
	print_str($strEqual)
	print_reg_int($t1)
	.end_macro
	
	# Macro : lwi 
	# Usage : lwi (<register to store values> , <Immediate to go in upper> , <Immediate to go in Lower>)
	.macro lwi($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $li
	.end_macro
	
	# Macro : push
	# Usage : push(<register to store into stack>)
	.macro push($reg)
	sw $reg, 0x0($sp)
	addi $sp, $sp, -4
	.end_macro
	
	# Macro : pop
	# Usage : pop(<register to hold information from the stack>)
	.macro pop($reg)
	addi $sp, $sp, +4
	lw $reg, 0x0($sp)
	.end_macro

#<---------------------- DATA DEFINITIONS ---------------->#
#.data
#askInput: .asciiz "Please enter a number? "
#response: .asciiz "You have entered # "

#<---------------------- CODE SEGMENT -------------------->#
#.text
#.globl main
#main: 	print_str(askInput)
#	read_int($t1)
#	print_str(response)
#	print_reg_int($t1)
#	exit
