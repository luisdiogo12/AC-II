#include <detpic32.h>

int main(void)
{
	// T1(Prescaler = 1, 8, 64 ou 256)a gerar interrupções a 5Hz
	T1CONbits.TCKPS = 3; // 1:64 prescaler (i.e. fout_presc =  KHz)
	PR1 = 62499;		 // Fout = 20MHz / (64 * (62499 + 1)) = 5 Hz
	TMR1 = 0;			 // Clear timer T3 count register
	T1CONbits.TON = 1;	 // Enable timer T3 (must be the last command of the
						 // timer configuration sequence)

	// T3 a gerar interrupções a 25Hz
	T3CONbits.TCKPS = 4; // 1:16 prescaler (i.e. fout_presc = 625 KHz)
	PR3 = 50000;		 // Fout = 20MHz / (16 * (50000 + 1)) = 25 Hz
	TMR3 = 0;			 // Clear timer T3 count register
	T3CONbits.TON = 1;	 // Enable timer T3 (must be the last command of the
						 // timer configuration sequence)

	IPC1bits.T1IP = 1; // Interrupt priority (must be in range [1..6])
	IEC0bits.T1IE = 1; // Enable timer T3 interrupts
	IFS0bits.T1IF = 0; // Reset timer T3 interrupt flag

	IPC3bits.T3IP = 5; // Interrupt priority (must be in range [1..6])
	IEC0bits.T3IE = 1; // Enable timer T3 interrupts
	IFS0bits.T3IF = 0; // Reset timer T3 interrupt flag

	// portos RD0 e RD2 como saida e inicializados com o valor lógico 0
	// OC1 (RD0), OC2 (RD1), OC3 (RD2), OC4 (RD3), OC5 (RD4), INT4 (RD11), RB15 e RD7
	TRISDbits.TRISD0 = 0;
	TRISDbits.TRISD2 = 0;
	LATDbits.LATD0 = 1;
	LATDbits.LATD2 = 1;

	//Apenas para visualizar o que se passa nos regisitos RB
	//TRISEbits.TRISE1 = 0;
	//TRISEbits.TRISE3 = 0;
	//LATEbits.LATE1 = 0;
	//LATEbits.LATE3 = 0;

	EnableInterrupts(); // Global Interrupt Enable
	while (1)
		;
	return 0;
}


void _int_(4) isr_T1(void)
{
	LATDbits.LATD0 = !LATDbits.LATD0;
	// LATEbits.LATE1 = !LATEbits.LATE1;	//Apenas para visualizar o que se passa nos regisitos RB
	putChar('1');
	IFS0bits.T1IF = 0;
}

void _int_(12) isr_T3(void)
{ // Replace VECTOR by the timer T3 vector number (12)

	LATDbits.LATD2 = !LATDbits.LATD2;
	// LATEbits.LATE3 = !LATEbits.LATE3;	//Apenas para visualizar o que se passa nos regisitos RB
	putChar('3');
	IFS0bits.T3IF = 0; // Reset T3 interrupt flag
}

