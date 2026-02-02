module lfsr_128 (
    input           clk,        // System clock 3.125MHz
    input           rst_n,     
    input           enable,    
    output reg  [127:0] out         // Current LFSR state output
);
    localparam [127:0] MASTER_KEY = 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF; 		// this is our device+made main key 
    //other keys 
    // localparam [127:0] MASTER_KEY = 128'hA5A5A5A5_5A5A5A5A_DEADBEEF_CAFEBABE;
    // localparam [127:0] MASTER_KEY = 128'h0123456789ABCDEF_FEDCBA9876543210;
    // localparam [127:0] MASTER_KEY = 128'h8E73B0F7_DA0E6452_C810F32B_809079E5;  
    reg [127:0] state;
    

    wire feedback = state[127] ^ state[29] ^ state[27] ^ state[2];
    
    always @(posedge clk or negedge rst_n) 
	 begin
        if (!rst_n) 
		  begin
            state <= MASTER_KEY;
            out   <= MASTER_KEY;
        end 
		  else 
		  begin
            if (enable) 
				begin
                state <= {feedback, state[127:1]};
                out   <= {feedback, state[127:1]};
            end
        end
    end
endmodule