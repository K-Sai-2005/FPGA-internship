# SPI Master IP – Integration Guide

## 1. Purpose

This guide explains **how to integrate the SPI Master MMIO IP into the VSDSquadron RISC-V SoC**, validate it using simulation, and observe SPI waveforms using **GTKWave via NoVNC**.

The steps assume the user:
- Is familiar with VSDSquadron FPGA environment
- Does NOT inspect the SPI RTL internally
- Wants a reproducible, command-driven integration flow

---

## 2. Required Files

Ensure the following file is present in the SoC RTL directory:
rtl/spi_mmio.v
rtl/tb_soc.v
Firmware/spi_test.c

No additional IP dependencies are required.

---

## 3. SoC-Level Integration Steps

### 3.1 Add SPI IP to RTL Build

Copy the SPI IP RTL into the SoC RTL folder:

```bash
cp ip/spi_ip/rtl/spi_mmio.v samples/vsdfpga_labs/basicRISCV/RTL/
```
### 3.2 Include SPI IP in Simulation Makefile

Edit the SoC Makefile (RTL/Makefile) and add spi_mmio.v:

```bash
IVERILOG_SRCS += spi_mmio.v
```
### 3.3 Instantiate SPI IP in SoC Top Module
Instantiate the SPI IP inside the SoC top module (riscv.v or equivalent):
```
spi_mmio #(
    .BASE_ADDR(32'h40002000)
) u_spi (
    .clk        (clk),
    .resetn     (resetn),

    .mem_valid  (mem_valid),
    .mem_addr   (mem_addr),
    .mem_wdata  (mem_wdata),
    .mem_wstrb  (mem_wstrb),
    .mem_rdata  (mem_rdata),
    .mem_ready  (mem_ready),

    .spi_sclk   (spi_sclk),
    .spi_mosi   (spi_mosi),
    .spi_miso   (spi_miso),
    .spi_cs_n   (spi_cs_n)
);
```
## 4. Address Mapping

The SPI IP occupies 16 bytes of address space.
Base Address : 0x40002000
Valid Range  : 0x40002000 – 0x4000200F
Address decoding is handled internally by the IP.


## 5. Simulation-Based Integration Validation
### 5.1 Build and Run Simulation
Navigate to the RTL directory:
```
cd samples/vsdfpga_labs/basicRISCV/RTL
```
Run the SPI-enabled SoC simulation:
```
make clean
make bench
```
This generates:
```
simv
spi_wave.vcd
```

## 6. GTKWave Analysis Using NoVNC

- Open NoVNC in the browser using the port link.
- Open GTKWave Inside NoVNC

Inside the NoVNC terminal:
```
gtkwave spi_wave.vcd
```
## 7. Expected Simulation Behavior
Signal	Expected Behavior
- spi_cs_n	Goes LOW during transfer
- spi_sclk	Toggles during active transfer
- spi_mosi	Shifts out TXDATA
- spi_miso	Sampled on rising edge
- status.done	Asserts after 8 bits
---
## 8. Simulation Results

The simulation confirms correct SPI protocol behavior:

- Chip Select (spi_cs_n) is asserted low only during active transfers
- SPI clock toggles for exactly 8 cycles per transaction
- MOSI data matches software TXDATA
- DONE flag asserts after transfer completion
- Simulation Waveform Evidence

### Simulation Result
![Simulation](https://github.com/K-Sai-2005/FPGA-internship/blob/main/images/4e6101fe-112a-4299-b779-24618106c853.png)

### Simulation Waveforms
![SPI Simulation Waveform](https://github.com/K-Sai-2005/FPGA-internship/blob/main/images/8b857bd7-de06-48aa-ae56-b37dc6cb4d2f.png)

![](https://github.com/K-Sai-2005/FPGA-internship/blob/main/images/643683ae-066b-4967-9871-d1b469ffb10f.png)

![](https://github.com/K-Sai-2005/FPGA-internship/blob/main/images/92fac30b-802d-485f-882e-827591862be8.png)

 ## 9. Hardware Integration Procedure

After successful simulation validation, the SPI IP was integrated on FPGA hardware.

Hardware Connections
- SPI Signal	FPGA Connection
- spi_sclk	FPGA Header / Test Pin
- spi_mosi	External SPI Slave MOSI
- spi_miso	External SPI Slave MISO
- spi_cs_n	External SPI Slave CS

Pin assignments were added in the FPGA constraint file as per board requirements.

## 10. Hardware Programming

The FPGA was programmed with the SPI-enabled SoC bitstream using the standard VSDSquadron flow.

```
make clean
make build
sudo make flash

```
## 11. Hardware Results

The following observations confirm correct hardware operation using LED lights and the reset button on the FPGA.
![SPI Hardware Capture](https://github.com/K-Sai-2005/FPGA-internship/blob/main/images/image%20(22).png)

[Hardware SPI Operation Video](images/WhatsApp%20Video%202026-01-21%20at%2010.34.25%20PM.mp4)
