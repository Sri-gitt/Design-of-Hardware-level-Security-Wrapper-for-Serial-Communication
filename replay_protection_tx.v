

module replay_protection_tx
(
  input            clk,
  input            reset_n,
  input      [7:0] data_in,
  
  output reg       read_en,
  output reg [7:0] data_out,
  output reg       data_ready
);

reg [3:0] data_in_count;
reg [7:0] replay_count;
reg [2:0] state ;

localparam [2:0] START_STATE   = 3'h0;
localparam [2:0] WRITE_STATE   = 3'h1;
localparam [2:0] READ_STATE    = 3'h2;
localparam [2:0] WAIT_STATE    = 3'h3;
localparam [2:0] COMPUTE_STATE = 3'h4;
localparam [2:0] DONE_STATE    = 3'h5;

  always@(posedge clk or negedge reset_n)
  begin 
    
	 if(~reset_n)
	 begin 
	   
		replay_count  <= {8{1'h0}};
		data_in_count <= 4'h0;
		state         <= START_STATE;
		read_en       <= 1'b0;
		data_ready    <= 1'b0;
	 end 
	 
	 else 
	 begin
	 
	   case(state) 
		 START_STATE:
		   begin 
			  
			  data_ready <= 1'b0;
			  if(data_in_count == 4'd8) 
			  begin 
			    data_in_count <= 4'b0;
				 replay_count  <= (replay_count + 1'b1) % 256;
				 state         <= DONE_STATE;
			  end 
			  else 
			     state <= WRITE_STATE;
			end 
			
		  WRITE_STATE:	 
		    begin 
				state   <= READ_STATE;
			 end 

		
		  READ_STATE:
		    begin 
			   read_en <= 1'b1;
				state   <= WAIT_STATE; 
			 end
			 
			 
		  WAIT_STATE:
		    begin 
			   read_en      <= 1'b0;
			   state <= COMPUTE_STATE;
		    end 
			 
		  COMPUTE_STATE:
		    begin 
			   if (data_in >= 8'h0) 
			   begin 
			     data_in_count <= data_in_count + 1'b1; 
				  data_ready <= 1'b1; 
			   end 
			  
			   data_out <= data_in;
			   state    <= START_STATE;
			 end 
			
		  DONE_STATE: 
		  begin 
		    data_ready <= 1'b1;
		    data_out <= replay_count;
			 state    <= START_STATE;
		  end 

		endcase 
	 end 

  end 
endmodule 





