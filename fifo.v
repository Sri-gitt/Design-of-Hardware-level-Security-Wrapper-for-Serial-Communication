module fifo(
       input            clk,reset,enable,write_en,read_en,baud_tick,crc_done,rx_complete,
       input      [7:0] input_data,
       output reg [7:0] output_data
);

reg [3:0] write_add;                        //write pointer 
reg [3:0] read_add;                         //read pointer
reg [3:0] counter;                          //counter to indicate empty and full queue
reg [7:0] mem [15:0];                       //creates a memory of 16 elements with 8 bit wide
reg       full_queue,empty_queue;           //full and empty flags 

always @(posedge clk or negedge reset)
begin
     if(~reset)                             //initialising all the values to zero at reset

        begin
        counter=4'b0;
        write_add=4'd0;
        read_add=4'd0;
        full_queue=1'b0;
        empty_queue=1'b0;
        output_data=8'b0;
        end

     else    
        begin
        if(write_en && !full_queue && (enable || crc_done))

           begin
           mem[write_add]<=input_data;     //stores the input data in wr_add
           counter<=counter+1'b1;
           write_add<=(write_add+1) % 16;  //increments wr_add by 1 
           end
			  
		    if(write_en && !full_queue && rx_complete)

           begin
           mem[write_add]<=input_data;     //stores the input data in wr_add
           counter<=counter+1'b1;
           write_add<=(write_add+1) % 16;  //increments wr_add by 1 
           end
			  

        if(read_en && !empty_queue && baud_tick)
 
          begin
          output_data<=mem[read_add];      //data is read from read_add
          counter<=counter-1'b1;
          read_add<=(read_add+1)%16;       //increments read_add by 1 
          end

       full_queue=(counter==4'd15)?1:0;   //full=1 when all the memory elemts hold data 
       empty_queue=(counter==4'd0)?1:0;   //empty=0 when all the data is read 

        end
end
endmodule
