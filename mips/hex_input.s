.data

buffer: .space 10       # 10 bytes, 10 characters
                        # max 8 char + 1 \n + 1 \0
.text
.globl hex_input

# hex_input
#
# param a0  = address of input
# out   *a0 = number in decimal
#
hex_input:
addiu $sp, $sp, -20
addiu $fp, $sp, 20


sw $a0, 0($fp)          # param copy
sw $0, -4($fp)          # answer
li $t0, 1
sw $t0, -8($fp)         # bitset init
sw $0, -12($fp)         # offset
sw $0, -16($fp)         # hex length

# input string
la $a0, buffer
li $a1, 10
li $v0, 8
syscall

# get string length
addiu $sp, $sp, -4
sw $ra, 4($sp)
jal strlen
lw $ra, 4($sp)
addiu $sp, $sp, 4

li $t0, 1
blt $v0, $t0, exit      # length < 1
li $t0, 8
bgt $v0, $t0, exit      # length > 8

addi $v0, $v0, -1
sw $v0, -16($fp)

# t0 is length to count down
loop:
      lw $t0, -16($fp)
      bltz $t0, return

      # get char at $t0 + buffer
      la $a0, buffer
      add $a0, $a0, $t0
      lb $a0, 0($a0)

      # get num equivalent
      addiu $sp, $sp, -4
      sw $ra, 4($sp)
      jal get_hex_num
      lw $ra, 4($sp)
      addiu $sp, $sp, 4

      lw $t1, -12($fp)        # get offset
      sllv $v0, $v0, $t1      # shift by offset
      addiu $t1, $t1, 4       # add 4
      sw $t1, -12($fp)        # store it back

      li $t1, 4               # load counter
      loop_4_times:
            beqz $t1, end_loop_4_times
            addi $t1, $t1, -1

            lw $t2, -8($fp)         # load bitset
            and $t3, $t2, $v0       # get status
            lw $t4, -4($fp)         # get ans

            beqz $t3, shift
            addu $t4, $t4, $t2      # add unsigned only
            sw $t4, -4($fp)

            shift:
                  sll $t2, $t2, 1
                  sw $t2, -8($fp)

            j loop_4_times

      end_loop_4_times:

      lw $t0, -16($fp)
      addi $t0, $t0, -1
      sw $t0, -16($fp)
      j loop

return:

lw $t0, -4($fp)         # get ans
lw $t1, 0($fp)          # get return address
sw $t0, 0($t1)          # store back

addiu $sp, $sp, 20
addiu $fp, $0, 0
jr $ra


#
# param a0 = char
# out   v0 = num equivalent to char
# exit on exception
#
get_hex_num:

li $t0, '0'
li $t1, '9'
li $t2, 'A'
li $t3, 'F'
li $t4, 'a'
li $t5, 'f'

blt $a0, $t0, exit            # < '0'
bgt $a0, $t5, exit            # > 'f'

ble $a0, $t1, number          # <= '9'

blt $a0, $t2, exit            # < 'A' and > '9' ????
ble $a0, $t3, upper_letter    # >= 'A' and =< 'F'

blt $a0, $t4, exit            # > 'F' and < 'a' ????
ble $a0, $t5, lower_letter    # >= 'a' and <= 'f'


lower_letter:
subu $v0, $a0, $t4
addu $v0, $v0, 10
j get_hex_num_end

upper_letter:
subu $v0, $a0, $t2
addu $v0, $v0, 10
j get_hex_num_end

number:
subu $v0, $a0, $t0
j get_hex_num_end

get_hex_num_end:
jr $ra


exit:
li $v0, 10
syscall