#include <stdio.h>
#include <stdint.h>

#define GPIO_REG   (*(volatile uint32_t *)0x20000000u)   // update if mentor gives other address

int main(void)
{
    printf("GPIO MMIO test start\n");

    GPIO_REG = 0x0000000F;
    printf("Wrote 0x0000000F, read 0x%08x\n", GPIO_REG);

    GPIO_REG = 0x000000F0;
    printf("Wrote 0x000000F0, read 0x%08x\n", GPIO_REG);

    GPIO_REG = 0xA5A5A5A5;
    printf("Wrote 0xA5A5A5A5, read 0x%08x\n", GPIO_REG);

    printf("GPIO MMIO test end\n");

    while (1) ;
}
