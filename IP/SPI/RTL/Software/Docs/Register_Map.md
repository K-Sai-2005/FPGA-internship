# SPI Master IP – Register Map

## 1. Base Address

The SPI IP is memory-mapped into the SoC address space.  
The base address is defined during SoC integration.

Example:

---

## 2. Register Summary

| Offset | Register Name | Access | Description |
|------:|-------------|--------|------------|
| 0x00 | CTRL | R/W | Control register |
| 0x04 | TXDATA | R/W | Transmit data |
| 0x08 | RXDATA | R | Received data |
| 0x0C | STATUS | R | Status flags |

---

## 3. CTRL Register (0x00)

### Bit Definition

| Bit | Name | Description | Reset |
|----:|-----|------------|------|
| 0 | EN | SPI enable | 0 |
| 1 | START | Start SPI transfer | 0 |
| 7:2 | Reserved | Must be 0 | 0 |

### Notes
- Writing `START=1` initiates an SPI transfer
- `START` auto-clears after transfer completion

---

## 4. TXDATA Register (0x04)

| Bits | Description |
|----|----|
| 7:0 | Data to be transmitted over MOSI |

---

## 5. RXDATA Register (0x08)

| Bits | Description |
|----|----|
| 7:0 | Data received from MISO |

---

## 6. STATUS Register (0x0C)

| Bit | Name | Description |
|----:|----|------------|
| 0 | BUSY | SPI transfer in progress |
| 1 | DONE | Transfer complete |

---

## 7. Typical Register Access Sequence

1. Write TXDATA
2. Set `CTRL.EN = 1`
3. Set `CTRL.START = 1`
4. Poll `STATUS.DONE`
5. Read RXDATA

