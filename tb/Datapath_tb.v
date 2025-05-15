`timescale 1ns / 1ps

module Datapath_TB;

    reg clk, reset, 
        memtoreg, isALUreg, regWrite, 
        isJAL, isJALR, isBranch, isLUI, 
        isAUIPC, isLoad, isStore, isShamt;
    reg [2:0] funct3;
    reg [3:0] aluControl;
    reg [31:0] instr, memRdata;
    wire [31:0] pc, aluOut, memWdata, aluIn1, aluIn2;
    wire [3:0] memWMask;
    wire isZero;

    reg [31:0] counter;

    Datapath dut(
        .clk(clk), 
        .reset(reset), 
        .isALUreg(isALUreg), 
        .regWrite(regWrite), 
        .isJAL(isJAL), 
        .isJALR(isJALR), 
        .isBranch(isBranch), 
        .isLUI(isLUI), 
        .isAUIPC(isAUIPC), 
        .isLoad(isLoad), 
        .isStore(isStore), 
        .isShamt(isShamt),
        .funct3(funct3), 
        .aluControl(aluControl), 
        .instr(instr), 
        .memRdata(memRdata),
        .pc(pc), 
        .aluOut(aluOut), 
        .memWdata(memWdata), 
        .aluIn1(aluIn1), 
        .aluIn2(aluIn2), 
        .memWMask(memWMask), 
        .isZero(isZero)
    );

    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, Datapath_TB); // Dump all variables
        counter = 0;
        reset = 1;
        instr = 0;
        memRdata = 0;
        isALUreg = 0; regWrite = 0; isJAL = 0; isJALR = 0;
        isBranch = 0; isLUI = 0; isAUIPC = 0; isLoad = 0;
        isStore = 0; isShamt = 0; funct3 = 0; aluControl = 0;
        memtoreg = 0; 
        #15; reset = 0; #2;

        //// add x1, x2, x3
        instr = 32'h003100B3; 
        isALUreg = 1; regWrite = 1;
        funct3 = 3'b000; aluControl = 4'b0000;
        #10;

        //// addi x1, x2, 4
        instr = 32'h00410093; 
        isALUreg = 0; isALUimm = 1; regWrite = 1;
        funct3 = 3'b000; aluControl = 4'b0000;
        #10;

        //// lw x1, 8(x2)
        instr = 32'h00812083; 
        isALUimm = 0; isLoad = 1; regWrite = 1;
        funct3 = 3'b010; aluControl = 4'b0000;
        memRdata = 32'hDEADBEEF;
        memtoreg = 1;
        #10;

        //// sw x1, 12(x2)
        instr = 32'h00112623; 
        isLoad = 0; isStore = 1; regWrite = 0;
        funct3 = 3'b010; aluControl = 4'b0000;
        memtoreg = 0;
        #10;

        //// beq x1, x2, 16
        instr = 32'h00208463; 
        isStore = 0; isBranch = 1;
        funct3 = 3'b000; aluControl = 4'b0001; 
        #10;

        //// jal x1, 20
        instr = 32'h014000EF; 
        isBranch = 0; isJAL = 1; regWrite = 1;
        funct3 = 3'b000; aluControl = 4'b0000;
        #10;

        //// lui x1, 0x12345
        instr = 32'h1234537; 
        isJAL = 0; isLUI = 1; regWrite = 1;
        funct3 = 3'b000; aluControl = 4'b0000;
        #10;

        // End simulation
        #5; $finish;
    end

    always begin
        clk <= 1; #5;     
        clk <= 0; #5;     
    end

    always @(posedge clk) begin
        #1; counter = counter + 1;
    end

endmodule