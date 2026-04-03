# RISC-V SoC with DMA-Driven VGA Graphics Pipeline

A custom RISC-V (RV32I) system-on-chip implemented in Verilog, targeting the Xilinx Basys3 FPGA (Artix-7 XC7A35T). The system features a 5-stage pipelined processor, DMA engine, and VGA graphics output.

## Architecture

- **RV32I Core** — 5-stage pipeline (IF/ID/EX/MEM/WB) with data forwarding and hazard detection
- **Wishbone Bus** — Interconnect with memory-mapped peripherals
- **DMA Engine** — Scatter-gather transfers to offload framebuffer writes from the CPU
- **VGA Controller** — 640×480 output at 60 Hz with pixel-doubling from a 320×240 framebuffer and 16-color palette
- **Peripherals** — UART, GPIO (LEDs, switches, 7-segment display)

## Memory Map

| Address Range | Peripheral |
|---|---|
| `0x0000_0000 – 0x0000_3FFF` | Code/Data BRAM (16 KB) |
| `0x1000_0000 – 0x1000_95FF` | Framebuffer (38,400 bytes) |
| `0x2000_0000 – 0x2000_000F` | UART |
| `0x2000_0010 – 0x2000_001F` | GPIO |
| `0x2000_0020 – 0x2000_002F` | DMA |

## Building

1. Install Vivado 2018.2+
2. Clone this repo
3. Open Vivado, navigate to the project directory in the Tcl Console:
   ```
   cd C:/path/to/riscv-vga-soc
   source scripts/create_project.tcl
   ```
4. Run Synthesis → Implementation → Generate Bitstream
5. Program the Basys3 via Hardware Manager

## Software Toolchain

Compile bare-metal C for the core using the RISC-V GCC cross-compiler:

```
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T sw/linker.ld sw/startup.s sw/src/main.c -o program.elf
riscv64-unknown-elf-objcopy -O binary program.elf program.bin
python scripts/hex_to_mem.py program.bin > sw/program.hex
```

## Project Structure

```
rtl/core/          RV32I pipeline stages, ALU, register file, hazard unit
rtl/bus/           Wishbone interconnect
rtl/peripherals/   UART, GPIO, DMA
rtl/video/         VGA timing, framebuffer, palette
tb/                Testbenches
sw/                Bare-metal C source, linker script, startup code
constraints/       Basys3 pin assignments
scripts/           Vivado project TCL, build utilities
```

## Tools

- Xilinx Vivado 2018.2+
- RISC-V GCC (`riscv64-unknown-elf-gcc`)
- Basys3 FPGA board

## Resources

https://www.eg.bucknell.edu/~csci320/2016-fall/wp-content/uploads/2015/08/verilog-std-1364-2005.pdf
https://docs.riscv.org/reference/isa/unpriv/rv32.html
