module datapath (clk, rst, wr_en, inreg_en, cnt_en_24, 
				cnt_co_24, cnt_value, mem_line, write_value, cnt_rst_24
				, colParity_en, rotate_en, permute_en, revaluate_en, addRC_en,
				done1, done2, done3, done4, done5,  data_out);
	
	input clk;
	input rst;
	input wr_en;
	input inreg_en;
	input cnt_en_24;
	input [24:0] mem_line;
	input cnt_rst_24;
	input colParity_en;
	input rotate_en;
	input permute_en;
	input revaluate_en;
	input addRC_en;
    output cnt_co_24;
	output [5:0] cnt_value;
	output [24:0] write_value;
	output reg [24:0] data_out [0:63];
	
    wire [4:0] cnt_24_value;
	wire [24:0] col_parity_out;
	wire [24:0] reg_out;
	output done1;
	output done2;
	output done3;
	output done4;
	output done5;

	reg [24:0] mem_out_1 [0:63];
	wire [24:0] mem_out_2 [0:63];
	reg [24:0] mem_out_3 [0:63];
	reg [24:0] mem_out_4 [0:63];
	wire [24:0] mem_out_5 [0:63];
	wire [6:0] cnt_value1;
	wire [5:0] cnt_value2;
	wire [6:0] cnt_value3;
	wire [5:0] cnt_value4;
	wire [5:0] cnt_value5;
	reg [24:0] line_in1;
	reg [24:0] line_in2;
	reg [24:0] line_in3;
	reg [24:0] line_in4;
	reg [24:0] line_in5;
	wire write_enable1;
	wire write_enable2;
	wire write_enable3;
	wire write_enable4;
	wire write_enable5;
	wire [24:0] write_value1;
	wire [24:0] write_value2;
	wire [24:0] write_value3;
	reg [24:0] write_value4;
	wire [24:0] write_value5;
	reg [1600-1 : 0] datain;
	wire [1600-1 : 0] dataout;

	assign cnt_value = colParity_en ? cnt_value1 : 
						rotate_en ? cnt_value2 :
						permute_en ? cnt_value3 :
						revaluate_en ? cnt_value4 :
						addRC_en ? cnt_value5 : cnt_value;
	assign write_value = cnt_co_24 ? mem_out_5[cnt_value5] : write_value;

	
	// assign mem_out_1[(cnt_value1+1)%64] = write_value1; 
	// assign mem_out_3[(cnt_value3 - 7'b0111111)%64] = write_value3; 
	integer colParity_i;
	integer permute_i;
	integer revaluate_i;
	integer addRC_i;
	integer i;
	integer j;

	always @(*) begin
		if (colParity_en) begin
			colParity_i = (cnt_value1+1)%64;
			mem_out_1[colParity_i] <= write_value1; 
		end
		if (permute_en) begin
			permute_i = cnt_value3 - 7'b0111111;
			mem_out_3[permute_i] <= write_value3;
		end
		if (addRC_en)
			addRC_i = cnt_24_value - 5'b01000;
		if (revaluate_en) begin
			
		end
	end

	always @(revaluate_en) begin
		for (i = 0; i < 64; i = i + 1) begin
				for (j = 0; j < 25; j = j + 1) begin
					revaluate_i = (j + i*25);
					datain[revaluate_i] <= mem_out_3[i][j];
				end
			end
	end
	
	always @(done4) begin
		for (i = 0; i < 64; i = i + 1) begin
				for (j = 0; j < 25; j = j + 1) begin
					revaluate_i = (j + i*25);
					mem_out_4[i][j] <= dataout[revaluate_i];
				end
			end
	end

	always @(done5) begin
		for(i = 0; i < 64; i = i + 1) begin 
			data_out[i] = mem_out_5[i];
        end
	end

	assign line_in1 = (cnt_24_value == 5'b01000) ? mem_line : mem_out_5[colParity_i]; 
	assign line_in2 = mem_out_1[cnt_value2];
	assign line_in3 = mem_out_2[permute_i];
	assign line_in4 = mem_out_3[cnt_value4];
	assign line_in5 = mem_out_4[cnt_value5];

    counter_5 #(5) cnt24(.clk(clk), .en(cnt_en_24), .pin(cnt_24_value), .pout(cnt_24_value), .rst(cnt_rst_24), .co(cnt_co_24), .rst_value(5'b01000), .select(1'b1), .ld(1'b0));
	register reg1(.clk(clk), .pin(mem_line), .en(inreg_en), .rst(rst), .pout(reg_out));

	colParity_func colParity1(.clk(clk), .rst(rst), .start(colParity_en), .donee(done1), .cnt_value(cnt_value1), .line_in(line_in1),
							 .write_enable(write_enable1), .write_value(write_value1));
	rotate_top rotate1(.clk(clk), .rst(rst), .rotate_en(rotate_en), .donee(done2), .cnt_value(cnt_value2), .line_in(line_in2), 
							.write_enable(write_enable2), .write_value(write_value2), .data_out(mem_out_2));
	permutation_func permutation1(.clk(clk), .rst(rst), .start(permute_en), .input_file_name("123456789123"), .output_file_name("1234567891234"), 
				.donee(done3), .cnt_value(cnt_value3), .line_in(line_in3), .write_enable(write_enable3), .write_value(write_value3));
	Revaluate revaluate1(.clk(clk), .rst(rst), .start(revaluate_en), .data_in(datain), .done(done4), .data_out(dataout));
	addRC_Top addRC1(.clk(clk), .rst(rst), .addrc_en(addRC_en), .donee(done5), .cnt_value(cnt_value5), .line_in(line_in5),
					 .write_enable(write_enable5), .write_value(write_value5), .data_out(mem_out_5), .cnt24_value(addRC_i));

endmodule

