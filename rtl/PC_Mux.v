module PCMux(
    input wire isBranch, isZero, isJAL, isJALR,
    input wire [31:0] pcplus4, pcplusImm, aluOut,
    output wire [31:0] pcNext
);

    wire [31:0] jalrTarget;
    assign jalrTarget = {aluOut[31:1], 1'b0};

    assign pcNext = (isBranch && !isZero || isJAL) ? pcplusImm :
                    isJALR ? jalrTarget :
                    pcplus4;

endmodule