module control_tb;

	reg [6:0] opcode;
	wire ALUSrc;
	wire MemtoReg;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	wire ALUOp1;
	wire ALUOp0;

	control dut (
		.opcode(opcode),
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUOp1(ALUOp1),
		.ALUOp0(ALUOp0)
	);

	task check;
		input [6:0] op;
		input exp_ALUSrc;
		input exp_MemtoReg;
		input exp_RegWrite;
		input exp_MemRead;
		input exp_MemWrite;
		input exp_Branch;
		input exp_ALUOp1;
		input exp_ALUOp0;
		begin
			opcode = op;
			#1;

			if (ALUSrc    !== exp_ALUSrc   ||
				MemtoReg  !== exp_MemtoReg ||
				RegWrite  !== exp_RegWrite ||
				MemRead   !== exp_MemRead  ||
				MemWrite  !== exp_MemWrite ||
				Branch    !== exp_Branch   ||
				ALUOp1    !== exp_ALUOp1   ||
				ALUOp0    !== exp_ALUOp0) begin
				$display("FAIL opcode=%b got: ALUSrc=%b MemtoReg=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b ALUOp1=%b ALUOp0=%b",
						 opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0);
			end
			else begin
				$display("PASS opcode=%b", opcode);
			end
		end
	endtask

	initial begin
		$dumpfile("control.vcd");
		$dumpvars(0, control_tb);

		check(7'b000000, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0); // R-format
		check(7'b100011, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0); // lw
		check(7'b101011, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0); // sw
		check(7'b000100, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1); // beq

		// Unknown opcode should keep safe defaults
		check(7'b111111, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);

		$finish;
	end

endmodule
