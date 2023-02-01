module controller_5 (
	cnt64_en, cnt64_rst , read_en, xor_en, addrc_en, cnt64_co, clk, rst, done, file_write
);

	input addrc_en;
	input cnt64_co;
	input rst;
	input clk;
	output reg read_en;
	output reg cnt64_en; 
	output reg cnt64_rst; 
	output reg xor_en;
	output reg done;
    output reg file_write;


	reg [2:0] ps , ns ;
	parameter [2:0] Idle = 0 , Read = 1 , XOR = 2 , Cnt64_Up = 3, Write = 4, Done = 5;

	always@(posedge clk , posedge rst) begin
		if (rst == 1'b1)
			ps <= Idle;
		else
			ps <= ns;
	end

	always@(ps, addrc_en, cnt64_co) begin
		ns = Idle ;
		case (ps)
			Idle:
				ns = (addrc_en) ? Read : Idle;
			Read:
				ns = XOR;
			XOR:
				ns = Cnt64_Up; 
			Cnt64_Up:
				ns = (cnt64_co) ? Write : Read;
            Write:
                ns = Done;
            Done: 
                ns = Idle;
			default :
				ns = Idle;
		endcase
	end

	always@(ps , cnt64_co) begin
		read_en = 1'b0 ; cnt64_en = 1'b0 ; cnt64_rst = 1'b0; xor_en = 1'b0; done = 1'b0; file_write= 1'b0;
		case (ps)
		Idle: begin
			cnt64_rst = 1'b1;
		end
		Read : begin
			read_en = 1'b1;
		end
		XOR : begin
			xor_en = 1'b1;
		end
		Cnt64_Up : begin
			cnt64_en = 1'b1;
		end
        Write : begin
			file_write = 1'b1;
		end
        Done : begin
			done = 1'b1;
		end
		endcase
	end

endmodule