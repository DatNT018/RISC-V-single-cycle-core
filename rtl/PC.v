module Program_Counter(
    input wire clk, reset,
    input wire [31:0] d,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 32'b0;
        else
            q <= d;
    end
endmodule