.data

buffer: .space 10       # 10 bytes, 10 characters

.text
.globl hex_input

# hex_input
#
# param a0  = address of input
# out   *a0 = number in decimal
#
hex_input:
addiu $sp, $sp, -4
addiu $fp, $sp, 4

# copy of params
sw $a0, 0($fp)



addiu $sp, $sp, 4
addiu $fp, $0, 4
jr $ra