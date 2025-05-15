module AluDecoder(
                    input [2:0] funct3,
                    input [6:0] funct7,
                    input instr_5,
                    input isBranch, isALUreg, isALUimm,
                    output reg [3:0] aluControl,
                    output reg isShamt);

    always @(*) begin
        aluControl = 4'h0; 
        isShamt = 1'b0;

        
        if (isBranch) begin
            case (funct3)
                3'b000: aluControl = 4'ha; // beq   cmpe
                3'b001: aluControl = 4'hb; // bne   cmpne
                3'b100: aluControl = 4'h3; // blt   signed <
                3'b101: aluControl = 4'hc; // bge         >=
                3'b110: aluControl = 4'h4; // bltu  unsigned <
                3'b111: aluControl = 4'hd; // bgeu  unsigned >=
                default: aluControl = 4'ha; 
            endcase
        end
        //isALUreg or isALUimm = 1
        else if (isALUreg || isALUimm) begin
            case (funct3)
                3'b000: begin
                    if (isALUreg && funct7[5] && instr_5) aluControl = 4'h1; // -
                    else aluControl = 4'h0;                                 // add, addi
                end
                3'b001: begin
                    aluControl = 4'h2;              // sll, slli    shift
                    if (isALUimm) isShamt = 1'b1;   
                end
                3'b010: aluControl = 4'h3;          // slt, slti    < signed
                3'b011: aluControl = 4'h4;          // sltu, sltui  < unsigned
                3'b100: aluControl = 4'h5;          // XOR
                3'b101: begin
                    if (funct7[5]) aluControl = 4'h6;          // sra, srai >>n
                    else    aluControl = 4'h7;                 // srl, srli >>l
                    if (isALUimm) isShamt = 1'b1; 
                end
                3'b110: aluControl = 4'h8;          // or, ori
                3'b111: aluControl = 4'h9;          // AND, ANDI
                default: aluControl = 4'h0; 
            endcase
        end
    end
endmodule


