#include <detpic32.h>

int main(void)
{
	// Configure Timer T3 (2 Hz with interrupts disabled)
	T3CONbits.TCKPS = 4; // 1:16 prescaler (i.e. fout_presc = 625 KHz)
	PR3 = 62499;		 // Fout = 20MHz / (16 * (62499 + 1)) = 2 Hz
	TMR3 = 0;			 // Clear timer T3 count register
	T3CONbits.TON = 1;	 // Enable timer T3 (must be the last command of the
						 // timer configuration sequence)

	// IPC3bits.T3IP = 2; 		// Interrupt priority (must be in range [1..6])
	// IEC0bits.T3IE = 1;		// Enable timer T2 interrupts
	// IFS0bits.T3IF = 0;		// Reset timer T2 interrupt flag

	while (1)
	{
		while (IFS0bits.T3IF == 0)	//?:polling
			;			   // Wait while T3IF = 0
		IFS0bits.T3IF = 0; // Reset T3IF
		putChar('.');
	}
	return 0;
}
