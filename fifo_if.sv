interface fifo_if(input bit clk, rstn);
    logic i_wren, i_rden, o_alm_empty, o_empty, o_alm_full, o_full;
    logic [DATA_W - 1:0] i_wrdata;
    logic [DATA_W - 1:0] o_rddata;

    clocking d_cb @(posedge clk);
    default input #0 output #0;
    output i_wren;
    output i_rden;
    output i_wrdata;  
    input rstn;
  endclocking

    clocking m_cb @(posedge clk);
    default input #0 output #0;  
    input  o_alm_empty, o_empty, o_alm_full, o_full, o_rddata;    
  endclocking

  modport d_mp (clocking d_cb);
  modport m_mp (clocking m_cb);
      
endinterface 



