module crc_top
(
  input             clk,
  input             reset_n,
  input             enable,
  input    [7:0]    data_in,
  input   [15:0]    key,
  output            crc_done, 
  output  [7:0]     crc
);

wire       write_en_crc ;
wire       read_en_crc;
wire       read_en_uart;
wire [7:0] output_data_to_crc;
wire [7:0] data_to_uart;
wire       baud_tick;
wire [7:0] output_data_to_uart;
wire       tx_rx_bit;
wire       tx_done;
wire [7:0] rx_msg;
wire       rx_complete;
wire       start_crc;
wire [7:0] output_to_check;
wire       start_crc_rx;
wire       write_en_rx;
wire       read_en_rx;
wire       crc_done_rx;
wire  [7:0] crc_rx;
wire        flag;

  fifo      crc_fifo (clk,reset_n,enable,1'b1,read_en_crc,1'b1,crc_done,1'b0,data_in,output_data_to_crc);
  
  crc_check c1 (clk,reset_n,output_data_to_crc,key,start_crc,write_en_crc,read_en_crc,crc_done,crc);
  
  select_input s1(clk, data_in , crc, crc_done, data_to_uart);
  
  baud_gen bg1  (clk,reset_n,baud_tick);
  
  fifo     uart_fifo(clk,reset_n,enable,1'b1,read_en_uart,baud_tick,crc_done,1'b0,data_to_uart,output_data_to_uart);
 
  uart_tx  utx1 (clk,baud_tick,1'b1,output_data_to_uart,read_en_uart,tx_rx_bit,tx_done,start_crc);
  
  uart_rx  urx1 (clk,baud_tick,tx_rx_bit,rx_msg,rx_complete);
  
  //fifo     uart_fifo_rx(clk,reset_n,1'b0,1'b1,read_en_rx,1'b1,1'b0,rx_complete,rx_msg,output_to_check);
 
  crc_check c2 (clk,reset_n,rx_msg,key,rx_complete,write_en_rx,read_en_rx,crc_done_rx,crc_rx);
  

endmodule 

