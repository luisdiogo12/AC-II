#include <detpic32.h>

int main(void)
{

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

	LATE = LATE & 0xFFF0;	// Force 0 as the outpu
	TRISE &= 0xFF87;		// forcar com que os bits 3-6 sejam 0
	int cont = 0;

	while (1)
	{	//POR OS BITS  do LATE 3-6 A 0 | dar shift de 3 para a esquerda para o count ficar registado nos bits 3-6
		LATE = (LATE & 0xFF87) | ((cont & 0x000F) << 3);
		delay(250);
		cont++;
		if (cont >= 10) {cont = 0};
	}
	return 0;
}