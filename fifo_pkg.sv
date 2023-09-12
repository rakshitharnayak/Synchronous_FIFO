//This package includes all the files in the testbench architecture 
//which will be imported in the top module
package fifo_pkg;
  `include "fifo_sequence_item.sv"
  `include "fifo_sequence.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_agent.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_environment.sv"
  `include "fifo_test.sv"
endpackage
