`timescale 1ns/1ns

module TB()

    reg clk = 0, rst = 0, start = 0;

    permutation_func test(clk, rst, start, "input.txt", "output.txt");

    always #10 clk = ~clk;
    initial begin
        rst = 1;
        #10 rst = 0;
        #10 start = 1;
        #10 start = 0;
        #10000 $finish;

    end

endmodule