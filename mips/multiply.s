.text
.globl multiply
#
# param a0  = input 1
# param a1  = input 2
# param a2  = address answer
# out   *a2 = input 1 * input 2
#
multiply:
addiu $sp, $sp, -24
addiu $fp, $sp, 24

# copy of params
sw $a0, 0($fp)
sw $a1, -4($fp)
sw $a2, -8($fp)

# store to use from stack
sw $a0, -12($fp) # input 1 copy
sw $a1, -16($fp) # input 2 copy
sw $a2, -20($fp) # address output


lw $t0, -12($fp)   # input 1 == 0 go to zero_mul
beqz $t0, zero_mul

lw $t0, -16($fp)   # input 2 == 0 go to zero_mul
beqz $t0, zero_mul

loop_mul:

      # check if input 1 is odd?
      lw $a0, -12($fp)        # input 1
      addiu $sp, $sp, -4      # prepare jump
      sw $ra, 4($sp)
      jal isodd
      lw $ra, 4($sp)          # get old $ra
      addiu $sp, $sp, 4

      beqz $v0, even_mul      # if even, skip add

            lw $t0, -16($fp)        # input 2
            lw $t1, -20($fp)        # address answer
            lw $t2, 0($t1)          # answer
            add $t2, $t2, $t0
            sw $t2, 0($t1)          # store back answer

      even_mul:

      lw $t0, -12($fp)        # input 1
      lw $t1, -16($fp)        # input 2

      # if (input 1 == 1) break
      li $t2, 1
      beq $t0, $t2, loop_mul_end

      # if (input 1 == -1) break
      li $t2, -1
      beq $t0, $t2, loop_mul_end

            # shift and store
            sll $t1, $t1, 1

            # sra $t0, $t0, 1
                  # problem
                  # -5 / 2 = -3
                  #  5 / 2 =  2

            bgtz $t0, shift_positive

                  sub $t0, $0, $t0
                  sra $t0, $t0, 1
                  sub $t0, $0, $t0
                  j shift_end_mul

            shift_positive:
            sra $t0, $t0, 1

            shift_end_mul:
            # store back
            sw $t0, -12($fp)
            sw $t1, -16($fp)

      j loop_mul
loop_mul_end:

      lw $a0, 0($fp)          # input 1
      lw $a1, -4($fp)         # input 2
      lw $a2, -8($fp)         # address answer

      addiu $sp, $sp, -4      # prepare jump
      sw $ra, 4($sp)
      jal xetdau
      lw $ra, 4($sp)          # get old $ra
      addiu $sp, $sp, 4

      j exit_mul

zero_mul:
      lw $t0, -8($fp)         # address answer
      sw $0, 0($t0)           # store 0 in answer

exit_mul:
addiu $sp, $sp, 24
addiu $fp, $0, 0
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
