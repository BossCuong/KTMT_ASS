.data

nhap_so_1:        .asciiz "Nhap so thu nhat: "
nhap_so_2:        .asciiz "Nhap so thu hai : "

.text
.globl input
# input nhap
#
# param a0 = address input 1
# param a1 = address input 2
# out      = none
#
input:
addiu $t0, $a0, 0       # address input 1
addiu $t1, $a1, 0       # address input 2

# First input
li $v0, 4
la $a0, nhap_so_1
syscall

li $v0, 5
syscall
sw $v0, 0($t0)

# Last input
li $v0, 4
la $a0, nhap_so_2
syscall

li $v0, 5
syscall
sw $v0, 0($t1)

jr $ra