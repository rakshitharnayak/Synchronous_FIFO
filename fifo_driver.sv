class fifo_driver extends uvm_driver#(f_seq_item);
  virtual fifo_if vif;
  fifo_seq_item tr;
  `uvm_component_utils(fifo_driver)
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "No vif is found!")
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.d_mp.d_cb.wr <= 'b0;
    vif.d_mp.d_cb.rd <= 'b0;
    vif.d_mp.d_cb.data_in <= 'b0;
    forever begin
      seq_item_port.get_next_item(req);
      if(req.wr == 1)
        main_write(req.data_in);
      else if(req.rd == 1)
        main_read();
      seq_item_port.item_done();
    end
  endtask
  
  virtual task main_write(input [7:0] din);
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.wr <= 'b1;
    vif.d_mp.d_cb.data_in <= din;
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.wr <= 'b0;
  endtask
  
  virtual task main_read();
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.rd <= 'b1;
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.rd <= 'b0;
  endtask

endclass
  
   
