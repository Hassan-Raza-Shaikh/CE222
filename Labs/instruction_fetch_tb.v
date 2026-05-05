`timescale 1ns / 1ps

module instruction_fetch_tb;

reg clk;
reg reset;
wire [31:0] instruction;

instruction_fetch uut (
    .clk(clk),
    .reset(reset),
    .instruction(instruction)
);

// Clock
always #10 clk = ~clk;

initial
begin
    $dumpfile("if.vcd");
    $dumpvars(0, instruction_fetch_tb);

    clk = 0;
    reset = 1;

    #20 reset = 0;

    #200 $finish;
end

initial
begin
    $monitor("Time=%0t | Instruction=%h", $time, instruction);
end

endmodule