module controller_1 (
	inreg_en, cnt_en, cnt_rst, wr_en, start, cnt_co, clk, rst, done
);

	input start;
	input cnt_co;
	input rst;
	input clk;
	output reg inreg_en;
	output reg cnt_en; 
	output reg cnt_rst; 
	output reg wr_en;
	output reg done;

	reg cu;
	assign done = cnt_co & cu;

	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , First_Read = 1 , Write = 2 , Read = 3, Count_Up = 4;

	always@(posedge clk , posedge rst) begin
		if (rst == 1'b1)
			ps <= Idle;
		else
			ps <= ns;
	end

	always@(ps, start, cnt_co) begin
		ns = Idle ;
		case (ps)
			Idle:
				ns = (start) ? First_Read : Idle;
			First_Read:
				ns = Write;
			Write:
				ns = Read;
			Read:
				ns = Count_Up;
			Count_Up:
				ns = (cnt_co) ? Idle : Write;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , cnt_co) begin
		inreg_en = 1'b0 ; cnt_en = 1'b0 ; cnt_rst = 1'b0; wr_en = 1'b0; done = 1'b0; cu = 1'b0;
		case (ps)
		Idle: begin
			cnt_rst = 1'b1;
		end
		First_Read : begin
			inreg_en = 1'b1;
			cnt_en = 1'b1;
		end
		Write : begin
			wr_en = 1'b1;
		end
		Read : begin
			inreg_en = 1'b1;
			cnt_en = 1'b1;
		end
		Count_Up : begin
			// cnt_en = 1'b1;
			cu = 1'b1;
		end
		endcase
	end

endmodule