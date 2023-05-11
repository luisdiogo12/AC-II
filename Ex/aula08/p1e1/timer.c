#include <detpic32.h>

int main(void)
{
	T3CONbits.TCKPS = 5; 	// 1:32 prescaler (i.e. fout_presc = 625 KHz)
	PR3 = 62499;			// Fout = 20MHz / (32 * (62499 + 1)) = 10 Hz
	TMR3 = 0;				// Clear timer T2 count register
	T3CONbits.TON = 1;		// Enable timer T2 (must be the last command of the
							// timer configuration sequence)
	while(1)
	{
		// Wait while T3IF = 0
		// Reset T3IF
		putChar('.');
	}
	return 0;
}
