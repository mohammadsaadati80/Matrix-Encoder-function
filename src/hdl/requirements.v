module register (clk,pin,ld,rst,pout);
    
    parameter N = 25;
    input clk;
    input ld;
    input rst;
    input [N-1:0]pin;
    output reg [N-1:0]pout;

    always @(posedge clk) begin
        if(rst) pout <= 0;
        else pout <= pin;
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
        if(rst) pout <= 0;
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

module shift_register (clk,pin,select,cin,ld,rst,en,pout);
    
    parameter N = 25;
    input clk;
    input ld;
    input en;
    input select;
    input cin;
    input rst;
    input [N-1:0]pin;
    output reg [N-1:0]pout;

    always @(posedge clk) begin
        if(rst) pout <= 0;
        else if(ld) pout <= pin;
        else begin
            if(en)begin
                if(select == 1) pout <= {pout[N-2:0],cin};
                if(select == 0) pout <= {cin,pout[N-1:1]};
            end
        end
    end

endmodule

module mux2to1 (a,b,s,w);

    parameter N = 8;
    input [N-1:0]a;
    input [N-1:0]b;
    input s;
    output [N-1:0]w;

    assign w = (s==1'b0) ? a : b; 
    
endmodule

module mux4to1 (a,b,c,d,s,w);

    parameter N = 8;
    input [N-1:0]a;
    input [N-1:0]b;
    input [N-1:0]c;
    input [N-1:0]d;
    input [1:0]s;
    output reg [N-1:0]w;

    always @(*) begin
        case (s)
            0 : w = a; 
            1 : w = b; 
            2 : w = c; 
            3 : w = d; 
        endcase
    end
    
endmodule

module add_sub (A,B,select,out, neg);
    
    parameter N = 8;
    input  [N-1:0]A;
    input  [N-1:0]B;
    input  select;
    output [N-1:0]out;
    output neg;
    
    assign out = (select == 1) ? (A+B) : (A-B);
    assign neg = (A < B);
endmodule


module permutation ();

endmodule