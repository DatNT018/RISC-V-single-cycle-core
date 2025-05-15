`timescale 1ns / 1ps

module RiscV_TB;

    reg clk, reset;
    reg [1:0] flag;
    wire [31:0] instr, memWdata, addr, pc, aluIn1, aluIn2, Simm, Jimm, Bimm, Iimm, memRdata;
    wire [4:0] rs1Id, rs2Id, rdId, leds;
    wire [3:0] memWMask, aluControl;
    wire isALUreg, 
         regWrite,
         isJAL,
         isJALR,
         isBranch,
         isLUI,
         isAUIPC,
         isALUimm,
         isLoad, 
         isStore,
         isShamt;

    RiscV dut(
        .clk(clk), 
        .reset(reset),
        .pc(pc), 
        .instr(instr), 
        .memWdata(memWdata), 
        .addr(addr), 
        .aluIn1(aluIn1), 
        .aluIn2(aluIn2),
        .Simm(Simm),
        .Jimm(Jimm),
        .Bimm(Bimm), 
        .Iimm(Iimm),
        .memRdata(memRdata),
        .rs1Id(rs1Id), 
        .rs2Id(rs2Id), 
        .rdId(rdId),
        .memWMask(memWMask),
        .aluControl(aluControl),
        .isALUreg(isALUreg), 
        .regWrite(regWrite),
        .isJAL(isJAL),
        .isJALR(isJALR),
        .isBranch(isBranch),
        .isLUI(isLUI),
        .isAUIPC(isAUIPC),
        .isALUimm(isALUimm),
        .isLoad(isLoad), 
        .isStore(isStore),
        .isShamt(isShamt),
        .leds(leds)
    );

    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, RiscV_TB);
    
        flag = 0;
        reset = 1; #15; 
        reset = 0; #2;
    end

    always begin
        clk <= 1; #5;     
        clk <= 0; #5;     
    end

    always @(negedge clk) begin
        if (pc == 8'h2c && leds == 5'he)
            flag = 1;
        if (rdId == 8'h1e && addr == 8'h36 && flag)
            flag = flag + 1;
        if (rdId == 8'h0 && flag == 2'b10)
            $finish;
    end

endmodule