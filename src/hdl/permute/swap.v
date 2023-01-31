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