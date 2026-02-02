////module uart_tx(
////    input clk_3125,
////    input tx_start,
////    input [7:0] data,
////    output reg tx,
////    output tx_done
////);
////
//////////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
////
////// Simple, synthesizable UART transmitter for 115200 baud with 3.125 MHz clock.
////// Bit clock = 3.125 MHz / 27 ≈ 115.185 kHz -> 27 cycles per UART bit (0..26)
////
////reg [2:0] state;
////localparam IDLE  = 3'd0;
////localparam START = 3'd1;
////localparam DATA  = 3'd2;
////localparam PARITY= 3'd3;
////localparam STOP  = 3'd4;
////
////reg [4:0] baud_cnt;    // counts 0..26 (27 cycles per bit)
////reg [3:0] bit_idx;     // 0..7 for data bits
////reg [7:0] latched_data;
////reg busy;
////reg parity_bit;
////reg tx_done_reg;
////
////assign tx_done = tx_done_reg;
////
////initial begin
////    tx = 1'b1;
////    tx_done_reg = 1'b0;
////    state = IDLE;
////    baud_cnt = 5'd0;
////    bit_idx = 4'd0;
////    latched_data = 8'd0;
////    busy = 1'b0;
////    parity_bit = 1'b0;
////end
////
////always @(posedge clk_3125) begin
////    // default: clear single-cycle flags unless set below
////    tx_done_reg <= 1'b0;
////
////    case (state)
////        IDLE: begin
////            tx <= 1'b1;
////            baud_cnt <= 5'd0;
////            bit_idx <= 4'd0;
////            if (tx_start && !busy) begin
////                // latch data and start transmission
////                latched_data <= data;
////                // parity computed as XOR of data bits (same as (^data) in user's code)
////                parity_bit <= ^data;
////                busy <= 1'b1;
////                tx <= 1'b0;       // start bit
////                baud_cnt <= 5'd0;
////                state <= START;
////            end
////        end
////
////        START: begin
////            // hold start bit for 27 cycles (0..26)
////            if (baud_cnt == 5'd26) begin
////                baud_cnt <= 5'd0;
////                bit_idx <= 4'd0;
////                state <= DATA;
////                tx <= latched_data[0]; // first data bit
////            end else begin
////                baud_cnt <= baud_cnt + 1'b1;
////                tx <= 1'b0;
////            end
////        end
////
////        DATA: begin
////            // transmit current data bit for 27 cycles
////            if (baud_cnt == 5'd26) begin
////                baud_cnt <= 5'd0;
////                if (bit_idx == 4'd7) begin
////                    // last data bit just transmitted, move to parity
////                    state <= PARITY;
////                    tx <= parity_bit;
////                end else begin
////                    bit_idx <= bit_idx + 1'b1;
////                    // set next data bit immediately (will be held for next bit period)
////                    tx <= latched_data[bit_idx + 1];
////                    state <= DATA;
////                end
////            end else begin
////                baud_cnt <= baud_cnt + 1'b1;
////                // keep current tx (already assigned)
////            end
////        end
////
////        PARITY: begin
////            // transmit parity for one bit time (27 cycles)
////            if (baud_cnt == 5'd26) begin
////                baud_cnt <= 5'd0;
////                state <= STOP;
////                tx <= 1'b1; // stop bit will be high
////            end else begin
////                baud_cnt <= baud_cnt + 1'b1;
////                tx <= parity_bit;
////            end
////        end
////
////        STOP: begin
////            // one stop bit (27 cycles). After this, pulse tx_done for one clk and return to IDLE.
////            if (baud_cnt == 5'd26) begin
////                baud_cnt <= 5'd0;
////                tx <= 1'b1;
////                tx_done_reg <= 1'b1; // one-cycle done pulse
////                busy <= 1'b0;
////                state <= IDLE;
////            end else begin
////                baud_cnt <= baud_cnt + 1'b1;
////                tx <= 1'b1;
////            end
////        end
////
////        default: begin
////            state <= IDLE;
////            tx <= 1'b1;
////            baud_cnt <= 5'd0;
////            busy <= 1'b0;
////        end
////    endcase
////end
////
//////////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////
////
////endmodule

module uart_tx(
    input clk_3125,
	 input baud_tick,
    input tx_start,
    input [7:0] data,
	 output reg read_en,
    output reg tx,
    output reg tx_done,
	 output reg start_crc
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////



localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam DATA  = 3'd2;
localparam PARITY= 3'd3;
localparam STOP  = 3'd4;
localparam READ_STATE = 3'd5;
localparam WAIT_STATE = 3'd6;

reg [2:0] state;
reg [3:0] bit_idx;         // Data bit counter 0–7
reg [7:0] latched_data;
reg parity_bit;
reg busy;
reg [3:0] counter;

initial begin
    tx = 1'b1;             // Idle line high
    tx_done = 1'b0;
	 read_en = 1'b0;
    state = READ_STATE;
    bit_idx = 4'd0;
    latched_data = 8'd0;
    parity_bit = 1'b0;
    busy = 1'b0;
	 start_crc = 1'b0;
	 counter = 4'd0;
end

always @(posedge clk_3125) 
begin
    if (baud_tick)
	 begin
        tx_done <= 1'b0; 
        case (state)
		  
		  
		  	READ_STATE:
		    begin 
			   read_en <= 1'b1;
				state   <= WAIT_STATE; 
				
				if(counter == 8'h1) 
				begin 
				   start_crc <= 1'b1;
				end 
				
				else 
				  start_crc <= 1'b0;
			end 
			
			
				//if(counter == 4'd0 && data > 8'h0)
				//begin 
				//  counter <= 4'd0;
				 // start_crc <= 1'b1;
				//end 
				
				//else 
				//begin 
				//if(data > 8'h0)
				//begin
				//counter <= counter + 1'b1;
				//start_crc <= 1'b0;
				//end
				//end 
				
			 //end 
			 
			 
		  WAIT_STATE:
		    begin 
			   state <= IDLE;
				read_en <= 1'b0;
		    end 
			 
            IDLE: begin
                tx <= 1'b1;
                if (tx_start && !busy) 
					 begin
                    latched_data <= data;
                    parity_bit <= ^data;   // even parity
                    busy <= 1'b1;
                    tx <= 1'b0;            // start bit
                    state <= START;
                end
            end

            START: begin
                state <= DATA;
                bit_idx <= 4'd0;
                tx <= latched_data[0];
            end

            DATA: begin
                if (bit_idx == 4'd7) 
					 begin
                    state <= PARITY;
                    tx <= parity_bit;
                end 
					 else 
					 begin
                    bit_idx <= bit_idx + 1'b1;
                    tx <= latched_data[bit_idx + 1];
                end
            end

            PARITY: begin
                state <= STOP;
                tx <= 1'b1;  // stop bit is high
            end

            STOP: begin
                tx <= 1'b1;
                if(data >= 8'h0) begin tx_done <= 1'b1; counter <= counter + 1'b1; end // Pulse for 1 baud tick
                busy <= 1'b0;
                state <= READ_STATE;
            end

            default: begin
                tx <= 1'b1;
                state <= READ_STATE;
                busy <= 1'b0;
            end
        endcase
    end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

