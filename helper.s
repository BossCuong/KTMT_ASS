.data

endl_str: .asciiz "\n"

.text
.globl endl



endl:
li $v0, 4
la $a0, endl_str
syscall
jr $ra