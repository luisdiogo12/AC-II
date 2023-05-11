#include <detpic32.h>

void _int_(VECTOR) isr_adc(void)
{
	volatile int adc_value;
	LATDbits.LATD11 = 0;// Reset RD11 (LATD11 = 0)
	// Read ADC1BUF0 value to "adc_value"
	// Start A/D conversion
	// Set RD11
	(LATD11 = 1)
	// Reset AD1IF flag
}

int main(void)
{

	TRISDbits.TRISD11 = 1;

}

