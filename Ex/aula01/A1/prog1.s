#Utilização do system call inkey() na implementação de um contador up/down de 8 bits,
#módulo 256. O valor do contador é atualizado a cada 0.5s (aproximadamente) e é mostrado
#no ecrã, em decimal e em binário (com o system call printInt()). O estado "up" ou
#"down" do contador é assegurado por uma máquina de estados simples, com 2 estados,
#controlada pelas teclas '+' e '-'.

#define UP		1
#define DOWN	0

#void wait(int);
#int main(void)
#{
#	int state = 0;
#	int cnt = 0;
#	char c;
#	do
#	{
#		putChar('\r');					// Carriage return character
#		printInt( cnt, 10 | 3 << 16 ); 	// 0x0003000A: decimal w/ 3 digits
#		putChar('\t');					// Tab character
#		printInt( cnt, 2 | 8 << 16 ); 	// 0x00080002: binary w/ 8 bits
#		wait(5);						// wait 0.5s
#		c = inkey();
#		if( c == '+' )
#			state = UP;
#		if( c == '-' )
#			state = DOWN;
#		if( state == UP )	
#			cnt = (cnt + 1) & 0xFF;		// Up counter MOD 256
#		else
#			cnt = (cnt - 1) & 0xFF;		// Down counter MOD 256
#	}while( c != 'q' );
#	return 0;
#}
#
#void wait(int ts)
#{
#	int i;
#	for(i=0; i < 515000 * ts; i++); 	// wait approximately ts/10 seconds
#}


