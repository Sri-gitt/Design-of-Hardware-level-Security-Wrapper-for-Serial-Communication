module tb();

    reg clk, rst_n, start;
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;
    wire done;

    aes_core dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
        .done(done)
    );

    initial begin clk=0; forever #5 clk=~clk; end

    initial begin
        rst_n=0; start=0;
        key = 128'h000102030405060708090A0B0C0D0E0F;
        plaintext = 128'h00112233445566778899AABBCCDDEEFF;

        #30 rst_n=1;

        #20 start = 1;
        #10 start = 0;

        #50000;  
        $finish;
    end

endmodule
