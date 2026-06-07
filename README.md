# 8-Bit ALU — SystemVerilog Design

A fully synchronous, clock-gated 8-bit Arithmetic Logic Unit (ALU) implemented in SystemVerilog. The design is split into separate arithmetic and logic datapaths, each with its own enable-controlled clock gate, making it suitable for power-aware synthesis flows.

---

## Features

- 8-bit synchronous datapath with active-low asynchronous reset
- 4 arithmetic operations: ADD, SUB, INC, DEC
- 4 logic operations: AND, OR, XOR, NOT
- 4 status flags: Carry, Zero, Overflow, Negative
- Integrated clock gating (`clock_gate`) for each sub-unit — ready for power estimation in synthesis
- Operand isolation when arithmetic unit is inactive
- Self-checking testbench with VCD waveform dump and 500 ns watchdog

---

## File Structure

```
├── alu_top.sv       # Top-level: instantiates sub-units, clock gates, output MUX & flags
├── alu_arith.sv     # Arithmetic unit: ADD / SUB / INC / DEC
├── alu_logic.sv     # Logic unit: AND / OR / XOR / NOT
├── clock_gate.sv    # ICG cell model (combinational latch-style)
└── alu_tb.sv        # Testbench with directed test vectors and VCD dump
```

---

## Port Description

### `alu_top` (top-level)

| Port       | Direction | Width | Description                                  |
|------------|-----------|-------|----------------------------------------------|
| `clk`      | input     | 1     | System clock                                 |
| `rst_n`    | input     | 1     | Active-low asynchronous reset                |
| `te`       | input     | 1     | Test enable — bypasses clock gate during scan|
| `a`        | input     | 8     | Operand A                                    |
| `b`        | input     | 8     | Operand B (ignored by INC / DEC / NOT)       |
| `op`       | input     | 3     | Operation select (see Opcode Map below)      |
| `result`   | output    | 8     | Registered operation result                  |
| `carry`    | output    | 1     | Carry / borrow flag (arithmetic only)        |
| `zero`     | output    | 1     | Set when result is 0x00                      |
| `overflow` | output    | 1     | Signed overflow flag (arithmetic only)       |
| `negative` | output    | 1     | Set when result[7] is 1                      |

---

## Opcode Map

| `op[2:0]` | Mnemonic | Operation         | Expression             |
|-----------|----------|-------------------|------------------------|
| `3'b000`  | ADD      | A + B             | `result = a + b`       |
| `3'b001`  | SUB      | A − B             | `result = a - b`       |
| `3'b010`  | INC      | A + 1             | `result = a + 1`       |
| `3'b011`  | DEC      | A − 1             | `result = a - 1`       |
| `3'b100`  | AND      | A AND B           | `result = a & b`       |
| `3'b101`  | OR       | A OR B            | `result = a | b`      |
| `3'b110`  | XOR      | A XOR B           | `result = a ^ b`       |
| `3'b111`  | NOT      | NOT A             | `result = ~a`          |

> `op[2]` selects the datapath: **0 = arithmetic**, **1 = logic**.  
> `op[1:0]` selects the specific operation within that datapath.

---

## Flag Behavior

| Flag       | Set condition                                                                 | Cleared when          |
|------------|-------------------------------------------------------------------------------|-----------------------|
| `carry`    | Unsigned overflow or borrow (bit 8 of 9-bit intermediate result)              | Logic op or reset     |
| `zero`     | `result == 8'h00` (checked on the MUX output, before the output register)    | Result becomes non-zero|
| `overflow` | Signed overflow: `(a[7] == b[7]) && (result[7] != a[7])`                     | Logic op or reset     |
| `negative` | `result[7] == 1` (MSB of the registered result)                              | Result MSB clears     |

`carry` and `overflow` are always forced to 0 for logic operations.

---

