`timescale 1ns / 1ps

module control(
	input  [6:0] opcode,
	output reg ALUSrc,
	output reg MemtoReg,
	output reg RegWrite,
	output reg MemRead,
	output reg MemWrite,
	output reg Branch,
	output reg ALUOp1,
	output reg ALUOp0
);

always @(*)
begin
	// Safe defaults
	ALUSrc    = 1'b0;
	MemtoReg  = 1'b0;
	RegWrite  = 1'b0;
	MemRead   = 1'b0;
	MemWrite  = 1'b0;
	Branch    = 1'b0;
	ALUOp1    = 1'b0;
	ALUOp0    = 1'b0;

	case (opcode)
		7'b000000: begin
			// R-format
			ALUSrc   = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b1;
			MemRead  = 1'b0;
			MemWrite = 1'b0;
			Branch   = 1'b0;
			ALUOp1   = 1'b1;
			ALUOp0   = 1'b0;
		end

		7'b100011: begin
			// lw
			ALUSrc   = 1'b1;
			MemtoReg = 1'b1;
			RegWrite = 1'b1;
			MemRead  = 1'b1;
			MemWrite = 1'b0;
			Branch   = 1'b0;
			ALUOp1   = 1'b0;
			ALUOp0   = 1'b0;
		end

		7'b101011: begin
			// sw
			ALUSrc   = 1'b1;
			MemtoReg = 1'b0; // don't care
			RegWrite = 1'b0;
			MemRead  = 1'b0;
			MemWrite = 1'b1;
			Branch   = 1'b0;
			ALUOp1   = 1'b0;
			ALUOp0   = 1'b0;
		end

		7'b000100: begin
			// beq
			ALUSrc   = 1'b0;
			MemtoReg = 1'b0; // don't care
			RegWrite = 1'b0;
			MemRead  = 1'b0;
			MemWrite = 1'b0;
			Branch   = 1'b1;
			ALUOp1   = 1'b0;
			ALUOp0   = 1'b1;
		end

		default: begin
			// Keep defaults for unsupported opcodes
		end
	endcase
end

endmodule