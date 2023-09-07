class fifo_sequence1 extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_sequence1)
  fifo_seq_item tr;
  function new(string name = "fifo_sequence1");
    super.new(name);
  endfunction

  //// FIFO test 1
// write FIFO from empty to full -> read FIFO from full to empty
    task body();
      for (int i = 0; i < DEPTH *2; i++) begin 
            tr = data_transaction::type_id::create("tr");
            start_item(tr);
            
        if (i < DEPTH) begin
          if (!tr.randomize() with {tr.i_wren == 1'b1; tr.rden == 1'b0;}) begin
            `uvm_error("Sequence", "Randomization failure for transaction")
                end 
            end
            else begin
                if (!tr.randomize() with {tr.i_wren == 1'b0; tr.rden == 1'b1;}) begin
                  `uvm_error("Sequence", "Randomization failure for transaction")
                end 
            end

            finish_item(tr); 
        end
    endtask
endclass: fifo_sequence1


//FOFO test 2
// Write FIFO from empty to almost full, and then read/write at the same time
class fifo_sequence2 extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_sequence2)
  fifo_seq_item tr;
  
  function new(string name = "fifo_sequence2");
    super.new(name);
  endfunction
	
	task body();
    for (int i = 0; i < DEPTH *2; i++) begin 
          	tr = data_transaction::type_id::create("tr");
            start_item(tr);
      
     //i<1020   -> write till almost full    
            if (i < (DEPTH - UPP_TH)) begin
                if (!tr.randomize() with {tr.i_wren == 1'b1; tr.rden == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end
      
      // then read and write at the same time
            else begin    
                if (!tr.randomize() with {tr.i_wren == 1'b1; tr.rden == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end

            finish_item(tr); 
        end
	endtask
endclass: fifo_sequence2


//FIFO test3
// Write FIFO from empty to almostfull, and then read till almost empty, and then read/write at the same time
class fifo_sequence3 extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_sequence3)
  fifo_seq_item tr;
  
  function new(string name = "fifo_sequence3");
    super.new(name);
  endfunction
	
	task body();
    for (int i = 0; i < DEPTH *2; i++) begin 
          	tr = data_transaction::type_id::create("tr");
            start_item(tr);
      
     //i<1020   -> write till almost full    
            if (i < (DEPTH - UPP_TH)) begin
                if (!tr.randomize() with {tr.i_wren == 1'b1; tr.rden == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end
      
      // then read till almost full
      else if(i>=1020) begin    
        if (!tr.randomize() with {tr.i_wren == 1'b0; tr.rden == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end
      //then read and write at the same time
      else begin
        if (!tr.randomize() with {tr.i_wren == 1'b1; tr.rden == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end

            finish_item(tr); 
        end
	endtask
endclass: fifo_sequence3
