# RISC-V Single Cycle Processor Simulation & Hardware Design

![Verilog](https://img.shields.io/badge/Verilog-F2D72B?style=for-the-badge&logo=cpu&logoColor=black)
![LaTeX](https://img.shields.io/badge/LaTeX-008080?style=for-the-badge&logo=latex&logoColor=white)
![Quarto](https://img.shields.io/badge/Quarto-75AADB?style=for-the-badge&logo=quarto&logoColor=white)

A hardware implementation and simulation of a single-cycle processor based on the RISC-V instruction set architecture, developed as part of the Computer Engineering (CE222) curriculum.

## Project Architecture
The processor comprises modular Verilog hardware description components designed to execute ALU operations, memory accesses, control logic, and branches in a single clock cycle:
- **`pc.v`**: Program counter register tracking instruction execution flow.
- **`instruction_memory.v`**: ROM mapping instruction addresses.
- **`control.v` & `alu_control.v`**: Main control unit parsing opcodes and forwarding commands.
- **`alu.v`**: Arithmetic Logic Unit performing arithmetic and bitwise operations.
- **`register_file.v`**: Dual-read, single-write multi-register storage.
- **`data_memory.v`**: RAM module mapping read/write load-store operations.
- **`immediate_generator.v`**: Immediate sign-extension logic.

## Key Features
*   **Modular Verilog Implementation**: Clean hardware division following computer organization best practices.
*   **GTKWave Waveform Verification**: Waveform verification outputs (`single_cycle_processor.vcd`) to verify data-path and control signals.
*   **Quarto Presentation & LaTeX Report**: Full Quarto presentation (`slides.md`) and professional LaTeX report (`report.tex`) outlining microarchitectural details.

## File Structure
```text
├── Labs/                         # Lab assignments & code templates
├── Single_Cycle_Processor/       # Core HDL processor components
│   ├── alu.v                     # Arithmetic Logic Unit
│   ├── control.v                 # Main control block
│   ├── register_file.v           # Registers file module
│   ├── single_cycle_processor.v  # Datapath integration
│   └── single_cycle_processor_tb.v # Simulation testbench
├── report.tex                    # LaTeX technical document
├── report.pdf                    # Compiled report PDF
├── slides.md                     # Quarto presentation slides source
└── build_slides.sh               # Shell script to compile slides HTML
```

## Running Simulations
To run testbench simulations locally, ensure you have `iverilog` and `gtkwave` installed:
```bash
# Compile Verilog components
iverilog -o sim Single_Cycle_Processor/single_cycle_processor_tb.v Single_Cycle_Processor/*.v

# Run simulation
./sim

# View waveforms
gtkwave single_cycle_processor.vcd
```
