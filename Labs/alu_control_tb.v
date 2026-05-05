`timescale 1ns / 1ps

module alu_control_tb;

    // Inputs
    reg [1:0] ALUOp;
    reg [6:0] Funct7;
    reg [2:0] Funct3;

    // Outputs
    wire [3:0] Operation;

    // Instantiate the Unit Under Test (UUT)
    alu_control uut (
        .ALUOp(ALUOp),
        .Funct7(Funct7),
        .Funct3(Funct3),
        .Operation(Operation)
    );

    initial begin
        // Set up waveform dumping
        $dumpfile("alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        $display("ALUOp | Funct7  | F3  || Operation");
        $display("----------------------------------");

        // Test Row 1: ALUOp = 00, X, XXX -> Op = 0010
        ALUOp = 2'b00; Funct7 = 7'bxxxxxxx; Funct3 = 3'bxxx; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0010)", ALUOp, Funct7, Funct3, Operation);

        // Test Row 2: ALUOp = X1, X, XXX -> Op = 0110 
        ALUOp = 2'b01; Funct7 = 7'bxxxxxxx; Funct3 = 3'bxxx; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0110)", ALUOp, Funct7, Funct3, Operation);

        // Test Row 3: ALUOp = 1X, I[30]=0, 000 -> Op = 0010
        // Funct7 = 0000000 sets bit 5 to '0'
        ALUOp = 2'b10; Funct7 = 7'b0000000; Funct3 = 3'b000; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0010)", ALUOp, Funct7, Funct3, Operation);

        // Test Row 4: ALUOp = 1X, I[30]=1, 000 -> Op = 0110
        // Funct7 = 0100000 sets bit 5 to '1'
        ALUOp = 2'b10; Funct7 = 7'b0100000; Funct3 = 3'b000; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0110)", ALUOp, Funct7, Funct3, Operation);

        // Test Row 5: ALUOp = 1X, I[30]=0, 111 -> Op = 0000
        ALUOp = 2'b10; Funct7 = 7'b0000000; Funct3 = 3'b111; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0000)", ALUOp, Funct7, Funct3, Operation);

        // Test Row 6: ALUOp = 1X, I[30]=0, 110 -> Op = 0001
        ALUOp = 2'b10; Funct7 = 7'b0000000; Funct3 = 3'b110; #10;
        $display("  %b  | %b | %b ||   %b (Expected: 0001)", ALUOp, Funct7, Funct3, Operation);

        $finish;
    end

endmodule