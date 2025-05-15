module DMemory(clk, a, rd, memWMask, we);
    
    input wire clk,we;
    input wire [3:0] memWMask;      
    input wire [31:0] a, wd;
    output wire [31:0] rd;

    reg [31:0] RAM [0:255];

    
    always @(posedge clk) begin
        if (we) begin
            if (memWMask[0]) RAM[a[31:2]][7:0]   <= wd[7:0];
            if (memWMask[1]) RAM[a[31:2]][15:8]  <= wd[15:8];
            if (memWMask[2]) RAM[a[31:2]][23:16] <= wd[23:16];
            if (memWMask[3]) RAM[a[31:2]][31:24] <= wd[31:24];
        end
    end

    assign rd = RAM[a[31:2]];  

endmodule