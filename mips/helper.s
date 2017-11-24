.data

endl_str: .asciiz "\n"

.text
.globl endl strlen



endl:
li $v0, 4
la $a0, endl_str
syscall
jr $ra


#
# param a0 = address of string
# out   v0 = string length
#
strlen:


jr $ra