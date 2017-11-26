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
addi $t0, $a0, 0        # move pointer
li $t1, 0               # counter

strlen_loop:
      lb $t2, 0($t0)
      beqz $t2, strlen_return
      addi $t1, $t1, 1
      addi $t0, $t0, 1
      j strlen_loop

strlen_return:
addi $v0, $t1, -1
jr $ra
