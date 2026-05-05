module alu_control (
    input [1:0] ALUOp,
    input [6:0] Funct7,
    input [2:0] Funct3,
    output reg [3:0] Operation
);

always @(*) begin
    case (ALUOp)
        2'b00: Operation = 4'b0010; // add
        2'b01: Operation = 4'b0110; // sub for branch compare
        2'b10: begin
            case (Funct3)
                3'b000: Operation = (Funct7[5]) ? 4'b0110 : 4'b0010; // sub/add
                3'b111: Operation = 4'b0000; // and
                3'b110: Operation = 4'b0001; // or
                default: Operation = 4'b0010;
            endcase
        end
        2'b11: Operation = 4'b0010; // addi (add immediate)
        default: Operation = 4'b0010;
    endcase
end

endmodule
