#include "io.h"

/* UART print functions */
extern void print_string(const char *);
extern void print_hex(unsigned int);

/* SPI MMIO base */
#define SPI_BASE 0x00400000

#define SPI_CTRL    (*(volatile unsigned int *)(SPI_BASE + 0x00))
#define SPI_TXDATA  (*(volatile unsigned int *)(SPI_BASE + 0x04))
#define SPI_RXDATA  (*(volatile unsigned int *)(SPI_BASE + 0x08))
#define SPI_STATUS  (*(volatile unsigned int *)(SPI_BASE + 0x0C))

int main() {

    print_string("SPI Test Start\n");

    /* 1) Enable SPI, set clkdiv = 4 */
    SPI_CTRL = (1 << 0) | (4 << 8);

    /* 2) Load TX byte */
    SPI_TXDATA = 0xA5;

    /* 3) Start SPI (WRITE FULL CTRL WORD) */
    SPI_CTRL = (1 << 0) | (1 << 1) | (4 << 8);

    /* 4) Wait for DONE */
    while ((SPI_STATUS & (1 << 1)) == 0);

    /* 5) Read RX */
    unsigned int rx = SPI_RXDATA & 0xFF;

    print_string("SPI RX = 0x");
    print_hex(rx);
    print_string("\n");

    while ((SPI_STATUS & (1 << 1)) == 0);

    unsigned int status = SPI_STATUS;

    print_string("SPI STATUS = 0x");
    print_hex(status);
    print_string("\n");
    print_string("SPI DONE\n");

    while (1);   // FREEZE CPU HERE

}
