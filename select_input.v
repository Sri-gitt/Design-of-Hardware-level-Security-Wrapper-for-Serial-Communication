module select_input
(
  input clk,
  input [7:0] data_in,
  input [7:0] crc,
  input       crc_done,
  output  reg [7:0]    output_data
);

 always@(*)
 begin 
 
   if(crc_done)
	   output_data = crc;
	else 
	   output_data = data_in;
 end 
 
  
endmodule 

