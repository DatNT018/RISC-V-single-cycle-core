module FlopR_TB;

    reg clk, reset;
    reg [31:0] d, q;

    Program_Counter dut(clk, reset, d, q);

    initial begin
        reset = 1; #15; 
        reset = 0; #2;
    end

    always begin
        clk <= 1; #5;     
        clk <= 0; #5;     
    end

    always @(posedge clk) begin
        #1; d <= 32'b100;
    end

    always @(negedge clk) begin
        if (q == 32'b100) begin
            $finish;
        end
    end

    initial begin
        $dumpfile("PC_tb.vcd");
        $dumpvars(0, PC_tb);
    end

endmodule