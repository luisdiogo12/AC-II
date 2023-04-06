#Teste dos system calls de leitura e impressão de inteiros.
#int main(void)
#{
#	int value;
#	while(1)
#	{
#		printStr("\nIntroduza um inteiro (sinal e módulo): ");
#		value = readInt10();
#		printStr("\nValor em base 10 (signed): ");
#		printInt10(value);
#		printStr("\nValor em base 2: ");
#		printInt(value, 2);
#		printStr("\nValor em base 16: ");
#		printInt(value, 16);
#		printStr("\nValor em base 10 (unsigned): ");
#		printInt(value, 10);
#		printStr("\nValor em base 10 (unsigned), formatado: ");
#		printInt(value, 10 | 5 << 16); // ver nota de rodapé 3
#	}
#	return 0;
#}

	.equ	PRINT_STR , 8
	.equ	PRINT_INT10 , 7
	.equ	PRINT_INT , 6
	.equ	READ_INT10 , 5
	.data
str1:	.asciiz		"\nIntroduza um inteiro (sinal e modulo): "
str2:	.asciiz		"\nValor em base 10 (signed): "
str3:	.asciiz		"\nValor em base 2: "
str4:	.asciiz		"\nValor em base 16: "
str5:	.asciiz		"\nValor em base 10 (unsigned): "
str6:	.asciiz		"\nValor em base 10 (unsigned), formatado: "
	.text
	.globl main
main:
while:
	la		$v0 , PRINT_STR
	la 		$a0 , str1
	syscall

	la		$v0 , READ_INT10
	syscall
	move	$t0 , $a0			# $t0 = value = readInt10()

	la		$v0 , PRINT_STR
	la 		$a0 , str2
	syscall

	la		$v0 , PRINT_INT
	la 		$a0 , $t0
	syscall

	la		$v0 , PRINT_STR
	la 		$a0 , str3
	syscall

	la		$v0 , PRINT_INT
	la 		$a0 , $t0
	la		$a1 , 2				#base 2
	syscall

	la		$v0 , PRINT_STR
	la 		$a0 , str4
	syscall

	la		$v0 , PRINT_INT
	la 		$a0 , $t0
	la		$a1 , 16			#base 16
	syscall

	la		$v0 , PRINT_STR
	la 		$a0 , str5
	syscall

	la		$v0 , PRINT_INT
	la 		$a0 , $t0
	la		$a1 , 10			#base 10
	syscall

	la		$v0 , PRINT_STR
	la 		$a0 , str6
	syscall

	la		$v0 , PRINT_INT
	la 		$a0 , $t0
	#!: 0x00040002 é para ( val, 2 | 4 << 16 ), aqui tem que ser (10 | 5 << 16)
	la		$a1 , 0x00040002			#nota do rodapé O system call printInt permite especificar o número mínimo de dígitos com que o valor é impresso.
										#Essa configuração é feita nos 16 bits mais significativos do registo usado para especificar a base da
										#representação (e.g., para a impressão em binário com 4 bits, o valor a colocar no registo $a1 é
										#0x00040002); em linguagem C: printInt( val, 2 | 4 << 16 ).
	syscall						#base 10 unsigned formatado

	j		while						#while(1)
	li		$v0 , 0						# return 0;
	jr		$ra