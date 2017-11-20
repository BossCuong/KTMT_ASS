.text
.globl input
# input nhap
#
# param a0 = address input 1
# param a1 = address input 2
# out      = none
#
input:
addiu $sp, $sp, -8
addiu $fp, $sp, 0

# First input
li $v0, 5
syscall
sw $v0, 0($a0)

# Last input
li $v0, 5
syscall
sw $v0, 0($a1)

addiu $sp, $sp, 8
addiu $fp, $sp, 0
jr $ra