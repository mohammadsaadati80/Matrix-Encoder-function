module datapath_3 (clk, rst, input_file_name, write_en, read_en, mux_en, reg_en, cnt_64_en, 
				reg_rst, output_file_name, permute_en, counter_co, cnt_value, line_in, write_value);
	
	input clk;
	input rst;
	input [12*8-1:0] input_file_name;
	input write_en;
	input read_en;
	input mux_en;
	input reg_en;
	input cnt_64_en;
	input reg_rst; 
	input [13*8-1:0] output_file_name;
	input permute_en;
	input [24:0] line_in;
	output counter_co;
	output [6:0] cnt_value;
	output [24:0] write_value;
	
	wire [24:0] line;
	wire [6:0] cnt_64_value;
	wire [24:0] permutation_out;
	wire [24:0] reg_out;
	wire [24:0] mux2to1_out;
	assign cnt_value = cnt_64_value;
	assign write_value = reg_out;

	counter_3 #(7) cnt1(.clk(clk), .en(cnt_64_en), .pin(cnt_64_value), .pout(cnt_64_value), .select(1'b1), .rst(rst), .ld(1'b0), .co(counter_co));
	read_from_file_3 reader1(.clk(clk), .en(read_en),  .line_in(line_in), .line(line));
	register_3 reg1(.clk(clk),.pin(mux2to1_out),.en(reg_en),.rst(reg_rst),.pout(reg_out));
	swap swap1(.input_line(reg_out), .swap_en(permute_en), .output_line(permutation_out));
	mux2to1_3 #(25) mux1 (.a(line),.b(permutation_out),.s(mux_en),.w(mux2to1_out));
	//write_to_file write1(.output_file_name(output_file_name), .line(reg_out), .en(write_en));

endmodule