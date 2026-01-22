# SPI Master IP – Example Usage

This document provides example **application-level C code** demonstrating how to use the SPI Master MMIO IP from software.

---

## Example 1: Single Byte SPI Transfer

```c
#define SPI_BASE_ADDR  0x40002000

#define SPI_CTRL   (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x00))
#define SPI_TXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x04))
#define SPI_RXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x08))
#define SPI_STATUS (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x0C))

void spi_transfer(unsigned char tx, unsigned char *rx)
{
    SPI_TXDATA = tx;
    SPI_CTRL = (1 << 0);      // Enable SPI
    SPI_CTRL |= (1 << 1);     // Start transfer

    while ((SPI_STATUS & (1 << 1)) == 0);

    *rx = (unsigned char)(SPI_RXDATA & 0xFF);
}

int main(void)
{
    unsigned char rx_data;
    spi_transfer(0xA5, &rx_data);

    while (1);
}
```

## Example 2: Read Register from SPI Slave Device
```c
#define SPI_BASE_ADDR  0x40002000

#define SPI_CTRL   (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x00))
#define SPI_TXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x04))
#define SPI_RXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x08))
#define SPI_STATUS (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x0C))

unsigned char spi_read_register(unsigned char reg_addr)
{
    unsigned char rx;

    /* Send register address */
    SPI_TXDATA = reg_addr;
    SPI_CTRL = (1 << 0);
    SPI_CTRL |= (1 << 1);
    while ((SPI_STATUS & (1 << 1)) == 0);

    /* Dummy write to receive data */
    SPI_TXDATA = 0x00;
    SPI_CTRL |= (1 << 1);
    while ((SPI_STATUS & (1 << 1)) == 0);

    rx = (unsigned char)(SPI_RXDATA & 0xFF);
    return rx;
}

int main(void)
{
    unsigned char value;
    value = spi_read_register(0x10);

    while (1);
}
```
## Example 3: Burst Transmission of Multiple Bytes
```c
#define SPI_BASE_ADDR  0x40002000

#define SPI_CTRL   (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x00))
#define SPI_TXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x04))
#define SPI_RXDATA (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x08))
#define SPI_STATUS (*(volatile unsigned int *)(SPI_BASE_ADDR + 0x0C))

void spi_send_buffer(unsigned char *data, int length)
{
    int i;

    SPI_CTRL = (1 << 0);  // Enable SPI

    for (i = 0; i < length; i++)
    {
        SPI_TXDATA = data[i];
        SPI_CTRL |= (1 << 1);

        while ((SPI_STATUS & (1 << 1)) == 0);
    }
}

int main(void)
{
    unsigned char buffer[4] = {0x11, 0x22, 0x33, 0x44};

    spi_send_buffer(buffer, 4);

    while (1);
}
```
