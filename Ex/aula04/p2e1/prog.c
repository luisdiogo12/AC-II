
#include <detpic32.h>

int main(void){

	// RB8-RB14 as outputs(leds) and RD5 and RD6 as outputs (para definir os displays a usar)
	//!: n percebo pq que sao defenidos como outputs sendo que valores são escritos em LATE
	TRISB = TRISB & 0x80FF;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 1;	// display mais significativo ativo

	// selecionar apenas o display5 (o menos), "Os dois transístores (Q2 e Q3) funcionam como inversores, o que significa que para se ativar o
	//display mais significativo é necessário atribuir o valor lógico 1 ao porto RD6 "
	LATDbits.LATD5 = 1;
	LATDbits.LATD6 = 0; 

	while(1){
		char read = getChar();
		//!: bruteforce
		/* if ( (read >= 'a' && read <= 'g') || (read >= 'A' && read <= 'G') )
		{
			if (read == 'a' || read == 'A') LATB = (LATB & 0x80FF) | 0x0100;
			else if (read == 'b' || read == 'B') LATB = (LATB & 0x80FF) | 0x0200;
			else if (read == 'c' || read == 'C') LATB = (LATB & 0x80FF) | 0x0400;
			else if (read == 'd' || read == 'D') LATB = (LATB & 0x80FF) | 0x0800;
			else if (read == 'e' || read == 'E') LATB = (LATB & 0x80FF) | 0x1000;
			else if (read == 'f' || read == 'F') LATB = (LATB & 0x80FF) | 0x2000;
			else if (read == 'g' || read == 'G') LATB = (LATB & 0x80FF) | 0x4000;
		} */
		//!: maneira inteligente, tenho que perceber
		read = read & 0x07;		
		//printf("read = %d\n", read);
		int value = 1 << (read - 1);
		//printf("value = %d\n", value);
		LATB = (LATB & 0x80FF) | (value << 8);
	}


}
