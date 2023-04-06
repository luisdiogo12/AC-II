# o contador de 32 bits é atualizado a cada dois ciclos. Sendo o CPU
# configurado a 40MHz o contador é incrementado a uma frequencia de 20MHz
# ou seja demora 1 seg para contar de 0 a 20 000 000
# apenas tem as intruções de resetCoreTimer() e readCoreTimer()

#int main(void)
#{
#	int counter = 0;
#	while(1)
#	{
#		resetCoreTimer();
#	while(readCoreTimer() < 200000);
#		printInt(counter++, 10 | 4 << 16);		// Ver nota1
#	putChar('\r');							// cursor regressa ao inicio da linha
#	}
#	return 0;
#}

	.equ	READ_CORE_TIMER , 11
	.equ	RESET_CORE_TIMER , 12
	.equ	PUT_CHAR , 3
	.equ	PRINT_INT , 6
	.data
	.text
	.globl main
main:
	li		$t0 , 0						# contador = $t0 = 0
while:
	la		$v0 , RESET_CORE_TIMER
	syscall							# resetCoreTimer();
while1:
	la		$v0 , READ_CORE_TIMER
	syscall
	move	$t1 , $v0
	bge		$t1 , 200000 , endw1	#branch se readCoreTimer() < 200000
	j		while1					#se n der brach jump para o while	
endw1:
	la		$v0 , PRINT_INT
	li		$a0 , $t0
	li		$a1 , 0x0004000A				
	syscall
	addiu	$t0 , $t0 , 1

	la	$v0 , PUT_CHAR
	li	$a0 , '\r'					#cursor regressa ao inicio da linha
	syscall

	j	while
	
	li	$v0, 0
	jr	$ra