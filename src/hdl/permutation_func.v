module datapath (input reg input_file_name, line_number, write_en, read_en, cnt_64_en, done, reg_rst, clk, output_file_name);
	wire [24:0] line;
	wire [5:0] cnt_64_value;
	wire [24:0] permutation_out;
	wire [24:0] reg_out;
	wire [24:0] mux2to1_out;
	Counter64 cnt1(.cnt_en(cnt_64_en), .value(cnt_64_value));  //inout
	read_from_file reader1(.input_file_name(input_file_name), .line_number(cnt_64_value), .line(line));
	register reg1(.clk(clk),.pin(mux2to1_out),.enable(read_en),.rst(reg_rst),.pout(reg_out));
	swap swap1(.input_line(reg_out), .output_line(permutation_out), .enable(permute_en));
	mux2to1 mux1 (.a(line),.b(permutation_out),.s(write_en),.w(mux2to1_out));
	write_to_file (.output_file_name(output_file_name), .line(reg_out), .enable(write_en));

endmodule

//add enable to permutation
//change requirement input and outputs
//change read_en to register_en
//add enable to write and probably read

module controller (
	start, counter_64_co, rst, clk, write_en , 
	read_en , cnt_64_en, done, reg_rst
);
	input start;
	input counter_64_co;
	input rst;
	input clk;
	output reg write_en; 
	output reg read_en;
	output reg cnt_64_en;
	output reg done;
	output reg reg_rst;

	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , Begin = 1 , Read = 2 , Swap = 3 , Write = 4;

	always@(posedge clk , posedge rst) begin
		if (rst == 1'b1)
			ps <= Idle;
		else
			ps <= ns;
	end

	always@(ps, counter_64_co ) begin
		ns = Idle ;
		case (ps)
			Idle:
				ns = (start) ? Begin : Idle;
			Begin:
				ns = Read;
			Read:
				ns = Swap;
			Swap:
				ns = Write ;
			Write:
				ns = (counter_64_co) ? Idle : Begin;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , counter_64_co) begin
		write_en = 1'b0 ; read_en = 1'b0 ; cnt_64_en = 1'b0; 
		case (ps)
		Idle: begin
			reg_rst = 1'b1;
		end
		Begin : begin
			done = (counter_64_co) ? 1'b1 : 1'b0;
		end
		Read : begin
			read_en = 1'b1;
		end
		Write : begin
			cnt_64_en = 1'b1;
			write_en = 1'b1;
		end
		endcase
	end

endmodule


module permutation_func ();

endmodule
