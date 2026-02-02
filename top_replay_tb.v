module top_replay_tb();
reg         clk;
reg         reset_n;
reg         enable;
reg  [ 7:0] data_in;
wire [ 7:0] data_out;
wire        replay_error;

top_replay aa1(clk,reset_n,enable,data_in,data_out,replay_error);

initial
begin
              clk = 1'b1;
  forever #10 clk = ~clk;
end


initial
begin
     reset_n = 1'b0; enable = 1'b1; data_in = 8'h48;
#20  reset_n = 1'b1;  
#20  data_in = 8'h65; 
#20  data_in = 8'h6C; 
#20  data_in = 8'h6C;
#20  data_in = 8'h6F;
#20  data_in = 8'h31;
#20  data_in = 8'h32;
#20  data_in = 8'h33;
#20  data_in = 8'h40;
#20  data_in = 8'h45;
#20  data_in = 8'h46;
#20  data_in = 8'h47;
#20  data_in = 8'h48;
#20  data_in = 8'h49;
#20  data_in = 8'h50;
#20  data_in = 8'h51;
#20  data_in = 8'h52;
#20  data_in = 8'h53;
#40  enable  = 1'b0;

end
endmodule 
