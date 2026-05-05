`timescale 1ns/1ps

module tb_and_gate;

    reg a, b, c;
    wire sum, carry;

    // Instantiate DUT
    and_gate uut (
        .a(a),
        .b(b),
        .c(c),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        $dumpfile("wave1.vcd");   // for waveform
        $dumpvars(0, tb_and_gate);

        $monitor("Time=%0t | a=%b b=%b c=%b | sum=%b carry=%b",
                  $time, a, b, c, sum, carry);

        a=0; b=0; c=0; #10;
        a=0; b=0; c=1; #10;
        a=0; b=1; c=0; #10;
        a=0; b=1; c=1; #10;
        a=1; b=0; c=0; #10;
        a=1; b=0; c=1; #10;
        a=1; b=1; c=0; #10;
        a=1; b=1; c=1; #10;

        $finish;
    end

endmodule