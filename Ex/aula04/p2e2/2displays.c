//Selecionando em sequência o display menos significativo e o display mais significativo
//envie para os portos RB8 a RB14, em ciclo infinito e com uma frequência de 2 Hz, a
//sequência binária que ativa os segmentos do display pela ordem a, b, c, d, e, f, g, a, ...; a
//frequência de 2 Hz deve ser controlada usando a função delay().

#include <detpic32.h>

void delay(int ms){
	resetCoreTimer();
	while (readCoreTimer() < 20000 * ms);
}
int main(void)
{
	unsigned char segment;
	// enable display low (RD5) and disable display high (RD6)
	TRISDbits.TRISD5 = 1;
	TRISDbits.TRISD6 = 0;
	// configure RB8-RB14 as outputs
	TRISB &= 0x80FF
	// configure RD5-RD6 as outputs
	TRISD
	while(1){
		segment = 1;
		for(i=0; i < 7; i++){
			// send "segment" value to display
			// wait 0.5 second
			segment = segment << 1;
		}
		// toggle display selection
	}
return 0;
}