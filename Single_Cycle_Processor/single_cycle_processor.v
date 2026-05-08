`timescale 1ns / 1ps

module single_cycle_processor(
    input clk,
    input reset,
    output [31:0] pc_out,
    output [31:0] instruction,
    output [31:0] alu_result,
    output [31:0] write_back_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] data_read_data
);


wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire [1:0] ALUOp;
wire [3:0] alu_operation;
wire zero;
wire [31:0] pc_current;
wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire [31:0] pc_next;
wire [31:0] immediate;
wire [31:0] alu_input2;

// Decoder output wires
wire [6:0] opcode;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [2:0] funct3;
wire [6:0] funct7;

PC pc_unit (
    .clk(clk),
    .reset(reset),
    .PC_in(pc_next),
    .PC_out(pc_current)
);

adder pc_increment_adder (
    .a(pc_current),
    .b(32'd4),
    .sum(pc_plus4)
);

instruction_memory instruction_memory_unit (
    .address(pc_current),
    .instruction(instruction)
);

// Instruction Decoder - breaks down instruction into constituent fields
decoder decoder_unit (
    .instruction(instruction),
    .opcode(opcode),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7)
);

control control_unit (
    .opcode(opcode),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

immediate_generator immediate_generator_unit (
    .instruction(instruction),
    .immediate(immediate)
);

register_file register_file_unit (
    .clk(clk),
    .reset(reset),
    .RegWrite(RegWrite),
    .read_reg1(rs1),
    .read_reg2(rs2),
    .write_reg(rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

alu_control alu_control_unit (
    .ALUOp(ALUOp),
    .Funct7(funct7),
    .Funct3(funct3),
    .Operation(alu_operation)
);

mux2 alu_src_mux (
    .a(read_data2),
    .b(immediate),
    .sel(ALUSrc),
    .y(alu_input2)
);

alu alu_unit (
    .a(read_data1),
    .b(alu_input2),
    .alu_control(alu_operation),
    .result(alu_result),
    .zero(zero)
);

data_memory data_memory_unit (
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .address(alu_result),
    .write_data(read_data2),
    .read_data(data_read_data)
);

mux2 mem_to_reg_mux (
    .a(alu_result),
    .b(data_read_data),
    .sel(MemtoReg),
    .y(write_back_data)
);

adder branch_adder (
    .a(pc_plus4),
    .b(immediate),
    .sum(branch_target)
);

assign pc_next = (Branch & zero) ? branch_target : pc_plus4;
assign pc_out = pc_current;

endmodule
