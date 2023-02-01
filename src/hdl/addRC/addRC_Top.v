module addRC_Top (clk, rst, addrc_en, donee, cnt_value, line_in, write_enable, write_value, data_out, cnt24_value);

	input clk;
	input rst;
	input [24:0] line_in;
    input addrc_en;
	input [4:0] cnt24_value;
	output reg donee;
	output reg write_enable;
	output [5:0] cnt_value;
	output [24:0] write_value;
	output [24:0] data_out [0:63];

	wire counter_64_co;
	wire xor_enable;
	wire reg_en;
	wire cnt_64_en;
	wire done;
	wire [24:0] write_val;
	wire cnt_rst_64;
    wire [24:0] mem_out [0:63];
    
    wire read_en; //TODO
    wire file_write; //TODO

	assign donee = done;
	assign write_enable = xor_enable;
	assign write_value = write_val;

    controller_5 cntrl( .cnt64_en(cnt_64_en), .cnt64_rst(cnt_rst_64) , .read_en(read_en), .xor_en(xor_enable),
        .addrc_en(addrc_en), .cnt64_co(counter_64_co), .rst(rst), .clk(clk), .done(done), .file_write(file_write));

    datapath_5 dp(.clk(clk), .rst(rst), .xor_en(xor_enable), .inreg_en(reg_en),
                .cnt_en_64(cnt_64_en), .cnt_co_64(counter_64_co), .cnt_value(cnt_value), .cnt24_value(cnt24_value),
                .mem_line(line_in), .write_value(write_val), .cnt_rst_64(cnt_rst_64), .mem_out(mem_out), .data_out(data_out));


endmodule
