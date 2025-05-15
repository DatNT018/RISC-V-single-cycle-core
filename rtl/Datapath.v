module Datapath(
    input wire clk, reset,
    input wire isALUreg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isLoad, isStore, isShamt,
    input wire [2:0] funct3,
    input wire [3:0] aluControl,
    input wire [31:0] instr, memRdata,
    output wire [31:0] pc, aluOut, memWdata, aluIn1, aluIn2,
    output wire [4:0] rs1Id, rs2Id, rdId,
    output wire [3:0] memWMask,
    output wire isZero);

    wire [1:0] memByteAccess, memHalfwordAccess;
    wire [7:0] loadByte;
    wire [15:0] loadHalfword;
    wire [31:0] pcNext, pcplus4, pcplusImm, aluIn2Pre, rd2, wd3, loadData, ImmExt;
    wire [4:0] shamt;
    wire loadSign;

    Program_Counter pcreg(.clk(clk), .reset(reset), .d(pcNext), .q(pc));
    
    Adder pcadd1(.a(pc), .b(32'b100), .y(pcplus4));

   
    RegisterFile regF(.clk(clk), 
                        .we3(regWrite), 
                        .a1(rs1Id), 
                        .a2(rs2Id), 
                        .a3(rdId), 
                        .wd3(wd3), 
                        .rd1(aluIn1), 
                        .rd2(rd2));


    Alu alu(.aluControl(aluControl), 
            .op1(aluIn1), 
            .op2(aluIn2), 
            .aluOut(aluOut), 
            .Zero(isZero));

   
    Extend immgen(
        .instr(instr),
        .isLUI(isLUI),
        .isAUIPC(isAUIPC),
        .isALUimm(isALUimm),
        .isLoad(isLoad),
        .isStore(isStore),
        .isBranch(isBranch),
        .isJAL(isJAL),
        .isJALR(isJALR),
        .imm(imm)
    );

    PCMux pcmux(
        .isBranch(isBranch),
        .isZero(isZero),
        .isJAL(isJAL),
        .isJALR(isJALR),
        .pcplus4(pcplus4),
        .pcplusImm(pcplusImm),
        .aluOut(aluOut),
        .pcNext(pcNext)
    );

    ALUMux alumux(
        .isALUreg(isALUreg),
        .isBranch(isBranch),
        .isStore(isStore),
        .isShamt(isShamt),
        .rd2(rd2),
        .ImmExt(ImmExt),
        .shamt(shamt),
        .aluIn2(aluIn2)
    );

    //data handle
    assign memByteAccess     = funct3[1:0] == 2'b00;
    assign memHalfwordAccess = funct3[1:0] == 2'b01;

    assign loadHalfword = aluOut[1] ? memRdata[31:16] : memRdata[15:0];
    assign loadByte = aluOut[0] ? loadHalfword[15:8] : loadHalfword[7:0];

    assign loadData = memByteAccess ? {{24{loadSign}}, loadByte} :
                      memHalfwordAccess ? {{16{loadSign}}, loadHalfword} :
                      memRdata;

    assign memWdata[7:0]  = rd2[7:0];
    assign memWdata[15:8] = aluOut[0] ? rd2[7:0] : rd2[15:8];
    assign memWdata[23:16] = aluOut[1] ? rd2[7:0] : rd2[23:16];
    assign memWdata[31:24] = aluOut[0] ? rd2[7:0] :
                             aluOut[1] ? rd2[15:8] : rd2[31:24];

    assign memWMask = memByteAccess ?
                      (aluOut[1] ?
                           (aluOut[0] ? 4'b1000 : 4'b0100) :
                           (aluOut[0] ? 4'b0010 : 4'b0001)) :
                      memHalfwordAccess ? (aluOut[1] ? 4'b1100 : 4'b0011) :
                      4'b1111;

    //PC_Target and MuX
    assign pcplusImm = pc + ImmExt; 

    //WB
    assign wd3 = (isJAL || isJALR) ? pcplus4 :
                 isLUI ? ImmExt : 
                 isAUIPC ? pcplusImm : 
                 isLoad ? loadData :
                 aluOut;

  
    assign rs1Id = instr[19:15];
    assign rs2Id = instr[24:20];
    assign rdId  = instr[11:7];

    
    assign shamt = isALUreg ? rd2[4:0] : instr[24:20];
    assign loadSign = !funct3[2] & (memByteAccess ? loadByte[7] : loadHalfword[15]);

endmodule