module aes_mixcolumns(
    input  wire [31:0] col_in,
    output wire [31:0] col_out
);
    wire [7:0] a0 = col_in[31:24];
    wire [7:0] a1 = col_in[23:16];
    wire [7:0] a2 = col_in[15:8];
    wire [7:0] a3 = col_in[7:0];

    wire [7:0] a0x = {a0[6:0],1'b0} ^ (8'h1B & {8{a0[7]}});
    wire [7:0] a1x = {a1[6:0],1'b0} ^ (8'h1B & {8{a1[7]}});
    wire [7:0] a2x = {a2[6:0],1'b0} ^ (8'h1B & {8{a2[7]}});
    wire [7:0] a3x = {a3[6:0],1'b0} ^ (8'h1B & {8{a3[7]}});

    assign col_out = {
        a0x ^ a1  ^ a1x ^ a2  ^ a3,
        a0  ^ a1x ^ a2  ^ a2x ^ a3,
        a0  ^ a1  ^ a2x ^ a3  ^ a3x,
        a0x ^ a0  ^ a1  ^ a2  ^ a3x
    };
endmodule
