module ALUMux(
    input wire isALUreg, isBranch, isStore, isShamt,
    input wire [31:0] rd2, ImmExt,
    input wire [4:0] shamt,
    output wire [31:0] aluIn2
);

    wire [31:0] aluIn2Pre, shamtExt;
    assign shamtExt = {{27{1'b0}}, shamt}; 

   
    assign aluIn2Pre = (isALUreg | isBranch) ? rd2 : ImmExt;
    assign aluIn2 = isShamt ? shamtExt : aluIn2Pre;

endmodule