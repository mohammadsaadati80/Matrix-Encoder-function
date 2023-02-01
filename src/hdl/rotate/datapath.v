module datapath_2 (clk, rst, wr_en_1, wr_en_2, inreg_en, cnt_en_64, cnt_en_25, 
				cnt_co_25, cnt_co_64, cnt_value, mem_line, write_value, cnt_rst_64, cnt_rst_25, mem_out, data_out);
	
	input clk;
	input rst;
	input wr_en_1;
	input wr_en_2;
	input inreg_en;
	input cnt_en_25;
    input cnt_en_64;
	input [24:0] mem_line;
	input cnt_rst_25;
    input cnt_rst_64;
    input [24:0] mem_out [0:63];
	output cnt_co_64;
    output cnt_co_25;
	output [5:0] cnt_value;
	output [24:0] write_value;
	output reg [24:0] data_out [0:63];
	
	wire [5:0] cnt_64_value;
    wire [4:0] cnt_25_value;
	wire [24:0] col_parity_out;
	wire [24:0] reg_out;

	assign cnt_value = cnt_64_value;
	assign write_value = col_parity_out;
	// assign data_out = mem_out;
	// assign data_out[0] = mem_out[0];
	integer i = 0;
	always @(*) begin
		for(i = 0; i < 64; i = i + 1) begin 
			data_out[i] = mem_out[i];
        end
	end

	counter #(6) cnt64(.clk(clk), .en(cnt_en_64), .pin(cnt_64_value), .pout(cnt_64_value), .rst(cnt_rst_64), .co(cnt_co_64), .rst_value(6'b000000), .select(1'b1), .ld(1'b0));
    counter #(5) cnt25(.clk(clk), .en(cnt_en_25), .pin(cnt_25_value), .pout(cnt_25_value), .rst(cnt_rst_25), .co(cnt_co_25), .rst_value(5'b00111), .select(1'b1), .ld(1'b0));
	register reg1(.clk(clk), .pin(mem_line), .en(inreg_en), .rst(rst), .pout(reg_out));
	rotate  rotate1(.mem(mem_out), .cnt24_value(cnt_25_value), .cnt64_value(cnt_64_value), .wr_en_1(wr_en_1), .wr_en_2(wr_en_2), .slice(mem_line));

endmodule

