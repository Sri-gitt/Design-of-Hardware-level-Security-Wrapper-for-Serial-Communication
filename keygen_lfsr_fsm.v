//module keygen_lfsr_fsm(
//    input           clk,				// clk 3.125mhz
//    input           rst_n,
//    input           generate_key,    //need from uart tx before sending
//
//    output  [127:0] aes_key,
//    output  [15:0]  crc_key,	
//	 
//    output  reg     key_valid,
//    output  reg     busy					// other flags in case needed 
//);
//reg 			enable;
//reg  	[1:0]		state;
//localparam [6:0] LFSR_CYCLES = 7'd128; 
//localparam 	RUN 	= 2'b01;
//localparam  DONE  = 2'b10;
//localparam 	IDLE	= 2'b00;
//
//reg  [6:0]   cycle_counter; 
//wire [127:0] lfsr_out;
//
////send lfsr_128 module 
//lfsr_128 u_lfsr (
//    .clk   (clk),
//    .rst_n (rst_n),
//    .enable(enable),     
//    .out   (lfsr_out)
//);
//
//
//assign aes_key 	= lfsr_out;
//assign crc_key 	= lfsr_out[15:0]; 
//
//
//always @(posedge clk or negedge rst_n) 
//begin
//  if (!rst_n) 
//  begin
//    cycle_counter <= 7'd0;
//    state <= IDLE; 
//	 enable <= 0;
//	 key_valid <= 0;
//	 busy <= 0;
//  end 
//  else 
//  begin
//    case (state)
//      IDLE: begin // IDLE ---> 00
//        if (generate_key) 
//		  begin
//          cycle_counter <= 7'd0;
//          state <= RUN;
//			 enable <= 0;
//			 key_valid <= 0;
//			 busy <= 0;
//        end
//      end
//      RUN: begin // RUN	---->	01
//			enable <= 1;
//			busy <= 1;
//        cycle_counter <= cycle_counter + 1'b1;
//        if (cycle_counter + 1'b1 >= LFSR_CYCLES) 
//		  begin
//          state <= DONE;
//        end
//      end
//      DONE: begin // DONE	----> 10
//        if (generate_key) 
//		  begin
//			 enable <= 0;
//          cycle_counter <= 7'd0;
//			 key_valid <= 1;
//			 busy <=0;
//          state <= RUN; 
//        end
//      end
//    endcase
//  end
//end
//endmodule 





module keygen_lfsr_fsm(
    input           clk,            // 3.125 MHz
    input           rst_n,
    input           generate_key,   // can be level from TX

    output  reg [127:0] aes_key,
    output  reg [15:0]  crc_key,
    output  reg     key_valid,
    output  reg     busy
);

    localparam integer LFSR_CYCLES = 10;
    localparam [1:0] IDLE = 2'b00, RUN = 2'b01, DONE = 2'b10;

    reg  [1:0]  state;
    reg  [6:0]  cycle_counter; 
    reg         lfsr_enable;

    reg gen_d;
    wire start_pulse = generate_key & ~gen_d;
    wire [127:0] lfsr_out;

    lfsr_128 u_lfsr (
        .clk    (clk),
        .rst_n  (rst_n),
        .enable (lfsr_enable),
        .out    (lfsr_out)
    );

   // assign aes_key = lfsr_out;
   //assign crc_key = lfsr_out[15:0];

always @(posedge clk or negedge rst_n) 
begin
     if (!rst_n) 
	  begin
            state         <= IDLE;
            cycle_counter <= 7'd0;
            lfsr_enable   <= 1'b0;
            key_valid     <= 1'b0;
            busy          <= 1'b0;
            gen_d         <= 1'b0;
     end 
	  else 
	  begin
         gen_d <= generate_key;
         lfsr_enable <= 1'b0;

         case (state)
                IDLE: begin
                    key_valid <= 1'b0;
                    busy      <= 1'b0;
                    if (start_pulse) 
						  begin       
                        cycle_counter <= 7'd0;
                        lfsr_enable   <= 1'b1;   
                        busy          <= 1'b1;
                        state         <= RUN;
                    end
                end

                RUN: begin
                    lfsr_enable <= 1'b1;
                    busy        <= 1'b1;
                    key_valid   <= 1'b0;
                    cycle_counter <= cycle_counter + 1'b1;
						  
                    if (cycle_counter == (LFSR_CYCLES - 1))
						  begin
                        aes_key <= lfsr_out;
								crc_key <= lfsr_out[15:0];
                        lfsr_enable   <= 1'b0;
                        busy          <= 1'b0;
                        key_valid     <= 1'b1;
                        cycle_counter <= 7'd0;
                        state         <= DONE;
                    end
                end

                DONE: begin
                    lfsr_enable <= 1'b0;
                    busy        <= 1'b0;
                    key_valid   <= 1'b1;

                    if (start_pulse) 
						  begin
                        cycle_counter <= 7'd0;
                        lfsr_enable   <= 1'b1;
                        busy          <= 1'b1;
                        key_valid     <= 1'b0;
                        state         <= RUN;
                    end
                end

                default: state <= IDLE;
          endcase
     end
end

endmodule

