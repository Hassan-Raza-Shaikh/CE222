module alu_control (
    input [1:0] ALUOp,
    input [6:0] Funct7,     // 7-bit Funct7 field (Instruction[31:25])
    input [2:0] Funct3,     // 3-bit Funct3 field (Instruction[14:12])
    output reg [3:0] Operation
);

    always @(*) begin
        // Outer case checks ALUOp (using casex to handle the 'X' bits)
        casex (ALUOp)
            2'b00: begin
                // Load/Store instructions
                Operation = 4'b0010; 
            end
            
            2'b?1: begin
                // Branch instructions (Matches ALUOp = X1)
                Operation = 4'b0110;
            end
            
            2'b1?: begin
                // R-type instructions (Matches ALUOp = 1X)
                // Nested case checks Funct3
                case (Funct3)
                    3'b000: begin
                        // Check I[30], which is Funct7[5]
                        if (Funct7[5] == 1'b1)
                            Operation = 4'b0110; // subtract
                        else
                            Operation = 4'b0010; // add
                    end
                    
                    3'b111: begin
                        Operation = 4'b0000;     // and
                    end
                    
                    3'b110: begin
                        Operation = 4'b0001;     // or
                    end
                    
                    default: begin
                        Operation = 4'b0000;     // Default safe value
                    end
                endcase
            end
            
            default: begin
                Operation = 4'b0000;             // Global default
            end
        endcase
    end

endmodule