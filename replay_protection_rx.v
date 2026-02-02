module replay_protection_rx
(
  input       clk,
  input       reset_n,
  input [7:0] data_in,
  input       rx_complete,
  
  output reg  replay_error
);


reg [7:0] prev_replay;
reg [7:0] replay;
reg [3:0] count;
reg [1:0] state;

localparam [1:0] START_STATE  =  2'h0;
localparam [1:0] COUNT_STATE  =  2'h1;
localparam [1:0] VERIFY_STATE =  2'h2;

  always@(posedge clk or negedge reset_n)
  begin 
    
	 if(~reset_n)
	 begin 
	
		replay_error <= 1'b0;
		prev_replay  <= 7'h0;
		replay       <= 7'h0;
		count        <= 4'h0; 
		state        <= START_STATE;
	 end 
	 
	 else 
	 begin
		  
		  case(state) 
		  
		  
	        START_STATE: 
		       begin 
				   if(rx_complete)
					  state <= COUNT_STATE;
					else 
					  state <= START_STATE;
				 end
				 
			  COUNT_STATE:
			    begin 
				   if(count == 4'd8) 
					   begin 
						  count  <= 4'd0;
						  replay <= data_in;
						  state  <= VERIFY_STATE;
						end 
						
					else 
					   begin
					    count <= count + 1'b1;
						 state <= START_STATE;
						end 
				 end 
				 
			  VERIFY_STATE:
			    begin 
				   
					replay_error <= (prev_replay > replay)? 1 : 0; 
					prev_replay  <= replay;
					state        <= START_STATE;
				 end 
			 
				 
		  endcase 
	 end 
  end 

endmodule 



