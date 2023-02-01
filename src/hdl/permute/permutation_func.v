module permutation_func (clk, rst, start, input_file_name, output_file_name, donee, cnt_value, line_in, write_enable, write_value);

	input clk;
	input rst;
	input [12*8-1:0] input_file_name;
	input [13*8-1:0] output_file_name;
	input start;
	input [24:0] line_in;
	output reg donee;
	output reg write_enable;
	output [6:0] cnt_value;
	output [24:0] write_value;

	wire counter_64_co;
	wire write_en;
	wire reg_en;
	wire mux_en;
	wire cnt_64_en;
	wire done;
	wire reg_rst;
	wire permute_en;
	wire read_en;
	wire [24:0] write_val;

	assign donee = counter_64_co;
	assign write_enable = write_en;
	assign write_value = write_val;

	controller_3 cntrl( .start(start), .counter_64_co(counter_64_co), .rst(rst), .clk(clk), .write_en(write_en), .read_en(read_en), .mux_en(mux_en),
	.reg_en(reg_en), .cnt_64_en(cnt_64_en), .done(done), .reg_rst(reg_rst), .permute_en(permute_en) );

	datapath_3 dp(.clk(clk), .rst(rst), .input_file_name(input_file_name), .write_en(write_en), .read_en(read_en), .reg_en(reg_en), .cnt_64_en(cnt_64_en), 
			.mux_en(mux_en),	.reg_rst(reg_rst), .output_file_name(output_file_name), .permute_en(permute_en), 
			.counter_co(counter_64_co), .cnt_value(cnt_value), .line_in(line_in), .write_value(write_val));



endmodule
