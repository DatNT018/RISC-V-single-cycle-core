module Alu(
            input [3:0] aluControl,
            input [3:0] op1, op2,
            output reg [31:0] aluOut,
            output Zero);
    
    always @(*) begin
        case (aluControl)
            4'h0: aluOut <= op1 + op2;
            4'h1: aluOut <= op1 - op2;
            4'h2: aluOut <= op1 << op2;
            4'h3: aluOut <= $signed(op1) < $signed(op2);
            4'h4: aluOut <= op1 < op2;
            4'h5: aluOut <= op1 ^ op2;
            4'h6: aluOut <= $signed(op1) >>> op2;
            4'h7: aluOut <= op1 >> op2;
            4'h8: aluOut <= op1 | op2;
            4'h9: aluOut <= op1 & op2;
            4'ha: aluOut <= op1 == op2;
            4'hb: aluOut <= op1 != op2;
            4'hc: aluOut <= $signed(op1) >= $signed(op2);
            4'hd: aluOut <= op1 >= op2;
            default: aluOut <= 31'b0;
        endcase
    end

    assign isZero = ~|aluOut;
endmodule

/*
4'h0: ADD
4'h1: SUB
4'h2: SLL 
4'h3: SLT 
4'h4: SLTU 
4'h5: XOR
4'h6: SRA 
4'h7: SRL 
4'h8: OR
4'h9: AND
4'ha: BEQ
4'hb: BNE
4'hc: BGE 
4'hd: BGEU/BLTU 
*/