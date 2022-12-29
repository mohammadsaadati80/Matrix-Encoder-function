module register (clk,pin,en,rst,pout);
    
    parameter N = 25;
    input clk;
    input en;
    input rst;
    input [N-1:0]pin;
    output reg [N-1:0]pout;

    always @(posedge clk) begin
        if(rst) pout <= 0;
        else if(en) pout <= pin;
    end

endmodule

module counter (clk,pin,select,ld,rst,en,pout,co);
    
    parameter N = 8;
    input clk;
    input ld;
    input en;
    input select;
    input rst;
    input [N-1:0]pin;
    output co;
    output reg [N-1:0]pout;

    always @(posedge clk) begin
        if(rst) pout <= 7'b0111111;
        else if(ld) pout <= pin;
        else begin
            if(en)begin
                if(select == 1) pout <= pout + 1;
                if(select == 0) pout <= pout - 1;
            end
        end
    end

    assign co = (select == 1) ? &{pout} : &{~pout};

endmodule

module read_from_file (clk, en, line_in, line);

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

module write_to_file ( output_file_name, en, line);

    // input string output_file_name;
    input [13*8-1:0] output_file_name; // Can store 13 characters
    input en;
    input [24:0] line;

    integer f;
    integer i;

    always @(en) begin
        if (en) begin
            f = $fopen("output_00.txt","a");
            for (i = 0; i<25; i=i+1)
                $fwrite(f,"%b",line[24 - i]);
            $fwrite(f,"\n");
            $fclose(f);  

        end
    end 

endmodule

module mux2to1 (a,b,s,w);

    parameter N = 25;
    input [N-1:0]a;
    input [N-1:0]b;
    input s;
    output [N-1:0]w;

    assign w = (s==1'b0) ? a : b; 
    
endmodule

module swap (input_line, swap_en, output_line);

    input [24:0] input_line;
    input swap_en;
    output reg [24:0] output_line;

    reg [24:0] temp;

    integer i = 0;
    integer x = 0;
    integer y = 0;
    integer new_x = 0;
    integer new_y = 0;
    integer new_pos = 0;

    always @(swap_en) begin
        if (swap_en) begin
            for(i = 0; i < 25; i = i + 1) begin
                x = i % 5;
                y = i / 5;
                x = (x + 3) % 5;
                y = (y + 3) % 5;
                new_x = y;
                new_y = (2 * x + 3 * y) % 5;
                new_x = (new_x + 2) % 5;
                new_y = (new_y + 2) % 5;
                new_pos = (new_y * 5) + new_x;
                temp[new_pos] = input_line[i];
            end
        end
    end

    assign output_line = temp;

endmodule
