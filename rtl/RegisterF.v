module Register_File(
    input wire clk,we3,                                     
    input wire [4:0] a1, a2, a3,     
    input wire [31:0] wd3,           
    output wire [31:0] rd1, rd2);

    reg [31:0] rf [31:0];               
   
    always @(posedge clk) begin
        if (we3)    rf[a3] <= wd3;
    end

    assign rd1 = (a1 != 32'b0) ? rf[a1] : 32'b0;  
    assign rd2 = (a2 != 32'b0) ? rf[a2] : 32'b0;  

endmodule