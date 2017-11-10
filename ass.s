.data

nhap_so_1:        .asciiz "Nhap so thu nhat: "
nhap_so_2:        .asciiz "Nhap so thu hai:  "
ketqua_nhan:      .asciiz "Tich hai so la:   "
ketqua_chia:      .asciiz "Thuong hai so la: "
ketqua_du:        .asciiz "Du sau khi chia:  "


.text
.globl main


main:

addiu $sp, $sp, -20
addiu $fp, $sp, 0

# khai bao 2 bien input
sw $0, 4($fp) # input 1 --- lhs
sw $0, 8($fp) # input 2 --- rhs

# khai bao 3 bien output
sw $0, 12($fp) # output 3 --- tich
sw $0, 16($fp) # output 4 --- thuong
sw $0, 20($fp) # output 5 --- du


# input nhap
#
# param a0 = address input 1
# param a1 = address input 2
# out      = none
#
addiu $a0, $fp, 4
addiu $a1, $fp, 8
jal input

# output1 nhan
#
#
#
#
#
jal nhan

# output2 chia

jal chia

# xuat ket qua



# exit
li $v0, 10
syscall




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


nhan:



jr $ra



chia:

jr $ra