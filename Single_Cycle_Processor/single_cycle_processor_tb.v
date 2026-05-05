`timescale 1ns / 1ps

module tb_single_cycle_processor;

reg clk;
reg reset;
wire [31:0] pc_out;
wire [31:0] instruction;
wire [31:0] alu_result;
wire [31:0] write_back_data;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] data_read_data;

single_cycle_processor uut (
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out),
    .instruction(instruction),
    .alu_result(alu_result),
    .write_back_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .data_read_data(data_read_data)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("single_cycle_processor.vcd");
    $dumpvars(0, tb_single_cycle_processor);

    clk = 1'b0;
    reset = 1'b1;
    #12 reset = 1'b0;

    @(posedge clk);
    #1;

    $finish;
end

initial begin
    $monitor("Time=%0t | PC=%h | Instr=%h | ALU=%h | WB=%h | RD1=%h | RD2=%h | MEM=%h",
             $time, pc_out, instruction, alu_result, write_back_data, read_data1, read_data2, data_read_data);
end

endmodule
