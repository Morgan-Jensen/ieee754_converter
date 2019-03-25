# Author: Morgan Jensen
# Date:	3/22/2019
# Description:	IEEE conversion
.data
prompt:		.ascii "Morgan Jensen\nCS2810 Spring2019\n"
		.ascii "Welcome to the IEEE Parser\n"
		.asciiz "Enter a decimal number:\n"
bye:       	.asciiz "\nDo you want to do it again?."
ieee:          	.float 0  # input from user
ieee1:         	.word 0   # ieee sing component
ieee2:         	.word 0   # ieee exponent component
ieee3: 		.word 0	  # ieee unbiased exponent component
ieee4:         	.word 0   # ieee fraction/mantissa component
negSign:	.asciiz "\nNegative sign: "
expoBiased:	.asciiz "\nExpo with bias: " 
expoUnbiased:	.asciiz "\nExpo without bias: " 
manti:		.asciiz "\nMantissa: "
ieee754:	.asciiz "\nIEEE-754 Single Prec: " 

.text
main:
	jal TakeUserInput  # Take user input in DisplayBox
	lw $a0, ieee           # set argument 1: ieee
	jal PrintSign
	lw $a0, ieee           # set argument 1: ieee
	jal PrintExponent
	lw $a0, ieee2
	jal UnbiasedExponent
	lw $a0, ieee           # set argument 1: ieee
	jal PrintMantissa
	
	
	jal PrintIEEE
	li   $v0, 50           # Again? (in Display box)
	la   $a0, bye
	syscall
	beqz $a0, main  # check input to stay in loop
mainEnd: 
	li   $v0, 10           # exit
	syscall
################################################################
# Procedure void TakeUserInput()
# Functional Description: Take in a decimal value from the user
################################################################
# Register Usage:
TakeUserInput:
	
	li $v0, 52
	la $a0, prompt		# Popup Message
	syscall
	s.s $f0, ieee		# move input to ieee

TakeUserInputRet:
	jr $ra
################################################################
# Procedure void PrintSign(float ieee)
# Functional Description: Print the MSG for the sign
#          Sign 1 bit long: bit 31
################################################################
# Register Usage:
#          $a0: ieee value in 32-bit register
PrintSign:
	andi $a0, $a0, 0x80000000	# clear bits 30 - 0 by ANDing 10000000000000000000000000000000 (0x80000000)
	srl $a0, $a0, 31		# shift msb to be at bit 0 (ie. 00...0001 or 00....0000)
	sw $a0, ieee1
PrintSignRet:
	jr $ra
################################################################
# Procedure void PrintExponent(float ieee)
# Functional Description: Extract the exponenent component
#     8 bits long: bits 30-23
################################################################
# Register Usage:
#          $a0: ieee value in 32-bit register
PrintExponent:
	andi $a0, $a0, 0x7F800000	# isolate bits 30-23
	srl $a0, $a0, 23		# shift bits down to the end to get exponent value
	sw $a0, ieee2
PrintExponentRet:
	jr $ra
################################################################
# Procedure void UbiasedExponent(float ieee2)
# Functional Description:
#	Take in value of iee2 (exponent value)
#	Subract 127 to get unbiased exponent
################################################################
UnbiasedExponent:
	subi $a0, $a0, 127
	sw $a0, ieee3
UnbiasedExponentRet:
	jr $ra
################################################################
# Procedure void PrintMantissa(float ieee)
# Functional Description:
#     23 bits long: bits 22-0
################################################################
# Register Usage:
#          $a0: ieee value
#
PrintMantissa:
	andi $a0, $a0, 0x007FFFFF	# isolate bits 22-0
	sw $a0, ieee4
PrintMantissaRet:
jr $ra
################################################################
# Procedure void PrintIEEE(void) Extra Credit
# Functional Description:
#     Sign 1 bit long: bit 31
#     Exponent 8 bits long: bits 30-23
#     Mantissa 23 bits long: bits 22-0
################################################################
PrintIEEE:

	# Print Negative Sign
	li $v0, 4
	la $a0, negSign 	# "Negative sign: " 
	syscall
	
	li $v0, 34
	lw $a0, ieee1		# print hex value of sign bit (ieee1)
	syscall
	
	# Print Exponent
	li $v0, 4
	la $a0, expoBiased	# "Expo with bias: "
	syscall
	
	li $v0, 34
	lw $a0, ieee2		# print hex value of exponent (ieee2)
	syscall
	
	li $v0, 4
	la $a0, expoUnbiased	# "Expo without bias: "
	syscall
	
	li $v0, 34
	lw $a0, ieee3		# print hex value of unbiased exponent (ieee3)
	syscall
	
	# Print Mantisa
	li $v0, 4
	la $a0, manti		# "Mantissa: "
	syscall
	
	li $v0, 34
	lw $a0, ieee4		# print hex value of mantissa (ieee4)
	syscall
	
	# Print IEEE-754
	li $v0, 4
	la $a0, ieee754		# "IEEE-754 Single Prec: "
	syscall
	
	li $v0, 34
	lw $a0, ieee		# print hex value of ieee-754 (ieee)
	syscall
PrintIEEERet:
	jr $ra
	
	
