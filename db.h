#include <msp430.h>
#include <string.h>
#include <stdlib.h>
#include <libemb/serial/serial.h>
#include <libemb/conio/conio.h>

const char ASCII[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/";
char buf[42] = { 0 };

unsigned convert(unsigned decimal, unsigned base);

