module controller (
	cnt_en, cnt_rst, start, cnt_co, clk, rst, done, wr_en, colParity_en, rotate_en, permute_en, revalute_en, addRC_en
);

	input start;
	input cnt_co;
	input rst;
	input clk;
	output reg cnt_en; 
	output reg cnt_rst; 
	output reg wr_en;
	output reg colParity_en;
	output reg rotate_en;
	output reg permute_en;
	output reg revalute_en;
	output reg addRC_en;
	output reg done;

	assign done = cnt_co;

	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , ColParity = 1 , Rotate = 2 , Permute = 3, Revalute = 4, AddRC = 5, Count24_Up = 6;

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
				ns = (start) ? ColParity : Idle;
			ColParity:
				ns = Rotate;
			Rotate:
				ns = Permute;
			Permute:
				ns = Revalute;
			Revalute:
				ns = AddRC;
			AddRC:
				ns = Count24_Up;
			Count24_Up:
				ns = (cnt_co) ? Idle : ColParity;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , cnt_co) begin
		cnt_en = 1'b0; cnt_rst = 1'b0; colParity_en = 1'b0; rotate_en = 1'b0; permute_en = 1'b0; revalute_en = 1'b0; addRC_en = 1'b0;
		case (ps)
		Idle: begin
			cnt_rst = 1'b1;
		end
		ColParity : begin
			colParity_en = 1'b1;
		end
		Rotate : begin
			rotate_en = 1'b1;
		end
		Permute : begin
			permute_en = 1'b1;
		end
		Revalute : begin
			revalute_en = 1'b1;
		end
		AddRC : begin
			addRC_en = 1'b1;
		end
		Count24_Up : begin
			cnt_en = 1'b1;
		end
		endcase
	end

endmodule