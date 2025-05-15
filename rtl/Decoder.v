module Decoder(
                input wire [31:0] instr,            
                output wire isALUreg,               
                output wire regWrite,               
                output wire isJAL,                  
                output wire isJALR,                 
                output wire isBranch,               
                output wire isLUI,                  
                output wire isAUIPC,              
                output wire isALUimm,              
                output wire isLoad,                 
                output wire isStore);

    wire [6:0] op;
    assign op = instr[6:0];       

    assign isALUreg = (op == 7'b0110011); // rd <- rs1 OP rs2
    assign isALUimm = (op == 7'b0010011); // rd <- rs1 OP Iimm
    assign isBranch = (op == 7'b1100011); // if(rs1 OP rs2) PC<-PC+Bimm
    assign isJALR   = (op == 7'b1100111); // rd <- PC+4; PC<-rs1+Iimm
    assign isJAL    = (op == 7'b1101111); // rd <- PC+4; PC<-PC+Jimm
    assign isAUIPC  = (op == 7'b0010111); // rd <- PC + Uimm
    assign isLUI    = (op == 7'b0110111); // rd <- Uimm
    assign isLoad   = (op == 7'b0000011); // rd <- mem[rs1+Iimm]
    assign isStore  = (op == 7'b0100011); // mem[rs1+Simm] <- rs2

    assign regWrite = isALUreg || isALUimm || isLoad || isLUI || isAUIPC || isJAL || isJALR;

endmodule