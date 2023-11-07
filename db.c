#include "db.h"

int main(void) {
	WDTCTL  = WDTPW | WDTHOLD;                // Disable Watchdog
	BCSCTL1 = CALBC1_1MHZ;                    // Run @ 1MHz
	DCOCTL  = CALDCO_1MHZ;

	P1DIR = 0xFF;
	P1OUT = 0x00;
	P3DIR = 0xFF;
	P3OUT = 0x00;
	P2SEL &= ~(BIT6 | BIT7);
	P2SEL2&= ~(BIT6 | BIT7);
	P2DIR = 0xFF;
	P2OUT = 0x00;

	serial_init(9600);                        // Initialize Serial Comms
	__delay_cycles(250000);

	for (;;) {
		int j = 0;                            // Char array counter
		char line[42] = { 0 };                // Init empty array

		cio_print((char *) "> ");             // Display prompt
		char c = cio_getc();                  // Wait for a character

		while(c != '\r') {                    // until return sent then ...
			if(c == 0x08) {                   //  was it the delete key?
				if(j != 0) {                  //  cursor NOT at start?
					line[--j] = 0;            //  delete key logic
					cio_printc(0x08); cio_printc(' '); cio_printc(0x08);
				}
			} else {                          // otherwise ...
				line[j++] = c; cio_printc(c); //  echo received char
			}

			c = cio_getc();                   // Wait for another
		}

		cio_print("\n\r");

		char *token, *p = line;
		unsigned d, b;

		for (int i = 0; i < 2; ++i) {
			token = strsep(&p, " ");
			if (token == NULL) { break; }

			if (i == 0) {
				d = atoi(token);
			} else {
				b = atoi(token);
				P1OUT |= BIT0;
				// cio_printf("%i %i\n\r", d, b);
				unsigned offset = convert(d, b);
				cio_printf("%s\n\r", buf + offset);
				P1OUT &= ~BIT0;
			}
		}
	}

	return 0;
}

