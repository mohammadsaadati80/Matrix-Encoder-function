`timescale 1ns/1ns

module testbench();

    reg clk = 0, rst = 0, start = 0;
    wire done;
    wire [6:0] cnt_value;
    reg [24:0] line_in;
    wire wr_en;
    wire [24:0] wr_val;

    integer i;
    integer j = 9;
    reg [12*8:1] input_file_name;
    reg [13*8:1] output_file_name;
    integer f;

    reg [24:0] mem [0:63];

    permutation_func uut(.clk(clk), .rst(rst), .start(start), .input_file_name(input_file_name), .output_file_name(output_file_name),
	 .donee(done), .cnt_value(cnt_value), .line_in(line_in), .write_enable(wr_en), .write_value(wr_val));

    assign line_in = mem[cnt_value - 7'b0111111];

    always @(posedge wr_en) begin
	f = $fopen(output_file_name,"a");
	$fwrite(f,"%b",wr_val);
	$fwrite(f,"\n");
    end
    
    always @(posedge done) begin
	    j = j + 1;
        $sformat(input_file_name, "%0d.in", j);
        $sformat(output_file_name, "output_%0d.txt", j);
	    $readmemb (input_file_name, mem);
	start = 0;
        rst = 1;
        #23 rst = 0;
        #33 start = 1;
    end

    always #10 clk = ~clk;
    initial begin
	$sformat(input_file_name, "%0d.in", j);
	$sformat(output_file_name, "output_%0d.txt", j);
        // $sformat(input_file_name, "input_%0d.txt", i);
        // $sformat(output_file_name, "output_%0d.txt", i);
	  for (i=0; i<=63; i=i+1)
    		mem[i] = 25'b0;
  	  $readmemb (input_file_name, mem);

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
        #(4*7750) start = 0;
        $finish;
    end

endmodule
