 //SCOREBOARD
class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(fifo_seq_item, fifo_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)

  bit [`DEPTH-1:0] counter;
  bit [`DEPTH-1:0] match;
  bit [`DEPTH-1:0] mismatch;
  
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit[`DATA_W -1:0] queue[$];
  
  function void write(input fifo_seq_item tr);
    bit [`DATA_W - 1:0] examdata;
    if(tr.i_wren == 'b1)begin
//       $display("SCOREBOAARD -> vif.d_mp.d_cb.i_wrdata = %0h",tr.i_wrdata);
		
      queue.push_back(tr.i_wrdata);
      counter++;
//       $display(" scoreboard: queue: %0p",queue);
      `uvm_info("SCOREBOARD: write Data", $sformatf("wr: %0b, rd: %0b, data_in: %0h, almost_full = %0b, full: %0b, counter = %0d ",tr.i_wren, tr.i_rden, tr.i_wrdata, tr.o_alm_full, tr.o_full,counter), UVM_LOW);
      
      //check o_alm_full 
      //1019,1020,1021,1022,1023
      if(queue.size() >= (`DEPTH -`UPP_TH-1) && queue.size() < `DEPTH)
        begin
          $display("counter = %0d", counter);
          $display("SCOREBOARD: ref almost FULL logic: almost full ");
          if(tr.o_alm_full == 1)
            $display("SCOREBOARD: dut almost FULL logic : ALMOST FULL = %0d",tr.o_alm_full);
        end
      
          //check o_full 
      //1024
      if(queue.size() == `DEPTH)
        begin
          $display("counter = %0d", counter);
          $display("SCOREBOARD: ref full logic:full ");
          if(tr.o_full == 1)
            $display("SCOREBOARD: dut full logic : FULL = %0d",tr.o_full);
        end
      
      
    end
     if (tr.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        counter--;
        `uvm_info("SCOREBOARD: Read Data", $sformatf("wr: %0b, rd: %0b, examdata: %0h, data_out: %0h, almost_empty = %0b, empty: %0b , counter = %0d",tr.i_wren, tr.i_rden, examdata, tr.o_rddata, tr.o_alm_empty, tr.o_empty,counter), UVM_LOW);
        
         //check o_alm_empty 
      //1,2
        if(queue.size() > 0 && queue.size() <= `LOW_TH)
        begin
          $display("counter = %0d", counter);
          $display("SCOREBOARD: ref almost EMPTY logic: almost empty ");
          if(tr.o_alm_empty == 1)
            $display("SCOREBOARD: dut almost EMPTY logic : ALMOST EMPTY = %0d",tr.o_alm_empty);
        end
      
          //check o_empty 
        if(queue.size() == 0)
        begin
          $display("counter = %0d", counter);
          $display("SCOREBOARD: ref empty logic: empty ");
          if(tr.o_empty == 1)
            $display("SCOREBOARD: dut empty logic: EMPTY =%0d",tr.o_empty);
        end
        
        if(examdata == tr.o_rddata)begin
          match++;
          $display("-------- 		Pass! 		--------");
          $display("$time = %0t, examdata = %0h , tr.o_rddata = %0h , MATCH = %0d", $time,examdata,tr.o_rddata, match);
        end
        else begin
          mismatch++;
          $display("$time = %0t, examdata = %0h , tr.o_rddata = %0h , MISMATCH = %0d", $time,examdata,tr.o_rddata, mismatch);
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
    end

//     if(count >= (DEPTH -UPP_TH-1) && count <DEPTH)
      
  endfunction
endclass
