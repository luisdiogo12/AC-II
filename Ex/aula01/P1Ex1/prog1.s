#int main(void){
#	printStr("AC2 – Aulas praticas\n"); // system call
#	return 0;
#}

		.equ	PRINT_STR,8
		.data
msg:	.asciiz	"AC2 – Aulas praticas\n"
		.text
		.globl 	main
main: 	la	$a0 , msg							#load address msg para $a0
		li	$v0 , PRINT_STR						#$v0 indica a função que o syscall vai executar
		syscall									# printStr("AC2 – Aulas praticas\n");
		li	$v0 , 0								# return 0;
		jr 	$ra	
