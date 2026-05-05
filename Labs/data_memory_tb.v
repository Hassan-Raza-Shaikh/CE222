`timescale 1ns / 1ps

module data_memory_tb;

reg clk;
reg MemWrite;
reg MemRead;
reg [31:0] address;
reg [31:0] write_data;
wire [31:0] read_data;

// Instantiate
data_memory uut (
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

// Clock
always #1 clk = ~clk;

initial
begin
    $dumpfile("data_mem.vcd");
    $dumpvars(0, data_memory_tb);

    clk = 0;
    MemWrite = 0;
    MemRead = 0;

    // WRITE DATA
    #20 MemWrite = 1; address = 5; write_data = 32'hAABBCCDD;
    #20 address = 10; write_data = 32'h12345678;

    #20 MemWrite = 0;

    // READ DATA
    #20 MemRead = 1; address = 5;
    #20 address = 10;

    #40 $finish;
end

initial
begin
    $monitor("Time=%0t | Addr=%d | Write=%h | Read=%h", 
              $time, address, write_data, read_data);
end

endmodule