module memory_32x32 (
    input clk,
    input [4:0] addr,          // 5-bit address (0–31)
    output reg [31:0] data_out // 32-bit output
);

    reg [31:0] mem [31:0];     // 32 registers of 32 bits
    integer i;

    // Initialize memory: mem[i] = i
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = i;
        end
    end

    // Read on positive clock edge
    always @(posedge clk) begin
        data_out <= mem[addr];
    end

endmodule