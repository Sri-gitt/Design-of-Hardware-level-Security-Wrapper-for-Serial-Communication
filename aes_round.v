module aes_round(
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         final_round,   
    output wire [127:0] state_out
);
    wire [7:0] s [0:15];
    genvar i;
    generate
      for (i=0;i<16;i=i+1) begin : SB
         aes_sbox sbi(.a(state_in[127-8*i -: 8]), .y(s[i]));
      end
    endgenerate

    
    wire [7:0] sh [0:15];
    assign sh[0]=s[0];  assign sh[1]=s[5];  assign sh[2]=s[10]; assign sh[3]=s[15];
    assign sh[4]=s[4];  assign sh[5]=s[9];  assign sh[6]=s[14]; assign sh[7]=s[3];
    assign sh[8]=s[8];  assign sh[9]=s[13]; assign sh[10]=s[2]; assign sh[11]=s[7];
    assign sh[12]=s[12];assign sh[13]=s[1]; assign sh[14]=s[6]; assign sh[15]=s[11];

    wire [31:0] col0 = {sh[0], sh[1], sh[2], sh[3]};
    wire [31:0] col1 = {sh[4], sh[5], sh[6], sh[7]};
    wire [31:0] col2 = {sh[8], sh[9], sh[10], sh[11]};
    wire [31:0] col3 = {sh[12], sh[13], sh[14], sh[15]};

    wire [31:0] mc0, mc1, mc2, mc3;
    aes_mixcolumns m0(.col_in(col0), .col_out(mc0));
    aes_mixcolumns m1(.col_in(col1), .col_out(mc1));
    aes_mixcolumns m2(.col_in(col2), .col_out(mc2));
    aes_mixcolumns m3(.col_in(col3), .col_out(mc3));

    wire [127:0] mixed = {mc0, mc1, mc2, mc3};
    wire [127:0] sub_shift = {sh[0],sh[1],sh[2],sh[3],
                              sh[4],sh[5],sh[6],sh[7],
                              sh[8],sh[9],sh[10],sh[11],
                              sh[12],sh[13],sh[14],sh[15]};

    assign state_out = (final_round ? (sub_shift ^ round_key) : (mixed ^ round_key));
endmodule
