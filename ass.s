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

# output2 chia
lw $a0, 4($fp)
lw $a1, 8($fp)
addiu $a2, $fp, 16 #Quotient
addiu $a3, $fp, 20 #Remainder
jal chia

# xuat ket qua
li $v0,1
lw $a0,16($fp)
syscall

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



#
# param a0  = input 1
# param a1  = input 2
# param a2  = address answer
# out   *a2 = input 1 * input 2
#
nhan:
addiu $sp, $sp, -24
addiu $fp, $sp, 0

addi $t0, $a0, 0 # input 1
addi $t1, $a1, 0 # input 2
addi $t2, $a2, 0 # address output

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
      lw $a0, 16($fp)         # input 1
      addiu $sp, $sp, -4      # prepare jump
      sw $ra, 4($sp)
      jal isodd
      lw $ra, 4($sp)          # get old $ra
      addiu $sp, $sp, 4

      beqz $v0, even_mul      # if even, skip add

            lw $t0, 20($fp)         # input 2
            lw $t1, 24($fp)         # address answer
            lw $t2, 0($t1)          # answer
            add $t2, $t2, $t0
            sw $t2, 0($t1)          # store answer in address

      even_mul:

      lw $t0, 16($fp) # input 1
      lw $t1, 20($fp) # input 2

      # if (input 1 == 1) break
      li $t2, 1
      beq $t0, $t2, loop_mul_end

      # if (input 1 == -1) break
      li $t2, -1
      beq $t0, $t2, loop_mul_end

            # shift and store
            sll $t1, $t1, 1
            
            # problem
            # -5 / 2 = -3
            # 5  / 2 =  2
            # sra $t0, $t0, 1

            bgtz $t0, shift_positive

                  sub $t0, $0, $t0
                  sra $t0, $t0, 1
                  sub $t0, $0, $t0
                  j shift_mul

            shift_positive:
            sra $t0, $t0, 1

            shift_mul:
            sw $t0, 16($fp)
            sw $t1, 20($fp)

      j loop_mul
loop_mul_end:

      lw $a0, 4($fp)    # input 1
      lw $a1, 8($fp)    # input 2
      lw $a2, 12($fp)   # address answer

      addiu $sp, $sp, -4      # prepare jump
      sw $ra, 4($sp)
      jal xetdau
      lw $ra, 4($sp)          # get old $ra
      addiu $sp, $sp, 4

      j exit_mul

zero_mul:
      sw $t0, 12($fp)   # address answer
      sw $0, 0($t0)     # store 0 in answer

exit_mul:
addiu $sp, $sp, 24
addiu $fp, $sp, 0
jr $ra
##############################################

#########
#
# input a0
# out   v0 = a0 % 2 == 1 => 1
#          = a0 % 2 == 0 => 0
isodd:
addi $t0, $a0, 0         # input 1
addi $v0, $0, 0          # answer

andi $t3, $t0, 0x01      # get last bit
bgtz $t3, odd            # neu $t3 le
jr $ra

odd:
addi $v0, $0, 1
jr $ra


#
# param a0  = input 1
# param a1  = input 2
# param a2  = address answer
# out   *a2 = -a2 => input 1 < 0
#           = a2
#
xetdau:

addi $t0, $a0, 0        # input 1
addi $t1, $a1, 0        # input 2
addi $t2, $a2, 0        # dia chi ket qua
lw $t3, 0($t2)          # gia tri ket qua
bgtz $t0, ip1_duong     # if input 1 > 0
j ip1_am

ip1_duong:
      jr $ra

ip1_am:
      sub $t3, $0, $t3
      sw $t3, 0($t2)

jr $ra


chia:
addiu $sp, $sp, -32
addiu $fp, $sp, 0

addi $t0, $a0, 0 # input 1
addi $t1, $a1, 0 # input 2
addi $t2, $a2, 0 # address quotient
addi $t3, $a3, 0 #address of remainder

# copy of params
sw $t0, 4($fp)
sw $t1, 8($fp)
sw $t2, 12($fp)
sw $t3, 16($fp)
# store to use from stack
sw $t0, 20($fp) # input 1 copy dividend
sw $t1, 24($fp) # input 2 copy divisor
sw $0,  28($fp) # quotient
sw $t0, 32($fp) # remainder

lw   $t0,20($fp)     #check dividend
beqz $t0,zero_div    #if dividend = 0
lw   $t0,24($fp)     #check divisor
beqz $t0,exception   #if divisor = 0 thrown exception

sll $t0,$t0,16 #Shift divisor to left half of register
sw  $t0,24($fp) 

addiu $t8,$0,17 #count variable

div_loop:
lw   $t0,24($fp)   #divisor
lw   $t1,32($fp)   #remainder
subu $t1,$t1,$t0   #rem = rem - div
sw   $t1,32($fp)   #store to remainder


#if remainder < 0
    bltz $t1,remainder_less_than_zero 
#else
    #shift quotient to the left
    lw $t0,28($fp)
    #set rightmost bit to 1
    sll $t0,$t0,1
    addiu $t0,$t0,1
    sw $t0,28($fp)
set_for_next_loop:
#shift divisor right
lw $t0,24($fp)
srl $t0,$t0,1
sw $t0,24($fp)

addiu $t8,$t8,-1
beqz $t8,exit_div


j div_loop

remainder_less_than_zero:
lw $t0,24($fp)   #divisor
lw $t1,32($fp)   #remainder
addu $t1,$t1,$t0 #rem = rem + div
sw $t1,32($fp)   #store to remainder

#shift quotient to the left
lw $t0,28($fp)
sll $t0,$t0,1
sw $t0,28($fp)
j set_for_next_loop

zero_div:
sw $0,28($fp)
j exit_div

exception:
j exit_div

exit_div:
lw $v0,28($fp)
sw $v0,0($a2)
lw $v1,32($fp)
sw $v0,0($a3)
addiu $sp, $sp, 32
addiu $fp, $sp, 0
jr $ra
