module tb_keygen_lfsr_fsm;
    reg         clk;
    reg         rst_n;
    reg         generate_key;

    wire [127:0] aes_key;
    wire [15:0]  crc_key;
    wire         key_valid;
    wire         busy;

    // DUT Instance
    keygen_lfsr_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .generate_key(generate_key),
        .aes_key(aes_key),
        .crc_key(crc_key),
        .key_valid(key_valid),
        .busy(busy));

initial 
begin
   clk = 0;
   forever #10 clk = ~clk;   
end

initial 
begin
        rst_n = 0;
        generate_key = 0;
        #20;
        rst_n = 1;
        #20;
   
        // First key generation
        $display(" FIRST KEY GENERATION ");
        generate_key = 1;
        #10;
        generate_key = 0;
        // check for key_valid for displaying aste
        wait (key_valid == 1);
        $display("Key ready!");
        $display("AES Key = %h", aes_key);
        $display("CRC Key = %h", crc_key);
		  $display("valid Key = %h", key_valid);
		  $display("busy = %h",busy );
        #50;

    
        // Second key generation
        $display("\ SECOND KEY GENERATION ");

        generate_key = 1;
        #10;
        generate_key = 0;

        wait (key_valid == 1);
        $display("Key ready again!");
        $display("AES Key = %h", aes_key);
        $display("CRC Key = %h", crc_key);
		  $display("valid Key = %h", key_valid);
		  $display("busy = %h",busy );
			 #50;
        $display("Testbench finished.");
        #500$finish;
end

endmodule
