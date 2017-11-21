.data

ketqua_nhan:      .asciiz "Tich hai so la  : "
ketqua_chia:      .asciiz "Thuong hai so la: "
ketqua_du:        .asciiz "Du sau khi chia : "
hex:              .asciiz "Hexa            : "
dec:              .asciiz "Decimal         : "

.text
.globl output

# output
#
# param a0  = address mul
# param a1  = address Quotient
# param a2  = address Remainder
# param a3  = address Hex flag
# out       = none
#
output:

addiu $sp, $sp, -12
addiu $fp, $sp, 12

# copy of params --- skip

# copy of value
sw $a0, 0($fp)
sh $a1, -4($fp)
sh $a2, -6($fp)
sh $a3, -8($fp)
# waste 2 bytes

lw $t0, 0($a0)    # mul
lh $t1, 0($a1)    # Quotient
lh $t2, 0($a2)    # Remainder
lh $t3, 0($a3)    # Hex flag

bnez $t3, hexa_print    # if hex flag is set
                        # go to hexa_print

# ket qua tich
li $v0, 4
la $a0, ketqua_nhan
syscall

addi $a0, $t0, 0
li $v0, 1
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

#ket qua chia
li $v0, 4
la $a0, ketqua_chia
syscall

addi $a0, $t1, 0
li $v0, 1
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

#ket qua du
li $v0, 4
la $a0, ketqua_du
syscall

addi $a0, $t2, 0
li $v0, 1
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

j exit

hexa_print:

# ket qua tich
li $v0, 4
la $a0, ketqua_nhan
syscall

addi $a0, $t0, 0
li $v0, 34
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

#ket qua chia
li $v0, 4
la $a0, ketqua_chia
syscall

addi $a0, $t1, 0
li $v0, 34
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

#ket qua du
li $v0, 4
la $a0, ketqua_du
syscall

addi $a0, $t2, 0
li $v0, 34
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

exit:
addiu $sp, $sp, 12
addiu $fp, $0, 0
jr $ra