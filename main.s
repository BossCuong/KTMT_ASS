.data

nhap_so_1:        .asciiz "Nhap so thu nhat: "
nhap_so_2:        .asciiz "Nhap so thu hai:  "
ketqua_nhan:      .asciiz "Tich hai so la:   "
ketqua_chia:      .asciiz "Thuong hai so la: "
ketqua_du:        .asciiz "Du sau khi chia:  "


.text
.globl main

main:

# Chuan bi stack
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

#
# param a0  = input 1
# param a1  = input 2
# param a2  = address answer
# out   *a2 = input 1 * input 2
#
lw $a0, 4($fp)
lw $a1, 8($fp)
addiu $a2, $fp, 12
jal nhan

#
# param a0  = input 1
# param a1  = input 2
# param a2  = address Quotient
# param a3  = address Remainder
# out   *a2 = input 1 / input 2
# out   *a3 = input 1 mod input 2
#
lw $a0, 4($fp)
lw $a1, 8($fp)
addiu $a2, $fp, 16
addiu $a3, $fp, 20
jal chia

# xuat ket qua


addiu $sp, $sp, 20
addiu $fp, $sp, 0
# exit
li $v0, 10
syscall
