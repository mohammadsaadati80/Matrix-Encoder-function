module rotate_top (clk, rst, rotate_en, donee, cnt_value, line_in, write_enable, write_value);

	input clk;
	input rst;
	input [24:0] line_in;
    input rotate_en;
	output reg donee;
	output reg write_enable;
	output [5:0] cnt_value;
	output [24:0] write_value;

	wire counter_64_co;
    wire counter_25_co;
	wire write_en;
	wire reg_en;
	wire cnt_64_en;
    wire cnt_25_en;
	wire done;
	wire [24:0] write_val;
	wire cnt_rst_64;
    wire cnt_rst_25;
    wire [24:0] mem_out [0:63];
    
    wire read_en; //TODO
    wire file_write; //TODO

	assign donee = done;
	assign write_enable = write_en;
	assign write_value = write_val;


    controller_2 cntrl(.cnt24_en(cnt_en_25), .cnt64_en(cnt_en_64), .cnt24_rst(cnt_rst_25), .cnt64_rst(cnt_rst_64) , .read_en(read_en), .wr_en(write_en), 
        .rotate_en(rotate_en), .cnt24_co(counter_25_co), .cnt64_co(counter_64_co), .rst(rst), .clk(clk), .done(done), .file_write(file_write));

    datapath_2 dp(.clk(clk), .rst(rst), .wr_en(write_en), .inreg_en(reg_en),
                .cnt_en_64(cnt_en_64), .cnt_en_25(cnt_en_25), .cnt_co_25(counter_25_co), .cnt_co_64(counter_64_co), .cnt_value(cnt_value), 
                .mem_line(line_in), .write_value(write_val), .cnt_rst_64(cnt_rst_64), .cnt_rst_25(cnt_rst_25), .mem_out(mem_out));


endmodule