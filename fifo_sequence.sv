class fifo_sequence extends uvm_sequence#(fifo_seq_item);
	`uvm_object_utils(fifo_sequence)
  fifo_seq_item req;
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  //// FIFO test 1
// write FIFO from empty to full 
    task body();
	     end
	    `uvm_info(get_type_name(), $sformatf("******** Generate 1024 WRITE REQs ********"), UVM_LOW)
	    repeat(DEPTH) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
	 assert(req.randomize() with {i_wren == 1; i_rden = 0;});
      finish_item(req);
    end
	    `uvm_info(get_type_name(), $sformatf("******** Generate 1024 Read REQs ********"), UVM_LOW)
 repeat(DEPTH) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
	 assert(req.randomize() with {i_wren == 0; i_rden = 1;});
      finish_item(req);
    end
	    `uvm_info(get_type_name(), $sformatf("******** Generate 20 WRITE AND READ IN PARALLEL REQs ********"), UVM_LOW)
	    repeat(DEPTH) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
	    assert(req.randomize() with {i_wren == 1; i_rden = 1;});
      finish_item(req);
    end
	    `uvm_info(get_type_name(), $sformatf("******** Generate 20 WRITE AND READ IN ALTERNATE REQs ********"), UVM_LOW)
	    repeat(DEPTH) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
		    assert(req.randomize() with {i_wren == 1; i_rden = 0;});
      finish_item(req);
    end
  endtask
endclass: fifo_sequence3
