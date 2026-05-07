`timescale 1ns / 1ps

module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);

reg [31:0] memory [0:15];
integer i;

initial begin
    for (i = 0; i < 16; i = i + 1)
        memory[i] = 32'h00000000;

    // addi x1, x0, 5  (load 5 into x1)
    memory[0]  = 32'h00500093;

    // addi x2, x0, 10 (load 10 into x2)
    memory[1]  = 32'h00A00113;

    // add x3, x1, x2 (x3 = 5 + 10 = 15)
    memory[2]  = 32'h002081B3;

    // sub x4, x3, x1 (x4 = 15 - 5 = 10)
    memory[3]  = 32'h40118233;

    // and x5, x3, x2 (x5 = 15 & 10 = 10)
    memory[4]  = 32'h0021F2B3;

    // or x6, x4, x2 (x6 = 10 | 10 = 10)
    memory[5]  = 32'h00226333;

    // sw x3, 0(x0) (store x3 to memory[0])
    memory[6]  = 32'h00302023;

    // lw x7, 0(x0) (load from memory[0] into x7)
    memory[7]  = 32'h00002383;

    // beq x7, x3, 4 (branch if x7 == x3)
    memory[8]  = 32'h00338263;

    // add x8, x1, x1 (x8 = 5 + 5 = 10)
    memory[9]  = 32'h00110433;

    // add x9, x3, x4 (x9 = 15 + 10 = 25)
    memory[10]  = 32'h004184B3;
end

always @(*) begin
    if (address[31:0] <= 4'd15)
        instruction = memory[address[31:0]];
    else
        instruction = 32'h00000000;
end

endmodule
