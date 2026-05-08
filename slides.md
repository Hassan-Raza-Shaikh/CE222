---
title: "Single Cycle Processor"
subtitle: "CE222 Course Project"
author: "Hassan Raza Shaikh"
date: "2026-05-08"
---

::: {.hero}
# Single Cycle Processor

<p class="subtitle">Complete RISC-V inspired CPU executing any instruction in exactly one clock cycle</p>

<p class="meta">RISC-V | Verilog HDL | CE222 Digital Design</p>
:::

---

## Intro to Single Cycle

<div class="split">
<div class="left-panel">

### What is It?

A **single-cycle processor** completes every instruction in one clock cycle.

**Fetch** → **Decode** → **Execute** → **Memory** → **Write-back**

### Why Single Cycle?

- Straightforward control logic
- No pipelined hazards  
- Clean, educational datapath

</div>
<div class="right-panel">

```verilog
// All stages in ONE cycle

Fetch:   instruction ← mem[PC]
Decode:  signals ← opcode
Execute: result ← ALU(a,op,b)
Memory:  data ← RAM[address]
WriteB:  reg[rd] ← result
```

</div>
</div>

---

## What This Processor Can Do

<div class="split">
<div class="left-panel">

### Instruction Set

**Arithmetic & Logic**
- add, sub
- and, or, xor

**Memory Operations**
- lw (load word)
- sw (store word)

**Control Flow**
- beq (branch if equal)

</div>
<div class="right-panel">

```verilog
module single_cycle_processor (
    input clk, reset,
    output [31:0] pc_out,
    output [31:0] instruction,
    output [31:0] alu_result,
    output [31:0] write_back_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] data_read_data
);

// All 32-bit RISC-V signals
// connected in one cycle

wire ALUSrc, MemtoReg;
wire RegWrite, MemRead;
wire MemWrite, Branch;
wire [1:0] ALUOp;

endmodule
```

</div>
</div>

---

## Component: Program Counter (PC)

<div class="split">
<div class="left-panel">

### Purpose

**Holds** current instruction address  
**Updates** to next PC every cycle

### Operation

On each clock edge:
- If reset: PC ← 0
- Else: PC ← next address

</div>
<div class="right-panel">

```verilog
module PC(
    input clk, reset,
    input [31:0] PC_in,
    output reg [31:0] PC_out
);

always @(posedge clk or 
         posedge reset) begin
    if (reset)
        PC_out <= 32'b0;
    else
        PC_out <= PC_in;
end

endmodule
```

</div>
</div>

---

## Component: Instruction Memory

<div class="split">
<div class="left-panel">

### Purpose

**Stores** program instructions  
**Outputs** instruction at address combinationally

### Features

- Read-only (ROM)
- 32 × 32-bit words
- Address-driven lookup
- No clock dependency

</div>
<div class="right-panel">

```verilog
module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] mem [0:31];

initial begin
    mem[0] = 32'h00502023;
    mem[1] = 32'h00402803;
    mem[2] = 32'h00312023;
    mem[3] = 32'h00210033;
end

assign instruction = 
    mem[address[6:2]];

endmodule
```

</div>
</div>

---

## Component: Control Unit

<div class="split">
<div class="left-panel">

### Purpose

**Generates** control signals from opcode  

### Control Outputs

- ALUSrc
- MemtoReg
- RegWrite
- MemRead
- MemWrite
- Branch

Maps instruction opcode to bit patterns.

</div>
<div class="right-panel">

```verilog
module control (
    input [6:0] opcode,
    output ALUSrc, MemtoReg,
    output RegWrite, MemRead,
    output MemWrite, Branch,
    output [1:0] ALUOp
);

always @(*) begin
    case(opcode)
        7'b0110011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b10;
        end
        7'b0010011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b11;
        end
        default: begin
            RegWrite = 1'b0;
        end
    endcase
end

endmodule
```

</div>
</div>

---

## Component: Register File

<div class="split">
<div class="left-panel">

### Purpose

**Stores** 32 registers (32-bit each)  
**Reads** 2 ports simultaneously  
**Writes** 1 port per cycle

### Design

Dual-read, single-write. Register 0 always zero.

### Timing

- Reads: combinational
- Writes: synchronous (clock edge)

</div>
<div class="right-panel">

```verilog
module register_file (
    input clk, reset, RegWrite,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] registers [0:31];

assign read_data1 = 
    (read_reg1 == 0) ? 32'b0 
                     : registers[read_reg1];

assign read_data2 = 
    (read_reg2 == 0) ? 32'b0
                     : registers[read_reg2];

always @(posedge clk) begin
    if (RegWrite && write_reg != 0)
        registers[write_reg] <= 
            write_data;
end

endmodule
```

</div>
</div>

---

## Component: ALU

<div class="split">
<div class="left-panel">

### Purpose

**Computes** arithmetic/logic operations  
**Sets** zero flag for branches

### Operations

- Add / Subtract
- AND / OR / XOR
- SLT (set less than)

### Output

32-bit result + 1-bit zero flag

</div>
<div class="right-panel">

```verilog
module alu(
    input [31:0] a, b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*) begin
    case(alu_control)
        4'b0010: result = a + b;
        4'b0110: result = a - b;
        4'b0000: result = a & b;
        4'b0001: result = a | b;
        4'b0111: result = a ^ b;
        default: result = 32'b0;
    endcase
end

assign zero = (result == 0) 
              ? 1'b1 : 1'b0;

endmodule
```

</div>
</div>


---

## Component: Data Memory

<div class="split">
<div class="left-panel">

### Purpose

**Stores** 32 × 32-bit data words  
**Synchronous writes**, combinational reads

### Operation

- MemWrite=1 & clock → write
- MemRead=1 → read combinationally

</div>
<div class="right-panel">

```verilog
module data_memory (
    input clk, MemWrite,
    input MemRead,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

reg [31:0] memory [0:31];

assign read_data = MemRead 
    ? memory[address[6:2]] 
    : 32'b0;

always @(posedge clk) begin
    if (MemWrite)
        memory[address[6:2]] 
            <= write_data;
end

endmodule
```

</div>
</div>

---

## Architecture Overview

::: {.image-slide}
![Single cycle processor block diagram](single_cycle_processor_image.jpeg)
:::

---

## Demo: Simulation Output

::: {.image-slide}
![Waveform showing successful execution](demo_output.png)
:::

---

## Datapath Execution Example

<div class="split">
<div class="left-panel">

### ADD Instruction Trace

**All stages in ONE cycle:**

1. **Fetch**: Load instr from mem
2. **Decode**: Opcode (ADD), regs
3. **Execute**: ALU: 5 + 3
4. **Memory**: No load/store
5. **Write-back**: R3 ← 8

**Total time: 1 clock cycle ✓**

</div>
<div class="right-panel">

```
INSTRUCTION: ADD R3, R1, R2 (opcode=110001)

┌─────────────────────────────┐
│ PC = 0x00001000             │
├─────────────────────────────┤
│ R1 = 5, R2 = 3              │
├─────────────────────────────┤
│ Execute: 5 + 3 = 8          │
├─────────────────────────────┤
│ Result: R3 ← 8              │
├─────────────────────────────┤
│ PC ← 0x00001004             │
└─────────────────────────────┘

After Cycle 1: R3 = 8 ✓
```

</div>
</div>

---

## Design Trade-offs

<div class="split">
<div class="left-panel">

### ✅ Advantages

- **Simple Control**: Straightforward logic, easy to design
- **No Hazards**: All dependencies resolved in one cycle
- **Educational**: Clear datapath, great for learning
- **Fast Decision Time**: One cycle per instruction conceptually

### ❌ Disadvantages

- **Slow Clock**: Limited by critical path (longest stage)
- **Hardware Waste**: Simple instructions pay for complex ones
- **Power Inefficiency**: Must run at slowest stage's speed
- **Not Practical**: Real processors use pipelining/multi-cycle

</div>
<div class="right-panel">

```
Single-Cycle vs Pipelined:

SINGLE-CYCLE (This):
Cycle: |===I1===|===I2===|===I3===|

3 instructions: 3 cycles
Latency: HIGH, Throughput: OK

PIPELINED (Future):
Cycle: |I1|I2|I3|I4|I5|I6|

3 instructions: 4 cycles
Latency: LOW, Throughput: GREAT

Trade-off: Design complexity
for better performance
```

</div>
</div>

---

## Key Concepts

<div class="split">
<div class="left-panel">

### Critical Path

$$T_{clk} \geq T_{IF}+T_{ID}+T_{EX}+T_{MEM}+T_{WB}$$

**Bottleneck**: Every instruction waits for the slowest stage

### Why It Matters

- One cycle per instruction
- Clock speed limited by longest stage
- Simple control, but inefficient

</div>
<div class="right-panel">

```
Pipeline Timeline (Single-Cycle):

Instruction  Timing
────────────────────────
I1: Fetch    Decode   Exec  Mem  WB
I2:          Fetch    Decode Exec Mem  WB
I3:                   Fetch Decode Exec Mem WB

Cycle #:     1        2      3    4    5

Each instruction
takes 5 cycles minimum
```

</div>
</div>

:::
:::

---

::: {.conclusion}
## Summary

<p class="conclusion-item">
<strong>Architecture:</strong> Complete single-cycle RISC-V processor with all five pipeline stages in one clock cycle
</p>

<p class="conclusion-item">
<strong>Components:</strong> PC, instruction memory, control unit, register file, ALU, data memory
</p>

<p class="conclusion-item">
<strong>Insight:</strong> Simple and elegant, but limited by critical path. Foundation for pipelined designs.
</p>

<p class="conclusion-item">
<strong>Next Steps:</strong> Pipeline architecture, hazard detection, cache design
</p>
:::
