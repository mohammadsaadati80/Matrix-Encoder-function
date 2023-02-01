module register_1 (clk,pin,en,rst,pout);
    
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

module counter_1 (clk,pin,select,ld,rst,en,pout,co);
    
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
        if(rst) pout <= 7'b0111110;
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


