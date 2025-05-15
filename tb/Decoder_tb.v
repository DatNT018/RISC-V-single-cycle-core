`timescale 1ns / 1ps

module Decoder_TB;

    reg clk;
    reg [1:0] notUsed;
    reg [31:0] instr;
    wire isALUreg, regWrite,SAX isJAL, 
         isJALR, isBranch, isLUI, 
         isAUIPC, isALUimm, isLoad, isStore;
    reg isALUregT, regWriteT, isJALT, 
        isJALRT, isBranchT, isLUIT, 
        isAUIPCT, isALUimmT, isLoadT, isStoreT;

    reg [43:0] testvectors [0:9]; // 9 vectors + 1 terminator
    reg [31:0] vectornum, errors;

    Decoder dut(
        .instr(instr),
        .isALUreg(isALUreg), 
        .regWrite(regWrite), 
        .isJAL(isJAL), 
        .isJALR(isJALR), 
        .isBranch(isBranch), 
        .isLUI(isLUI), 
        .isAUIPC(isAUIPC), 
        .isALUimm(isALUimm), 
        .isLoad(isLoad), 
        .isStore(isStore)
    );

    initial begin
        $dumpfile("decoder_tb.vcd");
        $dumpvars(0, Decoder_TB); 

        
        testvectors[0] = 44'h00000033_300;  // 00000033_00_11_0000_0000
        testvectors[1] = 44'h00000013_104; // 00000013_00_01_0000_0100
        testvectors[2] = 44'h00000063_020; // 00000063_00_00_0010_0000
        testvectors[3] = 44'h00000067_140;  // 00000067_00_01_0100_0000
        testvectors[4] = 44'h0000006F_180; // 0000006F_00_01_1000_0000
        testvectors[5] = 44'h00000017_108;  // 00000017_00_01_0000_1000
        testvectors[6] = 44'h00000037_110; // 00000037_00_01_0001_0000
        testvectors[7] = 44'h00000003_102; // 00000003_00_01_0000_0010
        testvectors[8] = 44'h00000023_001; // 00000023_00_00_0000_0001
        testvectors[9] = 44'bx;          

        vectornum = 0; errors = 0;
        #2;
    end

    always begin
        clk <= 1; #5;     
        clk <= 0; #5;     
    end

    always @(posedge clk) begin
        #1; {instr, notUsed, isALUregT, regWriteT, isJALT, 
             isJALRT, isBranchT, isLUIT, 
             isAUIPCT, isALUimmT, isLoadT, isStoreT} = testvectors[vectornum];
    end

    always @(negedge clk) begin
        if ({isALUreg, regWrite, isJAL, 
             isJALR, isBranch, isLUI, 
             isAUIPC, isALUimm, isLoad, isStore} !== 
            {isALUregT, regWriteT, isJALT, 
             isJALRT, isBranchT, isLUIT, 
             isAUIPCT, isALUimmT, isLoadT, isStoreT}) begin
            $display("Error: output = %b (%b expected)", 
                     {isALUreg, regWrite, isJAL, 
                      isJALR, isBranch, isLUI, 
                      isAUIPC, isALUimm, isLoad, isStore},
                     {isALUregT, regWriteT, isJALT, 
                      isJALRT, isBranchT, isLUIT, 
                      isAUIPCT, isALUimmT, isLoadT, isStoreT});
            $display("vectornum %b", vectornum);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 44'bx) begin 
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish;
        end
    end

endmodule