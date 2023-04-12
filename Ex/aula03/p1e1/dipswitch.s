# porto RE0 como saida e RB0 como entrada
# em ciclo infinito leia o valor do porto de entrada e escreva esse valor no porto de saida (RE0 = RB0)

	.equ 	BASE , 0xBF88			#?: 16 MSbits of SFR area
	.equ 	TRISE, 0x6100			#?: TRISE address is 0xBF886100
	.equ 	PORTE, 0x6110			#?: PORTE address is 0xBF886110
	.equ 	LATE , 0x6120			#?: LATE address is 0xBF886120
	.equ	TRISB, 0x6040
	.equ	PORTB, 0x6050
	.equ	LATB , 0x6060
	.data
	.text
	.globl main:
main:

	lui		$t0 , BASE				#!: $t0 = 0xBF880000, a base fica mesmo com este valor ou quando se faz
									#!: lw TRISE(BASE) é uma concatenação e não uma soma

	lw		$t1 , TRISE($t0)
	andi	$t1 , $t1 , 0xFFFE		#?: com o and conserva os outros bits mas muda/matem o ultimo = 0
	sw		$t1 , TRISE($t0)		# tristate RE0 como saida/output

	lw		$t1 , TRISB($t0)		# $t1 = conteudo no addr BASE+TRISE #?:Imm(Rsrc) = (Rsrc) + Imm
	ori		$t1 , $t1 , 0x0001		#?: com o or conserva os outros bits mas muda/mantem o ultimo = 1
	sw		$t1 , TRISB($t0)		# tristate RB0 como entrada/input

loop:
	lw		$t1 , PORTB($t0)		# $t1 = output de RB0 (defenido anteriormente como output)
	lw		$t2 , LATE($t0)			# $t2 = ler valor do porto configurado como entrada

								
	andi	$t1 , $t1 , 0x0001		#?: $t1 = 0000 0000 0000 000x sendo x = valor proveniente de RB0
	#!: penso que a linha seguinte n é necessária porque o or já vai conservar os bits de RE pois $t1 já está cheio de 0s
	andi	$t2 , $t2 , 0xFFFE		#?: $t2 = yyyy yyyy yyyy yyy0 sendo y = valor proveniente de RE
	or		$t2 , $t2 , $t1			#?: $t2 = yyyy yyyy yyyy yyyx sendo y proveniente de RE e x proveniente de RB

	sw		$t2 , LATE($t0)			#?: guarda $t2 no registo para escrever o valor num porto configurado como entrada

	j 		loop
	jr 		$ra