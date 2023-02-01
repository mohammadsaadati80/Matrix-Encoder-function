module datapath_1 (clk, rst, wr_en, inreg_en, cnt_en, 
				cnt_co, cnt_value, mem_line, write_value, cnt_rst);
	
	input clk;
	input rst;
	input wr_en;
	input inreg_en;
	input cnt_en;
	input [24:0] mem_line;
	input cnt_rst;
	output cnt_co;
	output [6:0] cnt_value;
	output [24:0] write_value;
	
	wire [6:0] cnt_64_value;
	wire [24:0] col_parity_out;
	wire [24:0] reg_out;

	assign cnt_value = cnt_64_value;
	assign write_value = col_parity_out;

	counter_1 #(7) cnt1(.clk(clk), .en(cnt_en), .pin(cnt_64_value), .pout(cnt_64_value), .select(1'b1), .rst(cnt_rst), .ld(1'b0), .co(cnt_co));
	register_1 reg1(.clk(clk), .pin(mem_line), .en(inreg_en), .rst(rst), .pout(reg_out));
	colParity colParity1(.input1(reg_out), .input2(mem_line), .output_line(col_parity_out));

endmodule