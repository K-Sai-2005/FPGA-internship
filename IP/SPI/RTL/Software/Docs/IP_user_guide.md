# SPI Master IP – User Guide

## 1. Overview

The SPI Master IP is a **memory-mapped, master-only SPI controller** designed for integration into the VSDSquadron RISC-V SoC.  
It allows software running on the processor to communicate with external SPI slave devices such as sensors, EEPROMs, DACs, ADCs, and displays.

This IP abstracts all SPI timing and signaling, exposing a simple register-based programming interface.

---

## 2. Typical Use Cases

- Communicating with SPI sensors (temperature, IMU, pressure)
- Interfacing with SPI EEPROM / Flash memory
- SPI-based peripheral control
- Learning and validating SPI protocol behavior on FPGA

---

## 3. Supported Features

- SPI **Master-only** operation
- SPI Mode-0 (**CPOL = 0, CPHA = 0**)
- 8-bit full-duplex data transfer
- Memory-mapped register interface
- Software-controlled chip-select
- Polling-based operation (no interrupts)

---

## 4. Clocking Assumptions

- Uses system clock (`clk`) provided by the SoC
- SPI clock derived internally using clock divider logic
- Assumes stable system clock during SPI transactions

---

## 5. Limitations

- No interrupt support
- Fixed SPI mode (Mode-0 only)
- Single SPI slave supported
- 8-bit transfers only

---

## 6. High-Level Operation Flow

1. Software enables SPI IP
2. Write transmit data
3. Start SPI transfer
4. Poll status register
5. Read received data

---

## 7. Block Diagram (Logical)

```bash
    CPU / RISC-V
         |
    MMIO Interface
         |
  Register Decode
         |
  SPI Control FSM
  |      |      |
SCLK   MOSI    CS_N
         |
       MISO

```
