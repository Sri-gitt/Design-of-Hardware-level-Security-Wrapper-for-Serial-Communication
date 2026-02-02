module aes_core(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,       
   
    input  wire [127:0] plaintext,
	 input  wire [127:0] key,        
	 
    output reg  [127:0] ciphertext,
    output reg         done
);
    reg [3:0] round;
    reg [127:0] state_reg;
    reg [127:0] roundkey;

    reg active;

   
    reg [7:0] rcon;
    always @(*) begin
        case (round)
            4'd1: rcon = 8'h01; 4'd2: rcon = 8'h02; 4'd3: rcon = 8'h04; 4'd4: rcon = 8'h08;
            4'd5: rcon = 8'h10; 4'd6: rcon = 8'h20; 4'd7: rcon = 8'h40; 4'd8: rcon = 8'h80;
            4'd9: rcon = 8'h1B; 4'd10: rcon = 8'h36;
            default: rcon = 8'h00;
        endcase
    end

    wire [127:0] next_roundkey;
	 
    aes_key_expand kexp(.key_in(roundkey), .rcon(rcon), .key_out(next_roundkey));

    wire [127:0] round_out;
	 
    aes_round arnd(
        .state_in(state_reg),
        .round_key(next_roundkey),
        .final_round(round == 4'd10),
        .state_out(round_out));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
            active <= 1'b0;
            round <= 4'd0;
            state_reg <= 128'd0;
            roundkey <= 128'd0;
            ciphertext <= 128'd0;
        end else begin
            done <= 1'b0;
            if (start && !active) begin
               
                active <= 1'b1;
                roundkey <= key;               
                state_reg <= plaintext ^ key;  
                round <= 4'd1;
            end else if (active) begin
                state_reg <= round_out;
                roundkey <= next_roundkey;
                if (round == 4'd10) begin
                    ciphertext <= round_out;
                    done <= 1'b1;
                    active <= 1'b0;
                    round <= 4'd0;
                end else begin
                    round <= round + 1'b1;
                end
            end
        end
    end
endmodule
