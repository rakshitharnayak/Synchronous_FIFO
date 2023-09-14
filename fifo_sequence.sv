//SEQUENCE
`include "defines.sv"

class fifo_sequence extends uvm_sequence#(fifo_seq_item);
	`uvm_object_utils(fifo_sequence)
  	fifo_seq_item req;
  
    function new(string name = "fifo_sequence");
      super.new(name);
    endfunction

    task body();
      
	 `uvm_info(get_type_name(), $sformatf("******** Generate 1024 WRITE REQs ********"), UVM_LOW)
      repeat(`DEPTH) begin
        req = fifo_seq_item::type_id::create("req");
      	start_item(req);
        assert(req.randomize() with {i_wren == 1; i_rden == 0;});
      	finish_item(req);
      end
      
	 `uvm_info(get_type_name(), $sformatf("******** Generate 1024 Read REQs ********"), UVM_LOW)
      repeat(`DEPTH) begin
        req = fifo_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {i_wren == 0; i_rden == 1;});
        finish_item(req);
      end
      
// 	    `uvm_info(get_type_name(), $sformatf("******** Generate 1024 WRITE AND READ IN PARALLEL REQs ********"), UVM_LOW)
//       repeat(`DEPTH) begin
//           req = fifo_seq_item::type_id::create("req");
//           start_item(req);
//           assert(req.randomize() with {i_wren == 1; i_rden == 1;});
//                 `uvm_info("Sequence",$sformatf("randomised value, i_wren:%0d , i_rden:%0d" ,req.i_wren,req.i_rden), UVM_NONE);
//           finish_item(req);
//         end
      
//       `uvm_info(get_type_name(), $sformatf("******** Generate 1024 WRITE AND READ IN ALTERNATE REQs ********"), UVM_LOW)
//       repeat(`DEPTH) begin
//           req = fifo_seq_item::type_id::create("req");
//           start_item(req);
//           assert(req.randomize() with {i_wren == 1; i_rden == 0;});
//           finish_item(req);	  
//           start_item(req);
//           assert(req.randomize() with {i_wren == 0; i_rden == 1;});
//           finish_item(req);
//         end
      
    endtask
endclass
