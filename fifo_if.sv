interface fifo_if;
    logic clk, rstn, i_wren, i_rden, o_alm_empty, o_empty, o_alm_full, o_full;
    logic [DATA_W - 1:0] i_wrdata;
    logic [DATA_W - 1:0] o_rddata;
endinterface 



