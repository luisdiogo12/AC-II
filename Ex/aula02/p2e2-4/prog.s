#O objetivo da função delay(), apresentada a seguir, é gerar um atraso temporal
#programável múltiplo de 1ms.

#void delay(unsigned int ms)
#{
#	resetCoreTimer();
#	while(readCoreTimer() < K * ms);  	#?: k = 20000 para representar ms
#}

	.equ	READ_CORE_TIMER, 11
	.equ	RESET_CORE_TIMER, 12
	.text
	.data
	.globl main

# Mapa de Registos
# $t0: cnt1
# $t1: cnt5
# $t2: cnt10
main:
	addiu	$sp , $sp , -8			#abrir espaço na pilha
	sw		$ra , 0($sp)			#guardar o $ra
	sw		$s0 , 4($sp)			#guardar o $s0

	#li		$s0 , 0					


#+:void delay(unsigned int ms)
delay:
	move	$t0 , $a0					#?: a variavel do metodo é intruduzida pelo $a0

	li		$v0 , RESET_CORE_TIMER
	syscall

while:
	li		$v0 , READ_CORE_TIMER
	syscall

	#!: dá para fazer mul com Imm??
	li		$t1 , 20000					#?: valor de k
	mul		$t0 , $t0 , $t1				# $t0 = ms*k #!:estas 2 linhas n podem ser fora do loop para n terem que ser sempre calculadas??

	blt		$v0, $t0, while				# if $v0 < $t0 then goto while
	
	jr		$ra
