module colParity (input1, input2, output_line);

    input [24:0] input1;
    input [24:0] input2;
    output reg [24:0] output_line;

    reg [24:0] temp;

    genvar i = 0;
    integer x = 0;
    integer y = 0;
    integer new_x = 0;
    integer new_y = 0;
    integer new_pos = 0;

    generate
        for(i = 0; i < 25; i = i + 1) begin
                x = i % 5;
                y = i / 5;
                x = (x + 3) % 5;
                y = (y + 3) % 5;
                
                a = input2[x][y];



                new_pos = (y * 5) + x;
                temp[new_pos] = input_line[i];
        end
    endgenerate

    assign output_line = temp;

endmodule