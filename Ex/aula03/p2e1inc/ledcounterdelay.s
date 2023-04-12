#Nesta parte pretende-se a implementação, em assembly, de vários tipos de contadores. Para todos
#os exercícios o valor do respetivo contador deve ser observado nos 4 LED ligados aos
#portos RE4 a RE1 (esquema representado na Figura 3). Para o controlo da frequência deve ser
#usada a função delay() implementada na aula anterior.
#Para este tipo de exercício deve estruturar o seu código do seguinte modo:
#1. Configurar os portos; neste caso: RE4-RE1 como saídas (registo TRISE), e, quando se
#aplique, RB3, RB2 ou RB1 como entradas (registo TRISB).
#2. Inicializar a variável de contagem.
#3. Atualizar os portos de saída (RE4-RE1) com o valor da variável de contagem (registo
#LATE).
#4. Esperar t segundos, em que t = 1 / f (se t for múltiplo de 1ms pode usar a função
#delay(); caso contrário, deve usar diretamente os system calls de interação com o core
#timer, ajustando a constante de comparação em função do tempo pretendido).
#5. Atualizar a variável de contagem (em função do valor lido de um porto de entrada,
#quando isso for pedido).
#6. Repetir desde 3.

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
main:
	lui		$s0 , BASE
	lw		$t1 , TRISE($s0)
	andi	$t1 , $t1 , 0xFFE1		#?:RE4-RE1(leds) como saidas -> $t1 = $t1 & 1111 1111 1110 0001 = xxxx xxxx xxx0 000x
	sw 		$t1 , TRISE($s0)		#?: save do valor para defenir

	li		$s1 , 0					# counter = $s1 = 0	


	lw		$ra ,0($sp)				# repor $ra
	addiu	$sp , $s0p , 4			# repor espaco na stack
	jr 		$ra


	#+:void delay(unsigned int ms)
	#!: testar se dá pra fazer import no mesmo diretorio
delay:
	move	$t0 , $a0					#?: a variavel do metodo é intruduzida pelo $a0
	li		$v0 , RESET_CORE_TIMER
	syscall
	#!: dá para fazer mul com Imm??
	li		$t1 , 20000					#?: valor de k para ms devido à frequencia do timer(20MHz-2 ciclos de 40MHz)
	mul		$t0 , $t0 , $t1				# $t0 = ms*k #!: se estas duas linhas n funcionarem experimentar por depois do while
while:
	li		$v0 , READ_CORE_TIMER
	syscall
	blt		$v0, $t0, while				# if $v0 < $t0 then goto while
	
	jr		$ra

