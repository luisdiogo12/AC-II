#include <detpic32.h>

volatile unsigned char voltage = 0;	//Globla variable

void delay(int ms);
void send2displays(char value);
int voltageConversion(int VAL_AD);
int toBcd(int value);

int main(void){
	unsigned int cnt = 0;

	TRISBbits.TRISB4 = 1;	 // RB4 digital output disconnected
	AD1PCFGbits.PCFG4 = 0;	 // RB4 configured as analog input (AN4)
	AD1CON1bits.SSRC = 7;	 // Conversion trigger constant
	AD1CON1bits.CLRASAM = 1; // Stop conversion when the 1st A/D converter intetupr is generated.
							 // At the same time, hardware clears ASAM bit
	AD1CON3bits.SAMC = 16;	 // Sample time is 16 TAD (TAD = 100ns)
	AD1CON2bits.SMPI = 0;	 // Interrupt is generated after 1 sample
	AD1CHSbits.CH0SA = 4;	 // analog channel input 4
	AD1CON1bits.ON = 1;		 // Enable the A/d configuration sequence

	// Enable interrupts ADC
	IPC6bits.AD1IP = 2; // configure priority of A/D interrupts
	IFS1bits.AD1IF = 0; // clear A/D interrupt flag
	IEC1bits.AD1IE = 1; // enable A/D interrupts

	EnableInterrupts(); //Global Interrupt Enable

	AD1CON1bits.ASAM = 1; // Start conversion

	while (1){ 
		if(cnt == 0)  //0, 200ms, 400ms, ...(5samples/second)
			AD1CON1bits.ASAM = 1;
		second2displays();
		cnt = (cnt + 1) % 20; // 5samples/second
		delay(10); //10ms para a cada 20x(200ms) reset (cnt=0) ficando assim 5 samples/second	
	}

	return 0;
}

// Interrupt handler
void _int_(27) isr_adc(void) // 27 for ACD
{
	// Read conversion result (ADC1BUF0) and print it
	int *p = (int *)&ADC1BUF0;
	int i, average = 0;

	for (i = 0; i < 8; i++)
		average += p[i * 4];

	//Conversão de A/D para Bcd
	voltage = toBcd(voltageConversion(average / 8));
	IFS1bits.AD1IF = 0;
}
int voltageConversion(int VAL_AD){return (VAL_AD * 33 + 511) / 1023;}

int toBcd(int value){return ((value / 10) << 4) + (value % 10);}

void delay(int ms){
	resetCoreTimer();
	while (readCoreTimer() < 20000 * ms);
}

void send2displays(char value)
{
	static const char display7Scodes[] = {
		0x3F, // 0
		0x06, // 1
		0x5B, // 2
		0x4F, // 3
		0x66, // 4
		0x6D, // 5
		0x7D, // 6
		0x07, // 7
		0x7F, // 8
		0x6F, // 9
		0x77, // A
		0x7C, // b
		0x39, // C
		0x5E, // d
		0x79, // E
		0x71  // F
	};

	static int displayFlag = 0;

	unsigned char dh = value >> 4;	 // Get the index of the decimal part
	unsigned char dl = value & 0x0F; // Get the index of the unitary part

	// Get the correct hex code for the number
	dh = display7Scodes[dh];
	dl = display7Scodes[dl];

	if (displayFlag == 0)
	{
		LATD = (LATD | 0x0040) & 0xFFDF;					// Dipslay High active and Display Low OFF
		LATB = (LATB & 0x80FF) | ((unsigned int)(dh)) << 8; // Clean the display and set the right value
	}
	else
	{
		LATD = (LATD | 0x0020) & 0xFFBF;					// Display High OFF and Display High active
		LATB = (LATB & 0x80FF) | ((unsigned int)(dl)) << 8; // Clean the display and set the right value
	}

	displayFlag = !displayFlag;
}
