module encoder_top (clk, rst, start, donee, cnt_value, line_in, write_enable, write_value, data_out);

	input clk;
	input rst;
	input start;
	input [24:0] line_in;
	output reg donee;
	output reg write_enable;
	output [5:0] cnt_value;
	output [24:0] write_value;
	output [24:0] data_out [0:63];

	wire counter_24_co;
	wire write_en;
	wire colParity_en;
	wire rotate_en;
	wire permute_en;
	wire revalute_en;
	wire addRC_en;
	wire reg_en;
	wire cnt_24_en;
	wire done;
	wire [24:0] write_val;
	wire cnt_rst;
	wire done1;
	wire done2;
	wire done3;
	wire done4;
	wire done5;

	assign donee = done;
	assign write_enable = write_en;
	assign write_value = write_val;

	controller cntrl( .cnt_en(cnt_24_en), .cnt_rst(cnt_rst), .start(start), .cnt_co(counter_24_co), .rst(rst), .clk(clk), .done(done), .wr_en(write_en),
		.colParity_en(colParity_en), .rotate_en(rotate_en), .permute_en(permute_en), .revalute_en(revalute_en), .addRC_en(addRC_en),
		.done1(done1), .done2(done2), .done3(done3), .done4(done4), .done5(done5));

	datapath dp(.clk(clk), .rst(rst), .wr_en(write_en), .inreg_en(reg_en), .cnt_en_24(cnt_24_en), .cnt_co_24(counter_24_co), .cnt_value(cnt_value), 
	.mem_line(line_in), .write_value(write_val), .cnt_rst_24(rst),
	.colParity_en(colParity_en), .rotate_en(rotate_en), .permute_en(permute_en),
	 .revaluate_en(revalute_en), .addRC_en(addRC_en),
	 .done1(done1), .done2(done2), .done3(done3), .done4(done4), .done5(done5), .data_out(data_out));


endmodule
