///SEQUENCE_ITEM

class fifo_seq_item extends uvm_sequence_item;

  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [`DATA_W - 1:0]i_wrdata;
  rand bit i_wren;
  rand bit i_rden;
  bit o_full;
  bit o_empty;
  bit o_alm_full;
  bit o_alm_empty;
  bit [`DATA_W - 1:0]o_rddata;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(fifo_seq_item)
  `uvm_field_int(i_wrdata, UVM_ALL_ON)
  `uvm_field_int(i_wren, UVM_ALL_ON)
  `uvm_field_int(i_rden, UVM_ALL_ON)
  `uvm_field_int(o_full, UVM_ALL_ON)
  `uvm_field_int(o_empty, UVM_ALL_ON)
  `uvm_field_int(o_alm_full, UVM_ALL_ON)
  `uvm_field_int(o_alm_empty, UVM_ALL_ON)
  `uvm_field_int(o_rddata, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constraint
  //---------------------------------------
 
  
  //---------------------------------------
  //Pre randomize function
  //---------------------------------------
  // function void pre_randomize();
  //   if(rd)
  //     data_in.rand_mode(0);
  // endfunction
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name="fifo_seq_item");
    super.new(name);
  endfunction
  
  // function string convert2string();
  //   return $psprintf("data_in=%0h,data_out=%0h,wr=%0d,rd=%0d,full=%od,empty=%0d",data_in,data_out,wr,rd,full,empty);
  // endfunction
  
endclass
