module colParity (input1, input2, swap_en, output_line);

    input [24:0] input1;
    input [24:0] input2;
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
                // TODO
            end
        end
    end

    assign output_line = temp;

endmodule