`timescale 1ns/1ps

module memory_32x32_tb;

    reg clk;
    reg [4:0] addr;
    wire [31:0] data_out;

    // Instantiate DUT
    memory_32x32 uut (
        .clk(clk),
        .addr(addr),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Dump file setup
        $dumpfile("memory_32x32.vcd");
        $dumpvars(0, memory_32x32_tb);

        // Initialize
        clk = 0;
        addr = 0;

        // Test cases
        #10 addr = 5'd0;
        #10 addr = 5'd4;
        #10 addr = 5'd8;
        #10 addr = 5'd16;
        #10 addr = 5'd31;

        #20 $finish;
    end

endmodule