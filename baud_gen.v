//module baud_gen #(
//    parameter SYS_CLK_FREQ     = 50_000_000,
//    parameter BAUD_RATE        = 9_600,
//    parameter OVERSAMPLE_RATE  = 16)
//	
//	(input  wire i_clk,
//    input  wire i_reset,   
//    input  wire i_sync,    
//    output reg  o_tick );
//
//    localparam integer CLKS_PER_OVERSAMPLE = (SYS_CLK_FREQ / (BAUD_RATE * OVERSAMPLE_RATE));
//    localparam integer CNT_WIDTH = $clog2(CLKS_PER_OVERSAMPLE);
//    reg [CNT_WIDTH-1:0] r_cnt;
//
//    always @(posedge i_clk) 
//	 begin
//        if (i_reset) 
//		  begin
//            r_cnt  <= {CNT_WIDTH{1'b0}};
//            o_tick <= 1'b0;
//        end 
//		  else 
//		  begin
//            o_tick <= 1'b0; 
//
//            if (i_sync)
//				begin
//               
//                r_cnt <= {CNT_WIDTH{1'b0}};
//            end 
//				else 
//				begin
//                if (r_cnt == CLKS_PER_OVERSAMPLE - 1)
//					 begin
//                    r_cnt  <= {CNT_WIDTH{1'b0}};
//                    o_tick <= 1'b1;  
//                end
//					 else
//					 begin
//                    r_cnt <= r_cnt + 1'b1;
//                end
//            end
//        end
//    end
//endmodule
module baud_gen #(parameter SYS_CLK = 3125000, BAUD = 115200)(
    input clk_3125,
    input reset,
    output reg baud_tick
);
    localparam integer COUNT_MAX = SYS_CLK / BAUD; // â‰ˆ 27
    integer count = 0;
    always @(posedge clk_3125 or negedge reset) 
	 begin
        if (~reset) 
		  begin
            count <= 0;
            baud_tick <= 0;
        end 
		  else 
		  begin
            if (count == COUNT_MAX - 1) 
				begin
                count <= 0;
                baud_tick <= 1;
            end 
				else 
				begin
                count <= count + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule
