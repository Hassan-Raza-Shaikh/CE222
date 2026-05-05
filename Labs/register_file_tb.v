`timescale 1ns/1ps

module register_file_tb;

    reg clk, reset, RegWrite;
    reg [4:0] read_reg1, read_reg2, write_reg;
    reg [31:0] write_data;

    wire [31:0] read_data1, read_data2;

    // Instantiate DUT
    register_file uut (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Dump file setup
        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);

        // Initialize
        clk = 0;
        reset = 1;
        RegWrite = 0;

        #10 reset = 0;

        // Write operations
        RegWrite = 1;
        write_reg = 5'd1; write_data = 32'd100; #10;
        write_reg = 5'd2; write_data = 32'd200; #10;
        write_reg = 5'd3; write_data = 32'd300; #10;

        RegWrite = 0;

        // Read operations
        read_reg1 = 5'd1; read_reg2 = 5'd2; #10;
        read_reg1 = 5'd3; read_reg2 = 5'd1; #10;

        #20 $finish;
    end

endmodule