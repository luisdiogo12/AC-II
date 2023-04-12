
#Nesta parte pretende-se a implementação, em assembly, de vários tipos de contadores. Para todos
#os exercícios o valor do respetivo contador deve ser observado nos 4 LED ligados aos
#portos RE4 a RE1 (esquema representado na Figura 3). Para o controlo da frequência deve ser
#usada a função delay() implementada na aula anterior.
#Escreva o código assembly para implementar:
#1. Contador binário crescente de 4 bits, atualizado com uma frequência de 1Hz.
#2. Contador binário decrescente de 4 bits, atualizado com uma frequência de 4Hz.
#3. Contador binário crescente/decrescente cujo comportamento depende do valor lido do porto
#de entrada RB3: se RB3=1, contador crescente; caso contrário contador decrescente;
#frequência de atualização de 2 Hz.
#4. Contador em anel de 4 bits (ring counter) com deslocamento à esquerda ou à direita,
#dependendo do valor lido do porto RB1: se RB1=1, deslocamento à esquerda. Frequência
#de atualização de 3 Hz (deslocamento à esquerda: 0001, 0010, 0100, 1000, 0001, …).
#5. Contador Johnson de 4 bits (sequência: 0000, 0001, 0011, 0111, 1111, 1110, 1100,
#1000, 0000, 0001, ...), com uma frequência de atualização de 1.5 Hz; para implementar
#este contador observe que o bit a introduzir na posição menos significativa quando se faz o
#deslocamento à esquerda corresponde ao valor negado que o bit mais significativo tinha na
#iteração anterior.
#6. Contador de 4 bits com um comportamento idêntico ao contador de Johnson, mas com
#deslocamento à direita (sequência: 0000, 1000, 1100, 1110, 1111, 0111, 0011, 0001,
#0000, 1000, ...); frequência de atualização de 1.5 Hz (poderá usar um raciocínio análogo
#ao descrito na alínea anterior para a implementação deste contador).
#7. Contador Johnson de 4 bits com deslocamento à esquerda ou à direita, dependendo do
#valor lido do porto de entrada RB2: se RB2=1, deslocamento à esquerda; frequência de
#atualização de 1.5 Hz.
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
# $s2 - input switch RB3-RB1
main:
	#!: se fizer a pilha no inicio o registo vai ser sempre guardado mesmo sendo o seu valor alterado depois da pilha???
	addiu	$sp , $sp , -12			#abrir espaco da stack
	sw		$ra , 0($sp)			#guardar $ra na stack
	sw		$s0 , 4($sp)
	sw		$s1 , 8($sp)
	
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
	li		$a0 , 500				
	move	$a1 , $s2
	jal		counter4bits			# counter(500(2Hz) , RB3)

	#!: é mesmo necessário repor $s0 e $s1 sendo que n vao voltar a ser usados????
	lw		$ra , 0($sp)				# repor $ra
	lw		$s0 , 4($sp)
	lw		$s1 , 8($sp)
	addiu	$sp , $sp , 12			# repor espaco na stack
	jr 		$ra


#+:void counter4bits(unsigned int ms,boolean mon)
#mapa
#$t2	contador começa 0(incremento) ou 15(decremento)
#$t3 	soma de 1(incremento) ou -1(decremento)
#$t4	define	limite de 15(incremente) ou 0(decremento)
counter4bits: # 0-15
	addiu	$sp , $sp , -4		# abrir espaco da stack
	sw		$ra , 0($sp)		#guardar $ra na stack

	move	$s0 , $a0				# delay entre contagem
	move	$s1 , $a1				# natureza crescente(1)/decrescente(0)
	bne		$s1 , 1 , if
	li		$t2 , 0
	li		$t3 , 1
	li		$t4 , 15
	j		loop		
if:	
	li		$t2 , 15
	li		$t3 , -1
	li		$t4 , 0
loop:		
	jal		write		
	add		$t2 , $t2 , $t3			# $t2 = $t2 + $t6(1 ou -1)
	beq		$t2 , $t4 , end			# if $t2 == $t7(0 ou 15) goto endc
	j		loop						
write:
	#+: exemplo de escrita com deslocamento no registo 
	lw		$t5 , LATE($s0)			# $t5 = LATE
	andi	$t5 , $t5 , 0xFFE1		# RE4-RE1 = 0
	sll		$t6 , $t2 , 1			# $t6 = xxxx0 , x pertece a $t2(é preciso guardar o valor deste para continuar a contagem)
	or		$t5 , $t6 , $t2			# $t5 = yyyy yyyy yyyx xxxy sendo x o valor do counter e y valores do LATE inalterados
	move	$a0 , $t0				# é redundante mas é para entender
	jal 	delay					#?: se jal n funcionar optar por li(load imm com imm o add do target) e depois jr(com $registo o do li)
	j		loop					
end:
	lw		$ra ,0($sp)				# repor $ra
	addiu	$sp , $sp , 4			# repor espaco na stack
	jr 		$ra




	#+:void delay(unsigned int ms)
	#!: testar se dá pra fazer import no mesmo diretorio
delay:
	li	$v0, RESET_CORE_TIMER
	syscall
	
while:	li	$v0, READ_CORE_TIMER
	syscall
	
	li	$t0, 20000
	mul	$t0, $t0, $a0
	
	bge	$v0, $t0, endw
	j	while
endw:
	jr	$ra
