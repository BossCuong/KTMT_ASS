.text
.globl divide
#
# param a0  = input 1
# param a1  = input 2
# param a2  = address Quotient
# param a3  = address Remainder
# out   *a2 = input 1 / input 2
# out   *a3 = input 1 mod input 2
#
divide:
addiu $sp, $sp, -28
addiu $fp, $sp, 28

addi $t0, $a0, 0        # input 1
addi $t1, $a1, 0        # input 2
addi $t2, $a2, 0        # address quotient
addi $t3, $a3, 0        # address remainder

# copy of params
sw $a0, 0($fp)
sw $a1, -4($fp)
sw $a2, -8($fp)
sw $a3, -12($fp)

# store to use from stack
sw $t0, -16($fp)         # input 1 copy dividend
sw $t1, -20($fp)         # input 2 copy divisor
sh $0,  -24($fp)         # quotient
sh $t0, -26($fp)         # remainder

lw   $t0, -16($fp)       # check dividend
beqz $t0, zero_div      # if dividend = 0 go to zero_div
lw   $t0, -20($fp)       # check divisor
beqz $t0, exception     # if divisor == 0 thrown exception

#Absolute dividend/remainder and divisor
lw  $t0, -16($fp) 
abs $t0, $t0
sw  $t0, -16($fp)
sw  $t0, -28($fp)

lw  $t0, -20($fp)
abs $t0, $t0
sll $t0, $t0, 16        # Shift divisor to left half of register
sw  $t0, -20($fp) 

addiu $t8, $0, 17       # count variable


div_loop:
lw   $t0, -20($fp)       # divisor
lw   $t1, -28($fp)       # remainder
subu $t1, $t1, $t0      # remainder = remainder - divisor
sw   $t1, -28($fp)       # store remainder

bltz $t1, remainder_less_than_zero        # if remainder < 0
                                          # go to remainder_less_than_zero

    # shift quotient to the left
    lw $t0, -24($fp)
    # set rightmost bit to 1
    sll $t0, $t0, 1
    addiu $t0, $t0, 1
    sw $t0, -24($fp)


set_for_next_loop:
# shift divisor right
lw $t0, -20($fp)
srl $t0, $t0, 1
sw $t0, -20($fp)

addiu $t8, $t8, -1
beqz $t8, check_sign_bit      # if count == 0 go to check_sign_bit

      j div_loop


remainder_less_than_zero:
lw $t0, -20($fp)         # divisor
lw $t1, -28($fp)         # remainder
addu $t1, $t1, $t0      # remainder = remainder + divisor
sw $t1, -28($fp)         # store remainder

# shift quotient to the left
lw $t0, -24($fp)
sll $t0, $t0, 1
sw $t0, -24($fp)
j set_for_next_loop

zero_div:
sw $0, -24($fp)    # set quotient = 0
j exit_div

exception:
##############
j exit_div

check_sign_bit:
lw $t0, 0($fp)    # Dividend
lw $t1, -4($fp)    # Divisor

# if dividend or divisor < 0,set quotient = - quotient
bltz $t0, set_quotient
bltz $t1, set_quotient
# else
j exit_div

set_quotient:
lw $t0, -24($fp)
subu $t0, $0, $t0
sw $t0, -24($fp)

exit_div:
lw $v0, -24($fp)
sh $v0, 0($a2)
lw $v1, -28($fp)
sh $v1, 0($a3)

addiu $sp, $sp, 28
addiu $fp, $0, 0
jr $ra