#include <detpic32.h>

void delay(int ms);

int main(void)
{
	//printf("Started")
	//INT1 usa o pino RD8
	TRISDbits.TRISD8 = 1; // RD8 input
	TRISEbits.TRISE0 = 0; // RE0 output
	LATEbits.LATE0 = 0;
	while(1){ //!:recorrendo ao polling
		if(PORTDbits.RD8 == 0){
			LATEbits.LATE0 = 1;
			delay(3000);
			LATEbits.LATE0 = 0;
		}
	}

}

void delay(int ms)
{
	resetCoreTimer();
	while (readCoreTimer() < 20000 * ms)
		;
}
