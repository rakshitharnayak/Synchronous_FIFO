// Code your design here
module SYN_FIFO(clk, rstn, i_wrdata, i_wren, i_rden, o_full, o_alm_full, o_alm_empty, o_empty, o_rddata);
  parameter ADDRESS = 10, DATA_W = 128, DEPTH = 1024, UPP_TH = 4, LOW_TH = 2;
  
  input clk, rstn, i_wren, i_rden;
  input [DATA_W-1:0] i_wrdata;
  output reg o_full, o_alm_full, o_alm_empty, o_empty;
  output reg [DATA_W-1:0] o_rddata;
  
  reg [ADDRESS-1:0] wr_ptr, rd_ptr;
  reg [DATA_W-1:0] memory [DEPTH-1:0];
  reg [ADDRESS-1:0] cur_ptr;
 
  assign o_full = (cur_ptr == 'b1111111111);
  assign o_empty = (cur_ptr =='b0000000000);
  
  always@(posedge clk)begin
    if(rstn == 0)begin
      wr_ptr <= 'b0;
      rd_ptr <= 'b0;
      o_rddata <= 'b0;
      foreach (memory[i,j])
        memory[i][j] <= 'b0;
    end
    else begin
      if(i_wren == 1 && o_full != 1)begin
        memory[wr_ptr] <= i_wrdata;
        wr_ptr <= wr_ptr+1;
      end
      if(i_rden == 1 && o_empty!= 1)begin
        o_rddata <= memory[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end
      cur_ptr = wr_ptr - rd_ptr;
    end
  end
endmodule
