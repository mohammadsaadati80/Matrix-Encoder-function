module colParity (input1, input2, output_line);

    input [24:0] input1;
    input [24:0] input2;
    output reg [24:0] output_line;

    reg [24:0] temp;

    genvar i;
    integer x = 0;
    integer y = 0;
    wire a_ijk = 1'b0;
    wire parity1 = 1'b0;
    wire parity2 = 1'b0;

    generate
        for(i = 0; i < 25; i = i + 1) begin
            assign x = i % 5;
            assign y = i / 5;
            assign x = (x + 3) % 5;
            assign y = (y + 3) % 5;

            assign a_ijk = input2[i];
            assign parity1 = input2[(i+14)%25] ^ input2[(i+19)%25] ^ input2[(i+24)%25] ^ input2[(i+4)%25] ^ input2[(i+9)%25];
            assign parity1 = input1[(i+16)%25] ^ input1[(i+21)%25] ^ input1[(i+1)%25] ^ input1[(i+6)%25] ^ input1[(i+11)%25];
            
            // x = (x + 2) % 5;
            // y = (y + 2) % 5;
            // pos = (y * 5) + x;
            assign temp[i] = a_ijk ^ parity1 ^ parity2;
        end
    endgenerate

    assign output_line = temp;

endmodule