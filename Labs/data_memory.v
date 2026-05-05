`timescale 1ns / 1ps

module data_memory(
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

// Memory (32 words)
reg [31:0] memory [0:31];

// Write & Read operations
always @(posedge clk)
begin
    if (MemWrite)
        memory[address] <= write_data;

    if (MemRead)
        read_data <= memory[address];
end

endmodule