module data_memory (
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

reg [31:0] memory [0:31];
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1)
        memory[i] = 32'b0;
end

always @(posedge clk) begin
    if (MemWrite)
        memory[address[6:2]] <= write_data;
end

assign read_data = MemRead ? memory[address[6:2]] : 32'b0;

endmodule
