class fifo_sub extends uvm_subscriber #(fifo_seq_item);

  uvm_analysis_imp#(fifo_seq_item, fifo_sub) item_got_export1;
  //----------------------------------------------------------------------------
  `uvm_component_utils(fifo_sub)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  fifo_seq_item txn;
  real cov;
  
  //----------------------------------------------------------------------------
  covergroup dut_cov;
//     option.per_instance= 1;
//     option.comment     = "dut_cov";
//     option.name        = "dut_cov";
//     option.auto_bin_max= 4;
    A:coverpoint txn.i_wren { 
        bins i_wren_low  ={0};
        bins i_wren_high ={1};
    }
    B:coverpoint txn.i_rden { 
        bins i_rden_low  ={0};
        bins i_rden_high ={1};
    }
    AXB:cross A,B;
  endgroup:dut_cov;
  
  //----------------------------------------------------------------------------
  function new(string name="fifo_sub",uvm_component parent);
    super.new(name,parent);
    item_got_export1 = new("item_got_export1", this);
    txn=fifo_seq_item::type_id::create("txn");
    dut_cov=new();
    
  endfunction
  

  //---------------------  write method ----------------------------------------
  function void write(fifo_seq_item t);
    txn=t;
    dut_cov.sample();
    $display("coverage =%0d ",dut_cov.get_coverage());
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=dut_cov.get_coverage();
  endfunction
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass

