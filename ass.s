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

# output1 nhan
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
addiu $sp, $sp, -24
addiu $fp, $sp, 0

lw $t0, (0)$a0 # input 1
lw $t1, (0)$a1 # input 2
lw $t2, (0)$a2 # address output

# copy of params
sw $t0, 4($fp)
sw $t1, 8($fp)
sw $t2, 12($fp)

# store to use from stack
sw $t0, 16($fp) # input 1 copy
sw $t1, 20($fp) # input 2 copy
sw $t2, 24($fp) # address output


lw $t0, 16($fp)
beqz $t0, zero_mul

lw $t0, 20($fp)
beqz $t0, zero_mul

loop_mul:

	# check if input 1 is odd?
	lw $t0, 16($fp) # input 1
	addi $a0, $0, $t0 # load param for isodd
	addiu $sp, $sp, -4 # prepare jump
	sw $ra, 4($sp)
	jal isodd
	lw $ra, 4($sp) # get old $ra
	addiu $sp, $sp, 4
	
	beqz $v0, even_mul # if even
	
	lw $t0, 20($fp) # input 2
	lw $t1, 24($fp) # address answer
	lw $t2, 0($t1)  # answer
	add $t2, $t2, $t0
	sw $t2, 0($t1) # store answer in address
	
	
	even_mul:

	lw $t0, 16($fp) # input 1
	lw $t1, 20($fp) # input 2
	
	# if (input 1 == 1) break
	li $t2, 1
	beq $t0, $t2, loop_mul_end
	
	sll $t1, $t1, 2
	srl $t0, $t0, 2
	
	sw $t0, 16($fp)
	sw $t1, 20($fp)
	
	j loop_mul


loop_mul_end:
	lw $a0, 4($fp) # input 1
	lw $a1, 8($fp) # input 2
	lw $a2, 12($fp) # address answer
	jal xetdau
	j exit_mul

zero_mul:
	sw $t0, 12($fp)
	sw $0, 0($t0)

exit_mul:
addiu $sp, $sp, 24
addiu $fp, $sp, 0
jr $ra


chia:

jr $ra
