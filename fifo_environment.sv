class fifo_environment extends uvm_env;
  fifo_agent agt;
  fifo_sub coverage_h;
  fifo_scoreboard scb;
 
  `uvm_component_utils(fifo_environment)
  
  function new(string name = "fifo_environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = fifo_agent::type_id::create("agt", this);
    coverage_h = fifo_sub::type_id::create("coverage_h", this);
    scb = fifo_scoreboard::type_id::create("scb", this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //monitor to coverage
    agt.mon.item_got_port.connect(coverage_h.item_got_export1);
    //monitor to scoreboard connection
    agt.mon.item_got_port.connect(scb.item_got_export);
    uvm_report_info("FIFO_ENVIRONMENT", "connect_phase, Connected monitor to scoreboard");
  endfunction
  
endclass
