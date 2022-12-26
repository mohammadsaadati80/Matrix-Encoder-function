module datapath ();

endmodule


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

	always@(ps , counter_25_co) begin
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

	always@(ps , counter_25_co) begin
		write_en = 1'b0 ; read_en = 1'b0 ; cnt_64_en = 1'b0; cnt_25_en = 1'b0;
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
