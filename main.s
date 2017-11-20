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
addiu $fp, $sp, 20

# khai bao 2 bien input
sw $0, 0($fp)      # input 1 --- lhs
sw $0, -4($fp)     # input 2 --- rhs

# khai bao 3 bien output
sw $0, -8($fp)     # output 3 --- tich
sh $0, -12($fp)    # output 4 --- thuong
sh $0, -14($fp)    # output 5 --- du
sh $0, -16($fp)    # hex flag
# waste 2 bytes

# input
#
# param a0  = address input 1
# param a1  = address input 2
# param a2  = address hex flag
# out   *a0 = input 1 value
# out   *a1 = input 2 value
# out   *a2 = 1 => input hex
#           = 0 => input normal
#
addiu $a0, $fp, 0
addiu $a1, $fp, -4
addiu $sp, $sp, -4      # save current frame pointer
sw $fp, 0($sp)
jal input
lw $fp, 0($sp)          # get old frame pointer
addiu $sp, $sp, 4

# multiply
#
# param a0  = input 1
# param a1  = input 2
# param a2  = address answer
# out   *a2 = input 1 * input 2
#
lw $a0, 0($fp)
lw $a1, -4($fp)
addiu $a2, $fp, -8
addiu $sp, $sp, -4      # save current frame pointer
sw $fp, 4($sp) 
jal multiply
lw $fp, 4($sp)          # get old frame pointer
addiu $sp, $sp, 4

# divide
#
# param a0  = input 1
# param a1  = input 2
# param a2  = address Quotient
# param a3  = address Remainder
# out   *a2 = input 1 / input 2
# out   *a3 = input 1 mod input 2
#
lh $a0, 0($fp)
lh $a1, -4($fp)
addiu $a2, $fp, -12
addiu $a3, $fp, -14
addiu $sp, $sp, -4      # save current frame pointer
sw $fp, 4($sp) 
jal divide
lw $fp, 4($sp)          # get old frame pointer
addiu $sp, $sp, 4

# xuat ket qua


addiu $sp, $sp, 20
addiu $fp, $0, 0
# exit
li $v0, 10
syscall
