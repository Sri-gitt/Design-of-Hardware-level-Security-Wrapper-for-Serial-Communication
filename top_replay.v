module top_replay
(
  input            clk_3125,
  input            reset, 
  input            enable,
  input      [7:0] data,
  
  output     [7:0] rx_msg,
  output           replay_error
);

wire [7:0] data_in_replay;
wire [7:0] data_out_replay;
wire       read_en_replay;
wire       read_en_uart;
wire       data_ready;
wire [7:0] data_in_uart;
wire       tx_rx_bit;
wire       tx_done;
wire       rx_complete;
wire       read_en_check;
wire [7:0] data_in_check;

  
  fifo      f1  (clk_3125,reset,enable,1'b1,read_en_replay,1'b1,data,data_in_replay);
  
  replay_protection_tx rpt1(clk_3125 ,reset , data_in_replay, read_en_replay, data_out_replay,data_ready);
  
  fifo      f2  (clk_3125,reset,1'b1,data_ready,read_en_uart,baud_tick,data_out_replay,data_in_uart);
  
  baud_gen bg1  (clk_3125,reset,baud_tick);
  
  uart_tx  utx1 (clk_3125,baud_tick,1'b1,data_in_uart,read_en_uart,tx_rx_bit,tx_done);
  
  uart_rx  urx1 (clk_3125,baud_tick,tx_rx_bit,rx_msg,rx_complete);
  
  replay_protection_rx rpr1 (clk_3125,reset,rx_msg,rx_complete,replay_error);
  
  
endmodule 
