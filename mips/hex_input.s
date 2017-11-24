.data

buffer: .space 10       # 10 bytes, 10 characters

.text
.globl hex_input

# hex_input
#
# param a0  = address of input
# out   *a0 = number in decimal
#
hex_input:
addiu $sp, $sp, -16
addiu $fp, $sp, 16


sw $a0, 0($fp)          # param copy
sw $0, -4($fp)          # answer
li $t0, 1
sw $t0, -8($fp)         # bitset init
sw $0, -12($fp)         # offset

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
add $t0, $v0, $0        # copy of length to use

# t0 is length to count down
loop:
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
            add $t4, $t4, $t2
            sw $t4, -4($fp)
            
            shift:
                  sll $t2, $t2, 1
                  sw $t2, -8($fp)

            j loop_4_times
      
      end_loop_4_times:

      addi $t0, $t0, -1
      j loop

return:

lw $t0, -4($fp)         # get ans
lw $t1, 0($fp)          # get return address
sw $t0, 0($t1)          # store back

addiu $sp, $sp, 16
addiu $fp, $0, 0
jr $ra


#
# param a0 = char
# out   v0 = num equivalent to char
# exit on exception
#
get_hex_num:

addi $a0, $a0, -48      # 48 is '0'
add $v0, $0, $a0

jr $ra


exit:
li $v0, 10
syscall