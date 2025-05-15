module Imemory(
    input wire [7:0] a,      // Địa chỉ 8 bit
    output wire [31:0] rd    // Lệnh 32 bit đọc ra
);

    reg [31:0] mem_block[0:255];  
    //0x1010	addi x8, x10, 100	06450513	I-type	imm=100, rs1=x10, f3=000, rd=x8, op=0010011
    //0x1000 L7: lw x6, -4(x9) I 111111111100 01001 010 00110 0000011 FFC4A303
    initial begin
        initial
        $readmemh("imemfile.dat", mem_block);
        
    end
    assign rd = mem_block[a];       

endmodule