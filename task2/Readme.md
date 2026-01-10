# Task 2 – Design & Integrate a Memory-Mapped GPIO IP

## Objective
The objective of Task-2 is to design a simple **memory-mapped GPIO IP**, integrate it into a **RISC-V SoC**, and validate its functionality using **simulation**.

---

## GPIO IP Overview

- **Base Address:** `0x2000_0000`
- **Register Width:** 32-bit
- **Access Type:** Memory-mapped (Read / Write)

---

## Register Map

| Offset | Register    | Description                     |
|------:|------------|---------------------------------|
| 0x00  | GPIO_DATA  | Stores GPIO output data          |

---

## RTL Design (`gpio_mmio.v`)

- A single 32-bit register (`GPIO_DATA`) is implemented.
- CPU **write** operations update the GPIO output register.
- CPU **read** operations return the stored GPIO value.
- Address decoding ensures the IP responds **only** at its base address.

---

## SoC Integration (`riscv.v`)

- The GPIO IP is instantiated inside the RISC-V SoC.
- Connected to the system memory bus using:
  - `mem_addr`
  - `mem_wdata`
  - `mem_wstrb`
  - `mem_rdata`
- Read-data multiplexing ensures GPIO responses do not interfere with RAM or other peripherals.

---

## Functional Validation

- FPGA synthesis is **not required** for Task-2.
- Validation is performed using **BENCH simulation**.
- UART output confirms correct execution and memory-mapped access.

### Simulation Command
```bash
make bench
