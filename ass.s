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
# input1
# input2
# output1 nhan
# output2 chia
# output3 du
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

isodd:
lw $t0,0($a0) #input 1
andi $t3,$t0,0x01
bgtz $t3,odd # neu $t3 le
addi $v0, $0,0
j out_isodd
odd:
addi $v0,$0,1
out_isodd:

jr $ra


xetdau:

lw $t0, 0($a0)		#input 1
lw $t1, 0($a1)		#input 2
lw $t2, 0($a2)		#dia chi ket qua
lw $t3, 0($t2) 		# gia tri ket qua
bgtz $t1, ip1_duong 	#so sanh input 1 vs 0
j ip1_am
ip1_duong: 		#input 1 duong
bgtz $t1, ip2_duong 	#so sanh input 2 vs 0
sub $t3,$0,$t3 		# input 2 am , input 1 duong
j out_xetdau 	
ip2_duong: 		#input 1 va 2 deu duong 
add $t3,$0,$t3
j out_xetdau
ip1_am: 			# th input 1 am
bgtz $t1,ip2d_ip1a 	#so sanh input2 vs 0
add $t3,$0,$t3 		#input 1 va 2 deu am
j out_xetdau
ip2d_ip1a:		#input 2 duong, input 1 am
sub $t3,$0,$t3

out_xetdau:
sw $t3,0($t2)
jr $ra			#thoat khoi ham
chia:

jr $ra
