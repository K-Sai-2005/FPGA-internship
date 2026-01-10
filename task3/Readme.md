# Task 3 – Design a Multi-Register GPIO IP with Software Control

## Objective
The objective of Task-3 is to design a **multi-register memory-mapped GPIO IP**, integrate it into a **RISC-V SoC**, and validate its functionality using **software-driven control and simulation**.

---

## GPIO IP Overview

- **Base Address:** `0x2000_0000`
- **Register Width:** 32-bit
- **Access Type:** Memory-mapped (Read / Write)
- **Registers:** 3

---

## Register Map

| Offset | Register    | Description                                   |
|------:|------------|-----------------------------------------------|
| 0x00  | GPIO_DATA  | GPIO output data register                     |
| 0x04  | GPIO_DIR   | GPIO direction register (1 = output, 0 = input) |
| 0x08  | GPIO_READ  | Reads current GPIO pin state                  |

---

## RTL Design (`gpio_mmio.v`)

The GPIO IP was extended from Task-2 to support **multiple registers**.

### Key Features
- `GPIO_DATA` stores output values
- `GPIO_DIR` controls input/output direction
- `GPIO_READ` returns the current GPIO state
- Offset-based address decoding implemented inside the IP
- Direction logic ensures correct pin behavior

---

## SoC Integration (`riscv.v`)

- GPIO IP instantiated at base address `0x2000_0000`
- No changes required to the existing address map
- Multi-register decoding handled internally within `gpio_mmio.v`
- GPIO IP connected to the system memory bus

---

## Software Validation (`gpio_task3.c`)

A C firmware was developed to validate GPIO functionality through software.

### Firmware Actions
1. Configure GPIO direction (lower 8 bits as output)
2. Write output data to GPIO
3. Read GPIO state using `GPIO_READ`
4. Print read value via UART

### Example Firmware Logic
```c
GPIO_DIR  = 0x000000FF;
GPIO_DATA = 0x000000A5;
val = GPIO_READ;
