module crc_check_tb();
reg         clk;
reg         reset_n;
reg         enable;
reg  [ 7:0] data_in;
reg  [15:0] key;
wire        crc_done;
wire [ 7:0] crc;


crc_top aa1(clk,reset_n,enable,data_in,key,crc_done,crc);

initial
begin
             clk = 1'b1;
  forever #10 clk = ~clk;
end


initial
begin
     reset_n = 1'b0; key = 16'hBEEF; enable = 1'b1;
#20  reset_n = 1'b1; data_in = 8'h48; 
#20  data_in = 8'h65; 
#20  data_in = 8'h6C; 
#20  data_in = 8'h6C;
#20  data_in = 8'h6F;
#20  data_in = 8'h31;
#20  data_in = 8'h32;
#20  data_in = 8'h33;
#40  enable  = 1'b0;

end
endmodule 