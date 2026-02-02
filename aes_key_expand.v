
module aes_key_expand(
    input  wire [127:0] key_in,
    input  wire [7:0]   rcon,
    output wire [127:0] key_out
);
    wire [31:0] k0 = key_in[127:96];
    wire [31:0] k1 = key_in[95:64];
    wire [31:0] k2 = key_in[63:32];
    wire [31:0] k3 = key_in[31:0];

    wire [31:0] rot = {k3[23:0], k3[31:24]};

    wire [7:0] sb0, sb1, sb2, sb3;
    aes_sbox sb_inst0(.a(rot[31:24]), .y(sb0));
    aes_sbox sb_inst1(.a(rot[23:16]), .y(sb1));
    aes_sbox sb_inst2(.a(rot[15:8]),  .y(sb2));
    aes_sbox sb_inst3(.a(rot[7:0]),   .y(sb3));

    wire [31:0] subword = {sb0, sb1, sb2, sb3};

    assign key_out[127:96] = k0 ^ subword ^ {rcon,24'h0};
    assign key_out[95:64]  = k1 ^ key_out[127:96];
    assign key_out[63:32]  = k2 ^ key_out[95:64];
    assign key_out[31:0]   = k3 ^ key_out[63:32];
endmodule
