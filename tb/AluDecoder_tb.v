`module AluDecoder_TB;

    reg clk;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg instr_5, isBranch, isALUreg, isALUimm;
    wire [3:0] aluControl;
    wire isShamt;
    reg [3:0] aluControlT;
    reg isShamtT;

    reg [18:0] testvectors [0:20]; 
    reg [31:0] vectornum, errors;

    AluDecoder dut(
        .funct3(funct3), 
        .funct7(funct7), 
        .instr_5(instr_5), 
        .isBranch(isBranch), 
        .isALUreg(isALUreg), 
        .isALUimm(isALUimm), 
        .aluControl(aluControl), 
        .isShamt(isShamt)
    );

    initial begin
        $dumpfile("aluDecoder_tb.vcd");
        $dumpvars(0, AluDecoder_TB); 

        testvectors[0]  = 19'b000_0000000_0_0_0_0_0000_0;
        testvectors[1]  = 19'b000_0100000_0_0_0_1_0000_0;
        testvectors[2]  = 19'b000_0000000_1_0_1_0_0000_0;
        testvectors[3]  = 19'b000_0100000_1_0_1_0_0001_0;
        testvectors[4]  = 19'b000_0100000_1_0_0_1_0001_0;
        testvectors[5]  = 19'b001_0000000_0_0_0_1_0010_1;
        testvectors[6]  = 19'b010_0000000_0_0_1_0_0011_0;
        testvectors[7]  = 19'b011_1111111_0_0_0_1_0100_0;
        testvectors[8]  = 19'b100_0000000_0_0_1_0_0101_0;
        testvectors[9]  = 19'b101_0100000_0_0_0_1_0110_1;
        testvectors[10] = 19'b101_1011111_0_0_0_1_0111_1;
        testvectors[11] = 19'b110_0000000_0_0_0_1_1000_0;
        testvectors[12] = 19'b111_0000000_0_0_1_0_1001_0;
        testvectors[13] = 19'b000_0000000_0_1_0_0_1010_0;
        testvectors[14] = 19'b001_0000000_0_1_0_0_1011_0;
        testvectors[15] = 19'b100_0000000_0_1_0_0_0011_0;
        testvectors[16] = 19'b101_0000000_0_1_0_0_1100_0;
        testvectors[17] = 19'b110_0000000_0_1_0_0_0100_0;
        testvectors[18] = 19'b111_0000000_0_1_0_0_1101_0;
        testvectors[19] = 19'b111_1111111_1_0_0_0_0000_0;
        testvectors[20] = 19'bx; 

        vectornum = 0; errors = 0;
        #2;
    end

    always begin
        clk <= 1; #5;     
        clk <= 0; #5;     
    end

    always @(posedge clk) begin
        #1; {funct3, funct7, instr_5, isBranch, isALUreg, 
             isALUimm, aluControlT, isShamtT} = testvectors[vectornum];
    end

    always @(negedge clk) begin
        if ({aluControl, isShamt} !== {aluControlT, isShamtT}) begin
            $display("Error: output = %b (%b expected)", {aluControl, isShamt}, {aluControlT, isShamtT});
            $display("vectornum %b", vectornum);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 19'bx) begin 
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish;
        end
    end

endmodule