//module uart_rx(
//    input clk_3125,
//    input rx,
//    output reg [7:0] rx_msg,
//    output reg rx_complete
//    );
//
//reg [4:0] counter1;
//reg [2:0] counter, ones;
//reg l, n, sample, flag, baud_start;
//reg [1:0] state;
//reg [7:0] k;
//reg [9:0] baudcount, samplepoint;
//reg [4:0] d_count;
//parameter start = 2'b00, data = 2'b01, parity = 2'b10, stop = 2'b11;
//reg rx_parity;
//
//initial begin
//    l = 0;
//    n = 0;
//    rx_msg = 0;
//    rx_parity = 0;
//    rx_complete = 0;
//    counter = 3'b000;
//    counter1 = 0;
//    k = 8'd0;
//    ones = 0;
//    state = start;
//    baudcount = 0;
//    samplepoint = 4'd14;
//    sample = 0;
//    flag = 0;
//    baud_start = 0;
//end
//
//always @(posedge clk_3125) begin
//    rx_complete = 0;
//    flag <= 0;
//
//    if (!rx && state == start)
//        baud_start = 1;
//
//    if (baudcount == 9'd297) begin
//        baud_start = 0;
//        baudcount = 1;
//        samplepoint <= 14;
//        flag <= 1;
//    end
//
//    if (baud_start) begin
//        if (baudcount < 9'd297) begin
//            if (baudcount == samplepoint) begin
//                sample <= 1;
//                samplepoint <= samplepoint + 5'd27;
//            end else begin
//                samplepoint <= samplepoint;
//                sample <= 0;
//            end
//            baudcount = baudcount + 1;
//        end
//    end
//
//    if (flag) begin
//        rx_msg <= k;
//        rx_complete <= 1;
//        rx_parity <= n;
//        l = 0;
//    end
//
//    if (sample) begin
//        case (state)
//            start: begin
//                if (rx == 0)
//                    state = data;
//                else
//                    state = start;
//            end
//
//            data: begin
//                if (counter <= 7 && counter >= 0) begin
//                    if (rx)
//                        ones = ones + 1;
//                    k[counter] = rx;
//                    if (counter == 7) begin
//                        counter = 0;
//                        state = parity;
//                    end else begin
//                        counter = counter + 1;
//                        state = data;
//                    end
//                end
//            end
//
//            parity: begin
//                n = ones[0] ? 1 : 0;
//                state = stop;
//                ones = 0;
//            end
//
//            stop: begin
//                if (rx) begin
//                    state = start;
//                    l = 1;
//                end
//            end
//
//            default: state = start;
//        endcase
//    end
//end
//
//endmodule

module uart_rx(
    input  clk_3125,
    input  baud_tick,       
    input  rx,
    output reg [7:0] rx_msg,
    output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

localparam IDLE   = 3'd0;
localparam START  = 3'd1;
localparam DATA   = 3'd2;
localparam PARITY = 3'd3;
localparam STOP   = 3'd4;

reg [2:0] state;
reg [3:0] bit_idx;        // 0..7 data bits
reg [7:0] shift_reg;
reg [3:0] ones_count;     // count of ones in data
reg rx_busy;
reg rx_parity_bit;

initial begin
    rx_msg = 8'd0;
    rx_complete = 1'b0;
    state = IDLE;
    bit_idx = 4'd0;
    shift_reg = 8'd0;
    ones_count = 4'd0;
    rx_busy = 1'b0;
    rx_parity_bit = 1'b0;
end

always @(posedge clk_3125) 
begin
    rx_complete <= 1'b0;
   
    if (baud_tick) 
	 begin
        case (state)
            IDLE: begin
              
                if (rx == 1'b0)
					 begin
                    rx_busy <= 1'b1;
                    ones_count <= 4'd0;
                    bit_idx <= 4'd0;
                    shift_reg <= 8'd0;
                    state <= START;
                end
            end

            START: begin
                state <= DATA;
                bit_idx <= 4'd0;
                shift_reg[0] <= rx;
                ones_count <= rx ? ones_count + 1'b1 : ones_count;
            end

            DATA: begin
                if (bit_idx == 4'd7) 
					 begin
                    state <= PARITY;
                end 
					 else 
					 begin
                    bit_idx <= bit_idx + 1'b1;
                    shift_reg[bit_idx + 1] <= rx;
                    if 
								(rx) ones_count <= ones_count + 1'b1;
                end
            end

            PARITY: begin
                rx_parity_bit <= rx;
                state <= STOP;
            end

            STOP: begin
                if (rx == 1'b1) 
					 begin
                    rx_msg <= shift_reg;
                    if(shift_reg >= 8'h0) rx_complete <= 1'b1;
                end
                rx_busy <= 1'b0;
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
end
endmodule
