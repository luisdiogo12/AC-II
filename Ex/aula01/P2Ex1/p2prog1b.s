#O system call inkey() não é bloqueante, ou seja, se foi premida uma tecla devolve o
#respetivo código ASCII, mas se não foi premida qualquer tecla devolve o valor 0 (0x00).
#int main(void)
#{
#	char c;
#	do {
#		c = inkey();
#		if( c != 0 )
#			putChar( c );
#		else
#			putChar('.');
#	} while( c != '\n' );
#	return 0;
#}

	.equ	INKEY, 1
	.equ	PUT_CHAR, 3
	.data
	.text
	.globl 	main
main:
do:		
		la		$v0 , INKEY
		syscall
		move	$t0 , $v0			#c = $t0 = inkey()
		beq 	$t0 , 0 , else  	# if (c != 0)

		la		$v0 , PUT_CHAR		
		move	$a0 , $t0
		syscall						# putChar(c)
else:	

		la		$v0 , PUT_CHAR		
		li		$a0 , '.'
		syscall						# putChar(c)
while:
		bne		$t0 , '\n' , do		# while( c != '\n' );

			li	$v0, 0
			jr	$ra


		