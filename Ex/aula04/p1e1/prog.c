#include <detpic32.h>

void delay(int ms)
{
	for (; ms > 0; ms--)
	{
		resetCoreTimer();
		readCoreTimer();
		while (readCoreTimer() < 20000)
			;
	}
}

int main(void)
{

	// Configure port RC14 as output
	LATCbits.LATC14 = 0; // Reset RC14 port value
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