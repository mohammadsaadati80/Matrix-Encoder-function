`timescale 1ns/1ns

module testbench();

    reg clk = 0, rst = 0, start = 0;
    wire done;

    integer i = 0;
    reg [12*8:1] input_file_name = "input_0.txt";
    reg [13*8:1] output_file_name = "output_0.txt";

    permutation_func uut(.clk(clk), .rst(rst), .start(start), .input_file_name(input_file_name), .output_file_name(output_file_name), .donee(done));

    always #10 clk = ~clk;
    initial begin
        // $sformat(input_file_name, "input_%0d.txt", i);
        // $sformat(output_file_name, "output_%0d.txt", i);
        rst = 1;
        #23 rst = 0;
        #33 start = 1;
        // while (i < 3) begin
        //     if (done) begin
        //         #23 rst = 1;
        //         i = i + 1;
        //         $sformat(input_file_name, "input_%0d.txt", i);
        //         $sformat(output_file_name, "output_%0d.txt", i);
        //         #23 rst = 0;
        //     end
        // end
        #7700 start = 0;
        $finish;
    end

endmodule