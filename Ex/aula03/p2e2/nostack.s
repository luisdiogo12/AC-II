	.equ	READ_CORE_TIMER , 11
	.equ	RESET_CORE_TIMER , 12
	.equ 	BASE , 0xBF88
	.equ 	TRISE, 0x6100	
	.equ 	PORTE, 0x6110
	.equ 	LATE , 0x6120
	.equ	TRISB, 0x6040
	.equ	PORTB, 0x6050
	.equ	LATB , 0x6060
	.data
	.text
	.globl main
# Mapa de registos
# $s0 - BASE
# $s1 - counter
# $s2 - input switch RB3-RB1 ---   cres/desc
# $s3 - ms
main:

	lui		$s0 , BASE
	# lê B(PORT) e escreve no E(LAT)
	lw		$s1 , TRISE($s0)
	andi	$s1 , $s1 , 0xFFE1		#?:RE4-RE1(leds) como output -> $t1 = $t1 & 1111 1111 1110 0001 = xxxx xxxx xxx0 000x
	sw 		$s1 , TRISE($s0)		#?: save do valor para defenir

	lw 		$s1 , TRISB($s0)
	ori		$s1 , $s1 , 0x000E		# 0000 0000 0000 1110
	sw		$s1 , TRISB($0)			#?:RB1-RB3 defenidos como input(na maquina, são switches)

	lw		$s1 , PORTB($s0)		# $s1 = conteudo RB
	andi	$s2 , $s1 , 0x0008		# $s2 = RB3 = 0000 0000 0000 x000
	srl		$s2 , $s2 , 3			# $s2 = 0000 0000 0000 0000 000x
	li		$s3 , 500				
	j		counter4bits			# counter(500(2Hz) , RB3)
endc:
	jr		$ra

counter4bits: # 0-15
	move	$s0 , $a0				# delay entre contagem
	bne		$s2 , 1 , if
	li		$t2 , 0
	li		$t3 , 1
	li		$t4 , 15
	j		loop		
if:	
	li		$t2 , 15
	li		$t3 , -1
	li		$t4 , 0
loop:		
write:
	#+: exemplo de escrita com deslocamento no registo 
	lw		$t5 , LATE($s0)			# $t5 = LATE
	andi	$t5 , $t5 , 0xFFE1		# RE4-RE1 = 0
	sll		$t6 , $t2 , 1			# $t6 = xxxx0 , x pertece a $t2(é preciso guardar o valor deste para continuar a contagem)
	or		$t5 , $t6 , $t2			# $t5 = yyyy yyyy yyyx xxxy sendo x o valor do counter e y valores do LATE inalterados
	j 		delay					#?: se jal n funcionar optar por li(load imm com imm o add do target) e depois jr(com $registo o do li)
	add		$t2 , $t2 , $t3			# $t2 = $t2 + $t6(1 ou -1)
	bne		$t2 , $t4 , loop			# if $t2 != $t7(0 ou 15) goto loop
	j 		endc

	#+:void delay(unsigned int ms)
delay:
	li	$v0, RESET_CORE_TIMER
	syscall
	
while:	li	$v0, READ_CORE_TIMER
	syscall
	
	li	$t0, 20000
	mul	$t0, $t0, $s3
	
	bge	$v0, $t0, endw
	j	while
endw:
	jr	$ra
