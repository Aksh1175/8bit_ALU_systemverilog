# Low-Power 8-bit ALU — VLSI Design

An 8-bit Arithmetic Logic Unit (ALU) designed and implemented using SystemVerilog. Simulated and verified using Vivado XSIM.

## Features
- 8 operations: ADD, SUB, INC, DEC, AND, OR, XOR, NOT
- Clock gating (ICG cell) to disable idle functional units
- Operand isolation to prevent glitch propagation
- Full flag output: Carry, Zero, Overflow, Negative
- Clean simulation — zero unknown (X) states

## Power Reduction Techniques
| Technique | Power Saved |
|---|---|
| Clock gating (ICG cell) | ~30–40% dynamic power |
| Operand isolation | ~10–15% glitch power |
| Combined estimate | ~40–50% vs ungated design |

## File Structure
├── clock_gate.sv   — Integrated clock gate cell

├── alu_arith.sv    — Arithmetic unit (ADD/SUB/INC/DEC)

├── alu_logic.sv    — Logic unit (AND/OR/XOR/NOT)

├── alu_top.sv      — Top-level ALU with clock gating

└── alu_tb.sv       — SystemVerilog testbench (15 test vectors)
