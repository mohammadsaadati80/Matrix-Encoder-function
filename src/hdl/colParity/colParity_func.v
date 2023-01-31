module colParity_func (clk, rst, start, donee, cnt_value, line_in, write_enable, write_value);

	input clk;
	input rst;
	input start;
	input [24:0] line_in;
	output reg donee;
	output reg write_enable;
	output [6:0] cnt_value;
	output [24:0] write_value;

	wire counter_64_co;
	wire write_en;
	wire reg_en;
	wire cnt_64_en;
	wire done;
	wire [24:0] write_val;
	wire cnt_rst;

	assign donee = done;
	assign write_enable = write_en;
	assign write_value = write_val;

	controller cntrl( .start(start), .cnt_co(counter_64_co), .rst(rst), .clk(clk), .wr_en(write_en),
	.inreg_en(reg_en), .cnt_en(cnt_64_en), .done(done), .cnt_rst(cnt_rst) );

	datapath dp(.clk(clk), .rst(rst), .wr_en(write_en), .inreg_en(reg_en), .cnt_en(cnt_64_en),  
			.cnt_co(counter_64_co), .cnt_value(cnt_value), .mem_line(line_in), .write_value(write_val), .cnt_rst(rst));


endmodule