module controller_2(
	cnt24_en, cnt64_en, cnt24_rst, cnt64_rst , read_en, wr_en, rotate_en, cnt24_co, cnt64_co, clk, rst, done, file_write
);

	input rotate_en;
	input cnt64_co;
    input cnt24_co;
	input rst;
	input clk;
	output reg read_en;
	output reg cnt64_en; 
    output reg cnt24_en; 
	output reg cnt64_rst; 
    output reg cnt24_rst; 
	output reg wr_en;
	output reg done;
    output reg file_write;


	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , Read = 1 , Write = 2 , Cnt24_Up = 3, Cnt64_Up = 4, Write_mem = 5, Done = 6;

	always@(posedge clk , posedge rst) begin
		if (rst == 1'b1)
			ps <= Idle;
		else
			ps <= ns;
	end

	always@(ps, rotate_en, cnt24_co, cnt64_co) begin
		ns = Idle ;
		case (ps)
			Idle:
				ns = (rotate_en) ? Read : Idle;
			Read:
				ns = Write;
			Write:
				ns = Cnt24_Up; 
			Cnt24_Up:
				ns = (cnt24_co) ? Cnt64_Up : Write;
			Cnt64_Up:
				ns = (cnt64_co) ? Write_mem : Read;
            Write_mem:
                ns = Done;
            Done: 
                ns = Idle;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , cnt24_co, cnt64_co) begin
		read_en = 1'b0 ; cnt24_en = 1'b0 ; cnt64_en = 1'b0 ; cnt24_rst = 1'b0; cnt64_rst = 1'b0; wr_en = 1'b0; done = 1'b0; file_write= 1'b0;
		case (ps)
		Idle: begin
			cnt64_rst = 1'b1;
            cnt24_rst = 1'b1;
		end
		Read : begin
			read_en = 1'b1;
		end
		Write : begin
			wr_en = 1'b1;
		end
		Cnt24_Up : begin
			cnt24_en = 1'b1;
		end
		Cnt64_Up : begin
			cnt64_en = 1'b1;
		end
        Write_mem : begin
			file_write = 1'b1;
		end
        Done : begin
			done = 1'b1;
		end
		endcase
	end

endmodule