module Extend(
    input wire [31:0] instr,          
    input wire isLUI, isAUIPC,         
    input wire isALUimm, isLoad, isStore,
    input wire isBranch, isJAL, isJALR,
    output wire [31:0] ImmExt);

    
    wire [31:0] Uimm, Iimm, Simm, Bimm, Jimm;
    
    assign Uimm = {instr[31:12], 12'b0};                        
    assign Iimm = {{20{instr[31]}}, instr[31:20]};              
    assign Simm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; 
    assign Bimm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; 
    assign Jimm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

   
    assign ImmExt = (isLUI || isAUIPC) ? Uimm :
                 (isALUimm || isLoad || isJALR) ? Iimm :
                 isStore ? Simm :
                 isBranch ? Bimm :
                 isJAL ? Jimm :
                 32'b0; 

endmodule
