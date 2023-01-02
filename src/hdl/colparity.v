module colParity (input1, input2, output_line);

    input [24:0] input1;
    input [24:0] input2;
    output reg [24:0] output_line;

    reg [24:0] temp;

    genvar i;
    wire [24:0] a_ijk;
    wire [24:0] parity1;
    wire [24:0] parity2;

    generate
        for(i = 0; i < 25; i = i + 1) begin
            assign a_ijk[i] = input2[i];
            assign parity1[i] = input2[(i+14)%25] ^ input2[(i+19)%25] ^ input2[(i+24)%25] ^ input2[(i+4)%25] ^ input2[(i+9)%25];
            assign parity2[i] = input1[(i+16)%25] ^ input1[(i+21)%25] ^ input1[(i+1)%25] ^ input1[(i+6)%25] ^ input1[(i+11)%25];
            assign temp[i] = a_ijk[i] ^ parity1[i] ^ parity2[i];
        end
    endgenerate

    assign output_line = temp;

endmodule