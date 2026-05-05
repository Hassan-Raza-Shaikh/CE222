`timescale 1ns / 1ps

// Instruction Decoder Module
// Takes a 32-bit RISC-V instruction and breaks it down into constituent fields
// Distributes decoded fields to control unit, ALU control, register file, and immediate generator

module decoder(
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [2:0] funct3,
    output [6:0] funct7
);

// Extract instruction fields (combinational, no state)
assign opcode = instruction[6:0];
assign rs1    = instruction[19:15];
assign rs2    = instruction[24:20];
assign rd     = instruction[11:7];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];

endmodule
