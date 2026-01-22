# SPI Master MMIO IP

## What is this IP?

This IP is a **memory-mapped SPI Master controller** designed for integration into the **VSDSquadron RISC-V SoC**.  
It enables software to communicate with external SPI slave devices using a simple register-based interface.

The IP is **master-only**, supports **SPI Mode-0**, and performs **8-bit full-duplex transfers**.

---

## How do I integrate it?

- Add the SPI RTL file to the SoC RTL build
- Instantiate the SPI IP in the SoC top module
- Assign a base MMIO address
- Expose SPI signals (`SCLK`, `MOSI`, `MISO`, `CS_N`) at the top level

Detailed integration steps are provided in the documentation.

---

## Where can I find the documentation?

All documentation is available in:


| File | Description |
|----|----|
| `IP_User_Guide.md` | IP overview and features |
| `Register_Map.md` | Complete register-level details |
| `Integration_Guide.md` | SoC and FPGA integration |
| `Example_Usage.md` | Software example applications |

---

## How do I test it?

- **Simulation:**  
  Run SoC simulation and verify SPI waveforms using GTKWave.

- **Hardware:**  
  Program the FPGA and observe SPI signals on pins or logic analyzer.

Expected behavior and validation references are documented in the integration and example files.

---
## Summary

This SPI Master IP is **plug-and-play**, **software-driven**, and documented to commercial standards, allowing users to integrate and validate it **without reading RTL**.

