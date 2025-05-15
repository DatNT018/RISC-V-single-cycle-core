`timescale 1ns / 1ps

module RiscV(
    input wire clk, reset,
    output wire [31:0] pc, instr, memWdata, addr, aluIn1, aluIn2, Simm, Jimm, Bimm, Iimm, memRdata,
    output wire [4:0] rs1Id, rs2Id, rdId,
    output wire [3:0] memWMask, aluControl,
    output wire isALUreg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isALUimm, isLoad, isStore, isShamt
);

    wire isZero, isRAM;
    wire [2:0] funct3;
    wire [6:0] funct7;

    Decoder decoder(
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

    AluDecoder aluD(
        .funct3(funct3),
        .funct7(funct7),
        .op5(instr[5]),
        .isBranch(isBranch),
        .isALUreg(isALUreg),
        .isALUimm(isALUimm),
        .aluControl(aluControl),
        .isShamt(isShamt)
    );

    Datapath dpath(
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
        .addr(addr),
        .memWdata(memWdata),
        .aluIn1(aluIn1),
        .aluIn2(aluIn2),
        .Simm(Simm),
        .Jimm(Jimm),
        .Bimm(Bimm),
        .Iimm(Iimm),
        .rs1Id(rs1Id),
        .rs2Id(rs2Id),
        .rdId(rdId),
        .memWMask(memWMask),
        .isZero(isZero)
    );

    IMemory imem(
        .a(pc[9:2]),
        .rd(instr)
    );

    DMemory dmem(
        .clk(clk),
        .we({{4{isStore & isRAM}} & memWMask}),
        .a(addr),
        .wd(memWdata),
        .rd(memRdata)
    );

    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign isRAM = (addr[31:28] == 4'h8);
   

endmodule