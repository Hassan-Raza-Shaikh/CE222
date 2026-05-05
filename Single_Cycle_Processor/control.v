`timescale 1ns / 1ps

module control(
    input  [6:0] opcode,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUOp
);

always @(*) begin
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    Branch   = 1'b0;
    ALUOp    = 2'b00;

    case (opcode)
        7'b0110011: begin
            // R-type: add, sub, or
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end

        7'b0000011: begin
            // lw
            ALUSrc   = 1'b1;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            MemRead  = 1'b1;
            ALUOp    = 2'b00;
        end

        7'b0100011: begin
            // sw
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        7'b1100011: begin
            // beq
            Branch   = 1'b1;
            ALUOp    = 2'b01;
        end

        7'b0010011: begin
            // addi (add immediate)
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b11;
        end

        default: begin
            // Safe defaults
        end
    endcase
end

endmodule
