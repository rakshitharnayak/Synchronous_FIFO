import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_if.sv"
`include "fifo_test.sv"

module tb;
  bit clk;
  bit rstn;
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 1;
    rstn = 0;
    #5;
    rstn = 1;
  end
  
  fifo_if fif(clk, rstn);
  
  SYN_FIFO dut(.clk(fif.clk),
               .rstn(fif.rstn),
               .i_wrdata(fif.i_wrdata),
               .i_wren(fif.i_wren),
               .i_rden(fif.i_rden),
               .o_full(fif.o_full),
               .o_alm_full(fif.o_alm_full),
               .o_alm_empty(fif.o_alm_empty),
               .o_empty(fif.o_empty),
               .o_rddta(fif.o_rddata));
  
  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "", "vif", fif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
    run_test("fifo_test");
  end
  
endmodule
