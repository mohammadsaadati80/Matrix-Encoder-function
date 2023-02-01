module read_from_file_3 (clk, en, line_in, line);

    // input string input_file_name;
    input [24:0] line_in;
    input clk;
    input en;
    output reg [24:0] line;
	
	always@(en, clk) begin
		if (en) begin
			line <= line_in;
		end
	end

endmodule