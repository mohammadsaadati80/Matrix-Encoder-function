module datapath (clk, rst, input_file_name, write_en, read_en, mux_en, reg_en, cnt_64_en, 
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

	counter #(7) cnt1(.clk(clk), .en(cnt_64_en), .pin(cnt_64_value), .pout(cnt_64_value), .select(1'b1), .rst(rst), .ld(1'b0), .co(counter_co));
	read_from_file reader1(.clk(clk), .en(read_en),  .line_in(line_in), .line(line));
	register reg1(.clk(clk),.pin(mux2to1_out),.en(reg_en),.rst(reg_rst),.pout(reg_out));
	swap swap1(.input_line(reg_out), .swap_en(permute_en), .output_line(permutation_out));
	mux2to1 #(25) mux1 (.a(line),.b(permutation_out),.s(mux_en),.w(mux2to1_out));
	//write_to_file write1(.output_file_name(output_file_name), .line(reg_out), .en(write_en));

endmodule

module controller (
	start, counter_64_co, rst, clk, write_en , read_en, mux_en,
	reg_en , cnt_64_en, done, reg_rst, permute_en
);

	input start;
	input counter_64_co;
	input rst;
	input clk;
	output reg permute_en;
	output reg write_en; 
	output reg read_en; 
	output reg mux_en;
	output reg reg_en;
	output reg cnt_64_en;
	output reg done;
	output reg reg_rst;

	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , Beginn = 1 , Read = 2 , PassInput = 3, Swap = 4 , PassOutput = 5, Write = 6; 
	reg check_start;


	assign check_start = (counter_64_co) ? 0 : start ;

	always@(posedge clk , posedge rst) begin
		if (rst == 1'b1)
			ps <= Idle;
		else
			ps <= ns;
	end

	always@(ps, start, counter_64_co) begin
		ns = Idle ;
		case (ps)
			Idle:
				ns = (check_start) ? Beginn : Idle;
			Beginn:
				ns = Read;
			Read:
				ns = PassInput;
			PassInput:
				ns = Swap;
			Swap:
				ns = PassOutput ;
			PassOutput:
				ns = Write;
			Write:
				ns = (counter_64_co) ? Idle : Beginn;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , counter_64_co) begin
		write_en = 1'b0 ; reg_en = 1'b0 ; cnt_64_en = 1'b0; reg_rst = 1'b0; permute_en = 1'b0; read_en = 1'b0; mux_en = 1'b0;
		done = 1'b0; 
		case (ps)
		Idle: begin
			reg_rst = 1'b1;
		end
		Beginn : begin
			done = (counter_64_co) ? 1'b1 : 1'b0;
		end
		Read : begin
			read_en = 1'b1;
		end
		PassInput : begin
			reg_en = 1'b1;
		end
		Swap : begin
			permute_en = 1'b1;
		end
		PassOutput : begin
			reg_en = 1'b1;
			mux_en = 1'b1;
		end
		Write : begin
			cnt_64_en = 1'b1;
			write_en = 1'b1;
		end
		endcase
	end

endmodule


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

	controller cntrl( .start(start), .counter_64_co(counter_64_co), .rst(rst), .clk(clk), .write_en(write_en), .read_en(read_en), .mux_en(mux_en),
	.reg_en(reg_en), .cnt_64_en(cnt_64_en), .done(done), .reg_rst(reg_rst), .permute_en(permute_en) );

	datapath dp(.clk(clk), .rst(rst), .input_file_name(input_file_name), .write_en(write_en), .read_en(read_en), .reg_en(reg_en), .cnt_64_en(cnt_64_en), 
			.mux_en(mux_en),	.reg_rst(reg_rst), .output_file_name(output_file_name), .permute_en(permute_en), 
			.counter_co(counter_64_co), .cnt_value(cnt_value), .line_in(line_in), .write_value(write_val));



endmodule
