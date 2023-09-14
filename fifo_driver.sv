//DRIVER

class fifo_driver extends uvm_driver#(fifo_seq_item);
  virtual fifo_if vif;
  fifo_seq_item tr;
  `uvm_component_utils(fifo_driver)
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))begin
      `uvm_fatal("Driver: ", "No vif is found!")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      if(vif.d_mp.d_cb.rstn==0) begin
        @(posedge vif.d_mp.d_cb)
        vif.d_mp.d_cb.i_wren <= 'b0;
        vif.d_mp.d_cb.i_rden <= 'b0;
        vif.d_mp.d_cb.i_wrdata <= 'b0;
      end
        seq_item_port.get_next_item(tr);
        if(tr.i_wren == 1)begin
          main_write(tr.i_wrdata);
        end
        else if(tr.i_rden == 1)begin
          main_read();
        end
        seq_item_port.item_done();
      end
  endtask
  
  virtual task main_write(input [`DATA_W - 1:0] din);
      @(posedge vif.d_mp.d_cb)
      vif.d_mp.d_cb.i_wren <= 'b1;
      vif.d_mp.d_cb.i_wrdata <= din;
      @(posedge vif.d_mp.d_cb)
      vif.d_mp.d_cb.i_wren <= 'b0;
  endtask
  
  virtual task main_read();
    @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.i_rden <= 'b1;
    @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.i_rden <= 'b0;
  endtask

endclass
