`timescale 1ns / 1ps

module instruction_fetch(
    input clk,
    input reset,
    output [31:0] instruction
);

wire [31:0] PC_current;
wire [31:0] PC_next;

// PC
PC pc1 (
    .clk(clk),
    .reset(reset),
    .PC_in(PC_next),
    .PC_out(PC_current)
);

// Adder (PC + 4)
adder add1 (
    .a(PC_current),
    .b(32'd4),
    .sum(PC_next)
);

// Instruction Memory
inst_mem imem (
    .PC(PC_current),
    .reset(reset),
    .Instruction_Code(instruction)
);

endmodule