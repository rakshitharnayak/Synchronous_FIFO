//MONITOR
 class fifo_monitor extends uvm_monitor;
  virtual fifo_if vif;
  fifo_seq_item trans;
  uvm_analysis_port#(fifo_seq_item) item_got_port;
  `uvm_component_utils(fifo_monitor)
  
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    item_got_port = new("item_got_port", this);
  endfunction
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans = fifo_seq_item::type_id::create("trans");
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
  endfunction
      
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.m_mp.m_cb)
//       if(vif.m_mp.m_cb.i_wren == 1 && vif.m_mp.m_cb.i_rden == 1)begin
//         $display("\n write enable and read enable are high", $time);
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
//          $display("\n time = %0t, write enable is high and read enable is low",$time);
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
//         $display("\n time = %0t,write enable is low and read enable is high", $time);
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
//         $display("\n time = %0t, write enable is low and read enable is low",$time);
//         tr.o_rddata = vif.m_mp.m_cb.o_rddata;
//         tr.i_wren = 'b0;
//         tr.i_rden = 'b0;
//         tr.o_full = vif.m_mp.m_cb.o_full;
//         tr.o_alm_full = vif.m_mp.m_cb.o_alm_full;
//         tr.o_empty = vif.m_mp.m_cb.o_empty;
//         tr.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
//         item_got_port.write(tr);
//     end


   
    //***************************************************
    if(vif.m_mp.m_cb.i_wren == 1 )begin
      $display("\n time = %0t, write enable is high and read enable is low",$time);
     
        trans.i_wrdata = vif.m_mp.m_cb.i_wrdata;
        trans.i_wren = 'b1;
        trans.i_rden = 'b0;
//        $display("monitor -> i_wrdata = %0h", trans.i_wrdata);
        trans.o_full = vif.m_mp.m_cb.o_full;
        trans.o_alm_full = vif.m_mp.m_cb.o_alm_full;
      	item_got_port.write(trans);
      end
       if( vif.m_mp.m_cb.i_rden == 1)begin
//        @(posedge vif.m_mp.m_cb)
         $display("\n time = %0t, write enable is low and read enable is high", $time);
        trans.o_rddata = vif.m_mp.m_cb.o_rddata;
        trans.i_wren = 'b0;
        trans.i_rden = 'b1;
         $display("\n time = %0t, monitor -> readdata virtual = %0h \n read data = %0h", $time, vif.m_mp.m_cb.o_rddata,trans.o_rddata);
        trans.o_empty = vif.m_mp.m_cb.o_empty;
        trans.o_alm_empty = vif.m_mp.m_cb.o_alm_empty;
        item_got_port.write(trans);
      end
      
    end
  endtask
endclass
