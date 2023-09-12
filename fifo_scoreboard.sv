class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(fifo_seq_item, fifo_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)
  
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  int queue[$];
  
  function void write(input fifo_seq_item tr);
    bit [7:0] examdata;
    if(tr.i_wren == 'b1)begin
      queue.push_back(tr.i_wrdata);
      `uvm_info("write Data", $sformatf("wr: %0b, rd: %0b, data_in: %0h, almost_full = %0b, full: %0b, ",tr.i_wren, tr.i_rde,tr.i_wrdata, tr.o_alm_full, tr.o_full), UVM_LOW);
    end
    else if (tr.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h, data_out: %0h, almost_empty = %0b, empty: %0b", examdata, tr.o_rddata, tr.o_alm_empty, tr.o_empty), UVM_LOW);
        if(examdata == tr.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
    end
  endfunction
endclass
        
