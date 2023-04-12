#include <detpic32.h>  //com o pcompile funciona

void delay(unsigned int ms)
{
	resetCoreTimer();
	while (readCoreTimer() < 20000 * ms); // delay ms miliseconds
}

int main(void)
{
	int cnt1 = 0;	//incremento a 1Hz
	int cnt5 = 0;	//incremento a 5Hz
	int cnt10 = 0;	//incremento a 10Hz

	while(1)
	{
		delay(100);	//100ms = 10Hz
		cnt10++;
		if(cnt10 % 2 == 0)cnt5++;
		if(cnt10 % 10 == 0)cnt1++;
		printInt(cnt1, 10 | 5 << 16); //?: em assembly tem que se colocar o codigo correspondente
		putChar('\t');
		printInt(cnt5, 10 | 5 << 16);
		putChar('\t');
		printInt(cnt10, 10 | 5 << 16);
		putChar('\r');
	}
	return 0;
}