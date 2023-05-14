// O objetivo do programa seguinte é fazer o toggle do bit 14 do porto C, ao qual está ligado um
//LED na placa DETPIC32, a uma frequência de 1 Hz(usando a função delay() já apresentada na aula anterior)
#include <detpic32.h>

void delay(int ms)
{
	resetCoreTimer();
	while (readCoreTimer() < 20000 * ms);
}

int main(void)
{

	// Configure port RC14 as output
	TRISCbits.TRISC14 = 0; // Configure RC14 port as output
	while (1)
	{
		// Wait 0.5s
		delay(500);
		// Toggle RC14 port value
		LATCbits.LATC14 = !LATCbits.LATC14;
	}
	return 0;
}