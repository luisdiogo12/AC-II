
#include <detpic32.h>

volatile int count =0;

int main(void)
{
	//?: a frequencia minima que o timmer consegue executar é 1,192 Hz com o PRESC = 7(256) e PR = 65535
	// Configure Timer T3 with interrupts enabled
	T3CONbits.TCKPS = 5; // 1:16 prescaler (i.e. fout_presc = 625 KHz)
	PR3 = 62499;		 // Fout = 20MHz / (16 * (62499 + 1)) = 2 Hz
	TMR3 = 0;			 // Clear timer T3 count register
	T3CONbits.TON = 1;	 // Enable timer T3 (must be the last command of the
						 // timer configuration sequence)

	IPC3bits.T3IP = 2; // Interrupt priority (must be in range [1..6])
	IEC0bits.T3IE = 1; // Enable timer T3 interrupts
	IFS0bits.T3IF = 0; // Reset timer T3 interrupt flag

	EnableInterrupts();
	while (1)
		;
	return 0;
}

void _int_(12) isr_T3(void)
{ // Replace VECTOR by the timer T3 vector number (12)
	count ++;
	if (count == 2){		//?: por cada interrupção do counter, pois o counter tem frequencia minima de 2Hz
		putChar('.');
		count = 0;
	}
	IFS0bits.T3IF = 0; // Reset T3 interrupt flag
}