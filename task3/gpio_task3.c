#define GPIO_BASE 0x20000000

#define GPIO_DATA (*(volatile unsigned int *)(GPIO_BASE + 0x00))
#define GPIO_DIR  (*(volatile unsigned int *)(GPIO_BASE + 0x04))
#define GPIO_READ (*(volatile unsigned int *)(GPIO_BASE + 0x08))

extern void putchar(char c);
extern void print_hex(unsigned int);


int main() {

    // STEP 1: Configure GPIO direction (lower 8 bits as output)
    GPIO_DIR = 0x000000FF;

    // STEP 2: Write data to GPIO
    GPIO_DATA = 0x000000A5;

    // STEP 3: Read back GPIO state
    unsigned int val = GPIO_READ;

    // Print result
    putchar('G');
    putchar('P');
    putchar('I');
    putchar('O');
    putchar(':');
    putchar(' ');
    print_hex(val);

    while (1);
}
