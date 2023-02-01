module rotate (mem, cnt24_value, cnt64_value, wr_en_1, wr_en_2, slice);

    input [24:0] slice;
    input [5:0] cnt64_value;
    input [4:0] cnt24_value;
    input wr_en_1;
    input wr_en_2;
    output reg [24:0] mem [63:0];  

    // reg [24:0] temp [63:0];

    integer i = 0;
    integer x = 0;
    integer y = 0;
    integer new_z = 0;
    integer xy = 0;
    integer cv = 0;
    integer xy_ = 0;
    
    integer table_value;

    always @(wr_en_1, wr_en_2) begin
        if (wr_en_1) begin
            cv = (cnt24_value+25) % 32;
                x = (cv) % 5;
                y = (cv) / 5;
                x = (x + 3) % 5;
                y = (y + 3) % 5;
                  //tartib doroste?
                xy = (((x + 2) % 5) + 5*((y + 2) % 5) % 25);
                xy_ = (24 - xy) %25;

        end
        
        if (wr_en_2) begin //TODO swap_en
                
                mem[new_z][xy] = slice[xy_];              //tartib doroste?
        end
    end

    // assign mem = temp;

    reg [7:0] ii;
    assign ii = (x + 5*y) % 25;

    always @(*) begin
        case(ii) 
            8'd00: table_value = 8'd0;
            8'd01: table_value = 8'd1;
            8'd02: table_value = 8'd62;
            8'd03: table_value = 8'd28;
            8'd04: table_value = 8'd27;
            8'd05: table_value = 8'd36;
            8'd06: table_value = 8'd44;
            8'd07: table_value = 8'd6;
            8'd08: table_value = 8'd55;
            8'd09: table_value = 8'd20;
            8'd10: table_value = 8'd3;
            8'd11: table_value = 8'd10;
            8'd12: table_value = 8'd43;
            8'd13: table_value = 8'd25;
            8'd14: table_value = 8'd39;
            8'd15: table_value = 8'd41;
            8'd16: table_value = 8'd45;
            8'd17: table_value = 8'd15;
            8'd18: table_value = 8'd21;
            8'd19: table_value = 8'd8;
            8'd20: table_value = 8'd18;
            8'd21: table_value = 8'd2;
            8'd22: table_value = 8'd61;
            8'd23: table_value = 8'd56;
            8'd24: table_value = 8'd14;
        endcase
        new_z = (cnt64_value + table_value) % 64;
    end

endmodule