//MONITOR
 class fifo_monitor extends uvm_monitor;
  virtual fifo_if vif;
  fifo_seq_item tr;
  uvm_analysis_port#(fifo_seq_item) item_got_port;
  `uvm_component_utils(fifo_monitor)
  
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    item_got_port = new("item_got_port", this);
  endfunction
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = fifo_seq_item::type_id::create("tr");
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
  endfunction
      
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.m_mp.m_cb)
      if(vif.m_mp.m_cb.i_wren == 1 )begin
//         $display("\n write enable is high and read enable is low");
        tr.o_rddata = vif.m_mp.m_cb.o_rddata;
        tr.i_wren = 'b1;
        tr.i_rden = 'b0;
        tr.o_full = vif.m_mp.m_cb.o_full;
        tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
        tr.o_empty = vif.m_mp.m_cb.o_empty;
        tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
        item_got_port.write(tr);
      end
      else if( vif.m_mp.m_cb.i_rden == 1)begin
        @(posedge vif.m_mp.m_cb)
//         $display("\n write enable is low and read enable is high");
        tr.o_rddata = vif.m_mp.m_cb.o_rddata;
        tr.i_wren = 'b0;
        tr.i_rden = 'b1;
        tr.o_full = vif.m_mp.m_cb.o_full;
        tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
        tr.o_empty = vif.m_mp.m_cb.o_empty;
        tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
        item_got_port.write(tr);
      end
       end
  endtask
endclass
      
//       if(vif.m_mp.m_cb.i_wren == 1 && vif.m_mp.m_cb.i_rden == 1)begin
//         $display("\n write enable and read enable are high");
//         tr.i_wrdata = vif.m_mp.m_cb.i_wrdata;
//         tr.i_wren = 'b1;
//         tr.i_rden = 'b1;
//         tr.o_full = vif.m_mp.m_cb.o_full;
//         tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
//         tr.o_empty = vif.m_mp.m_cb.o_empty;
//         tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
//         item_got_port.write(tr);
//       end
//        if(vif.m_mp.m_cb.i_wren == 1 && vif.m_mp.m_cb.i_rden == 0)begin
//         @(posedge vif.m_mp.m_cb)
//         $display("\n write enable is high and read enable is low");
//         tr.o_rddata = vif.m_mp.m_cb.o_rddata;
//         tr.i_wren = 'b1;
//         tr.i_rden = 'b0;
//         tr.o_full = vif.m_mp.m_cb.o_full;
//         tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
//         tr.o_empty = vif.m_mp.m_cb.o_empty;
//         tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
//         item_got_port.write(tr);
//       end
//       if(vif.m_mp.m_cb.i_wren == 0 && vif.m_mp.m_cb.i_rden == 1)begin
//         @(posedge vif.m_mp.m_cb)
//         $display("\n write enable is low and read enable is high");
//         tr.o_rddata = vif.m_mp.m_cb.o_rddata;
//         tr.i_wren = 'b0;
//         tr.i_rden = 'b1;
//         tr.o_full = vif.m_mp.m_cb.o_full;
//         tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
//         tr.o_empty = vif.m_mp.m_cb.o_empty;
//         tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
//         item_got_port.write(tr);
//       end
//       if(vif.m_mp.m_cb.i_wren == 0 && vif.m_mp.m_cb.i_rden == 0)begin
//         @(posedge vif.m_mp.m_cb)
//         $display("\n write enable is low and read enable is low");
//         tr.o_rddata = vif.m_mp.m_cb.o_rddata;
//         tr.i_wren = 'b0;
//         tr.i_rden = 'b0;
//         tr.o_full = vif.m_mp.m_cb.o_full;
//         tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
//         tr.o_empty = vif.m_mp.m_cb.o_empty;
//         tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
//         item_got_port.write(tr);
//     end
   
    
