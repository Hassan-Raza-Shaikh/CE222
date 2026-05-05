`timescale 1ns / 1ps

module stimulus;

// Inputs
reg [31:0] PC;
reg reset;

// Output
wire [31:0] Instruction_Code;

// Instantiate UUT
INST_MEM uut (
    .PC(PC),
    .reset(reset),
    .Instruction_Code(Instruction_Code)
);

initial
begin
    // Dump file setup
    $dumpfile("inst_mem.vcd");
    $dumpvars(0, stimulus);

    // Initialize
    PC = 0;
    reset = 0;

    // Apply reset
    #20 reset = 1;

    // Instruction fetch sequence
    #20 PC = 32'd0;
    #20 PC = 32'd4;
    #20 PC = 32'd8;
    #20 PC = 32'd12;
    #20 PC = 32'd16;
    #20 PC = 32'd20;
    #20 PC = 32'd24;
    #20 PC = 32'd28;
end

// Monitor values (console output)
initial
begin
    $monitor("Time=%0t | PC=%d | Instruction=%h", $time, PC, Instruction_Code);
end

// End simulation
initial
begin
    #250 $finish;
end

endmodule