# Task 4 – SPI Master IP Development and Validation

## 1. Overview

This task implements and validates a **custom SPI Master IP (Mode-0)** as part of the *Real Peripheral IP Development* milestone.  
The SPI IP is designed as a **memory-mapped peripheral** supporting **8-bit full-duplex SPI transfers**.

Validation is performed in **two stages**:
1. **Software / Simulation Validation**
2. **Hardware Validation on FPGA**

---

## 2. SPI IP Features

- SPI Mode: **Mode-0 (CPOL = 0, CPHA = 0)**
- 8-bit full-duplex transfer
- Master-only operation
- Memory-mapped register interface
- Control, transmit, receive, and status registers
- Standalone and SoC-integratable design

---

## 4. SPI Register Map

| Offset | Register | Access | Description |
|------:|---------|--------|------------|
| 0x00 | CTRL | R/W | SPI control & start |
| 0x04 | TXDATA | R/W | Transmit data |
| 0x08 | RXDATA | R | Received data |
| 0x0C | STATUS | R | SPI busy flag |

---

## 5. Software / Simulation Validation

### 5.1 Validation Methodology

- The SPI IP was verified using a **Verilog testbench**.
- Memory-mapped register accesses were driven by the testbench.
- SPI signals (`spi_cs_n`, `spi_sclk`, `spi_mosi`, `spi_miso`) were captured using waveform dumping.
- Correct SPI Mode-0 timing and data transfer were verified.



### 5.2 Commands Used (Simulation)

Executed inside the `software/` or simulation directory:

```bash
make clean
make sim
gtkwave spi_wave.vcd
````

### 5.3 Simulation Results
- SPI Waveform Verification
- SPI CS, SCLK, MOSI Timing


## 6. Hardware Validation (FPGA)
### 6.1 Hardware Setup
- FPGA Board: VSDSquadron-FM
- SPI signals mapped to GPIO pins
- LEDs connected to observe SPI activity
- No external button required (auto-trigger on reset)


### 6.2 Commands Used (FPGA Build & Flash)
Executed inside the hardware/ directory:

```bash
make clean
make
sudo make flash
````

### 6.3 Hardware Results
- FPGA Programming Confirmation
- LED-Based SPI Activity


## 7. Key Observations
- Simulation and hardware behavior match exactly
- SPI IP functions correctly without full SoC integration
- Hardware validation confirms real-world correctness
- IP is reusable and integration-ready

## 8. Conclusion
The SPI Master IP has been:
- Successfully designed in RTL
- Verified using simulation and waveforms
Validated on real FPGA hardware

