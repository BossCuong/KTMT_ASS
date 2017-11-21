.data

decimal_mod:            .asciiz "1. Thap phan"
hexa_mod:               .asciiz "2. Ma hex"
thoat:                  .asciiz "3. Thoat"
chon_cach_nhap:         .asciiz "Chon cach nhap  : "
nhap_so_1_dec:          .asciiz "Nhap so thu nhat: "
nhap_so_2_dec:          .asciiz "Nhap so thu hai : "
nhap_so_1_hex:          .asciiz "Nhap so thu nhat: 0x"
nhap_so_2_hex:          .asciiz "Nhap so thu hai : 0x"

.text
.globl input
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
input:
addiu $sp, $sp, -12
addiu $fp, $sp, 12

# copy of params
sw $a0, 0($fp)
sw $a1, -4($fp)
sw $a2, -8($fp)

prompt:
li $v0, 4
la $a0, decimal_mod
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

li $v0, 4
la $a0, hexa_mod
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

li $v0, 4
la $a0, thoat
syscall

addiu $sp, $sp, -4      # prepare jump
sw $ra, 4($sp)
jal endl
lw $ra, 4($sp)          # get old $ra
addiu $sp, $sp, 4

li $v0, 4
la $a0, chon_cach_nhap
syscall

li $v0, 5
syscall

li $t0, 1
beq $v0, $t0, decimal_input

li $t0, 2
beq $v0, $t0, heximal_input

li $t0, 3
beq $v0, $t0, exit

# if input failed prompt again
j prompt


decimal_input:
# First input
li $v0, 4
la $a0, nhap_so_1_dec
syscall

li $v0, 5
syscall
lw $t0, 0($fp)    # address input 1
sw $v0, 0($t0)

# Last input
li $v0, 4
la $a0, nhap_so_2_dec
syscall

li $v0, 5
syscall
lw $t0, -4($fp)   # address input 2
sw $v0, 0($t0)

j return


heximal_input:
# set hex flag to one
lw $t0, -8($fp)         # address hex flag
li $t1, 1
sh $t1, 0($t0)

# First input
li $v0, 4
la $a0, nhap_so_1_hex
syscall

li $v0, 5
syscall
lw $t0, 0($fp)    # address input 1
sw $v0, 0($t0)

# Last input
li $v0, 4
la $a0, nhap_so_2_hex
syscall

li $v0, 5
syscall
lw $t0, -4($fp)   # address input 2
sw $v0, 0($t0)

return:
addiu $sp, $sp, 12
addiu $fp, $0, 0
jr $ra

exit:
li $v0, 10
syscall
