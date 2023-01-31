module rotate (mem, cnt24_value, cnt64_value, wr_en, table_value, slice);

    input [24:0] slice;
    input [6:0] cnt64_value;
    input [5:0] cnt24_value;
    input wr_en;
    inout [24:0] mem [63:0];  

    integer i = 0;
    integer x = 0;
    integer y = 0;
    integer new_z = 0;

    always @(wr_en) begin
        if (swap_en) begin
                x = i % 5;
                y = i / 5;
                x = (x + 3) % 5;
                y = (y + 3) % 5;
                new_z = cnt64_value + table_value[x][y];  //tartib doroste?
                mem[cnt24_co][new_z] = slice[cnt24_co];              //tartib doroste?
        end
    end

endmodule