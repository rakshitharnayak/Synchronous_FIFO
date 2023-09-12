class fifo_test extends uvm_test;
  fifo_sequence seq;
  fifo_environment env;
  `uvm_component_utils(fifo_test)
  
  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = f_sequence::type_id::create("seq", this);
    env = f_environment::type_id::create("env", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agt.seqr);
    phase.drop_objection(this);
    // phase.phase_done.set_drain_time(this, 100);
  endtask
  
endclass
