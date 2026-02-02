module crc_check
 (
  input             clk,
  input             reset_n, 
  
  input       [7:0] data, 
  input      [15:0] key,
  input             start_crc,
  output reg        write_en,
  output reg        read_en,
  output reg        crc_done,
  output reg [7:0]  crc
  );
  
  localparam [15:0] POLY             = 16'h1021;
  localparam  [3:0] SHIFT_VALUE      =  4'h8;
  
  localparam  [3:0] START_STATE      =  4'h0;
  localparam  [3:0] SHIFT_STATE      =  4'h1;
  localparam  [3:0] XOR_STATE        =  4'h2;
  localparam  [3:0] POLYNOMIAL_STATE =  4'h3;
  localparam  [3:0] DONE_STATE_1     =  4'h4;
  localparam  [3:0] READ_STATE       =  4'h5;
  localparam  [3:0] WRITE_STATE      =  4'h6;
  localparam  [3:0] WAIT_STATE       =  4'h7;
  localparam  [3:0] DONE_STATE_2     =  4'h8;
  localparam  [3:0] DONE_STATE_0     =  4'h9;
  localparam  [3:0] READ_STATE_2     =  4'hA;
  
  
  reg [15:0] shifted_data;
  reg [15:0] xor_crc;
  reg  [3:0] state;
  reg  [3:0] byte_count;
  reg  [4:0] bit_count; 
  reg [15:0] intermediate_crc;
  
  always@(posedge clk or negedge reset_n)
  begin 
    
	 if(~reset_n)
	 begin 
	   
		crc          <= {8{1'h0}};
		shifted_data <= {16{1'h0}};
		state        <= START_STATE;
		byte_count   <= {4{1'h0}};
		bit_count    <= {4{1'h0}};
		xor_crc      <= {16{1'h0}};
		intermediate_crc <= {16{1'h0}};
		crc_done         <= 1'b0;
		write_en         <= 1'b0;
		read_en          <= 1'b0;
	 end 
	 
	 else 
	 begin
		case(state)
		
		  START_STATE: 
		    begin 
			   write_en = 1'b1;
				if(byte_count == 4'd8)
				begin 
				  byte_count <= {4{1'h0}};
				  state <= DONE_STATE_0; 
				end
				  
				else if(start_crc)
				  begin 
				    crc_done   <= 1'b0;
				    byte_count <= byte_count + 1'h1;
					 state      <= WRITE_STATE;
				  end 
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
			   state <= SHIFT_STATE;
		    end 
			 
		  SHIFT_STATE:
		    begin 
				shifted_data <=  data << SHIFT_VALUE;
				state        <= XOR_STATE;
			 end 
			 
		  XOR_STATE:
		    begin 
			 
				//if(byte_count == 4'h1)
				   //xor_crc <= 16'h0;
					
				if(byte_count == 4'h1)
				    xor_crc <= shifted_data ^ key;
				else
				   xor_crc <= (shifted_data) ^ intermediate_crc;
					
				state <= POLYNOMIAL_STATE;
			 end 
			 
			 
		  POLYNOMIAL_STATE:
		    begin 
			   
				if(bit_count == 4'h8)
				begin
				  intermediate_crc <= xor_crc;
				  bit_count  <= 4'h0;
				  state <= START_STATE;
				 end
				 
				 else 
				   begin 
					  bit_count <= bit_count + 1'h1;
					  xor_crc <= (xor_crc[15]) ? ((xor_crc << 1'h1) ^ POLY ) : (xor_crc << 1'h1) ;
					  state <= POLYNOMIAL_STATE;
					end 
			 end 
		 
		 DONE_STATE_0:
		   begin 
							  state <= DONE_STATE_1;
			end 
			 

		  DONE_STATE_1:
		    begin 
			   crc_done <= 1'b1;
			   crc      <= intermediate_crc[7:0];
				state    <= DONE_STATE_2;  
			 end 
				
		 DONE_STATE_2:
		    begin
		      crc <= intermediate_crc[15:8];
				state <= START_STATE;
			 end 
		endcase
	 
	 
	 end 
  end 
  
endmodule 
