module controller_3 (
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