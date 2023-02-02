`timescale 1ns/1ns

module testbench();

    reg clk = 0, rst = 0, start = 0;
    wire done;
    wire [5:0] cnt_value;
    reg [24:0] line_in;
    wire wr_en;
    wire [24:0] wr_val;

    integer i;
    integer j = 0;
    reg [12*8:1] input_file_name;
    reg [13*8:1] output_file_name;
    integer f;

    reg [24:0] mem [0:63];
    wire[24:0] data_out [0:63];

    encoder_top uut(.clk(clk), .rst(rst), .start(start),
	 .donee(done), .cnt_value(cnt_value), .line_in(line_in), .write_enable(wr_en), .write_value(wr_val), .data_out(data_out));

    assign line_in = mem[(cnt_value+1)%64];

    always @(negedge done) begin
        // if (done) begin
            for (i=0; i<=63; i=i+1) begin
                f = $fopen(output_file_name,"a");
	            $fwrite(f,"%b",data_out[i]);
	            $fwrite(f,"\n");
        // end
        end
    end
    
    always @(posedge done) begin
	    j = j + 1;
        $sformat(input_file_name, "input_%0d.txt", j);
        $sformat(output_file_name, "output_%0d.txt", j-1);
	    $readmemb (input_file_name, mem);
	    start = 0;
        rst = 1;
        #23 rst = 0;
        #33 start = 1;
    end

    always #10 clk = ~clk;
    initial begin
	$sformat(input_file_name, "input_%0d.txt", j);
	$sformat(output_file_name, "output_%0d.txt", j-1);
	  for (i=0; i<=63; i=i+1)
    		mem[i] = 25'b0;
  	  $readmemb (input_file_name, mem);

        rst = 1;
        #23 rst = 0;
        #33 start = 1;
        #(3*25*137000) start = 0;
        $finish;
    end

endmodule
