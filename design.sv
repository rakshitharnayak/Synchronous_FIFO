// module SYN_FIFO #(parameter DEPTH=16, DATA_W=128, UPP_TH= 4 , LOW_TH= 2 ) (
//     input wire clk,         // Clock signal
//     input wire rstn,       // Reset signal
//     input wire i_wren,      // Write enable signal
//     input wire i_rden,      // Read enable signal
//     input wire [127:0] i_wrdata,   // Data input (128 bits)
//     output reg [127:0] o_rddata,   // Data output (128 bits)
//     output reg o_full,        // Full signal
//     output reg o_empty,    // Empty signal
//   output reg  o_alm_full,
//   output reg o_alm_empty
// );

//   // Depth of the FIFO

//   reg [127:0] fifo_mem [0:DEPTH-1];   // FIFO memory

//   reg [9:0] read_ptr = 0;   // Read pointer
//   reg [9:0] write_ptr = 0;  // Write pointer
//   reg [9:0] count = 0;      // Count of valid data in the FIFO

//   always @(posedge clk ) begin
//     if (rstn == 0) begin
//       read_ptr <= 0;
//       write_ptr <= 0;
//       count <= 0;
//       o_full <= 0;
//       o_alm_full <= 0;
//       o_alm_empty <= 0;
//       o_empty <= 1;  // FIFO is empty initially
//     end else begin
//       if (i_wren && (count < DEPTH)) begin
//         fifo_mem[write_ptr] <= i_wrdata;
//         write_ptr <= write_ptr + 1;
//         count++;
//         // FIFO is not empty when writing
//       end
//       if (i_rden && (count > 0)) begin
//         o_rddata <= fifo_mem[read_ptr];
//         read_ptr <= read_ptr + 1;
//         count <= count - 1;

//       end
//       if(count == DEPTH) begin
//         o_full <= 1; // Update full signal
//         o_empty <= 0;
//        o_alm_empty <= 0;
//         o_alm_full <=0;
        
//       end
   
        
//       else if (count ==0) begin
//          o_empty <= 1;// Update empty signal
//         o_full <= 0;
//         o_alm_empty <= 0;
//         o_alm_full <=0;
   
//       end
      
//       else if( count >= (DEPTH -UPP_TH-1) && count <DEPTH)
//         begin
//           o_alm_full <=1;
//           o_alm_empty <= 0;
// 		 o_empty <= 0;// Update empty signal
//         o_full <= 0;
//         end
      
//             else if( count > 0 && count <= LOW_TH)
//         begin
//           o_alm_empty <=1;
//            o_alm_full <=0;
//           o_empty <= 0;// Update empty signal
//         o_full <= 0;
//         end
      
//       else
//         begin
//            o_full <= 0; // Update full signal
//          o_empty <= 0;
//           o_alm_full <= 0;
//           o_alm_empty <=0;
//         end
//     end
//   end

// endmodule


module my_fifo #(
                   parameter DATA_W           = 128      ,        // Data width
                   parameter DEPTH            = 1024      ,        // Depth of FIFO                   
                   parameter UPP_TH           = 4      ,        // Upper threshold to generate Almost-full
                   parameter LOW_TH           = 2               // Lower threshold to generate Almost-empty
                )

                (
                   input                   clk         ,        // Clock
                   input                   rstn        ,        // Active-low Synchronous Reset
                   
                   input                   i_wren      ,        // Write Enable
                   input  [DATA_W - 1 : 0] i_wrdata    ,        // Write-data
                   output                  o_alm_full  ,        // Almost-full signal
                   output                  o_full      ,        // Full signal

                   input                   i_rden      ,        // Read Enable
                   output [DATA_W - 1 : 0] o_rddata    ,        // Read-data
                   output                  o_alm_empty ,        // Almost-empty signal
                   output                  o_empty              // Empty signal
                );


/*-------------------------------------------------------------------------------------------------------------------------------
   Internal Registers/Signals
-------------------------------------------------------------------------------------------------------------------------------*/
logic [DATA_W - 1        : 0] data_rg [DEPTH] ;        // Data array
logic [$clog2(DEPTH) - 1 : 0] wrptr_rg        ;        // Write pointer
logic [$clog2(DEPTH) - 1 : 0] rdptr_rg        ;        // Read pointer
logic [$clog2(DEPTH)     : 0] dcount_rg       ;        // Data counter
      
logic                         wren_s          ;        // Write Enable signal generated iff FIFO is not full
logic                         rden_s          ;        // Read Enable signal generated iff FIFO is not empty
logic                         full_s          ;        // Full signal
logic                         empty_s         ;        // Empty signal


/*-------------------------------------------------------------------------------------------------------------------------------
   Synchronous logic to write to and read from FIFO
-------------------------------------------------------------------------------------------------------------------------------*/
always @ (posedge clk) begin

   if (!rstn) begin      
      
      data_rg   <= '{default: '0} ;
      wrptr_rg  <= 0              ;
      rdptr_rg  <= 0              ;      
      dcount_rg <= 0              ;

   end

   else begin   
            
      /* FIFO write logic */            
      if (wren_s) begin                          
                  
         data_rg [wrptr_rg] <= i_wrdata ;        // Data written to FIFO

         if (wrptr_rg == DEPTH - 1) begin
            wrptr_rg <= 0               ;        // Reset write pointer  
         end

         else begin
            wrptr_rg <= wrptr_rg + 1    ;        // Increment write pointer            
         end

      end

      /* FIFO read logic */
      if (rden_s) begin         

         if (rdptr_rg == DEPTH - 1) begin
            rdptr_rg <= 0               ;        // Reset read pointer
         end

         else begin
            rdptr_rg <= rdptr_rg + 1    ;        // Increment read pointer            
         end

      end

      /* FIFO data counter update logic */
      if (wren_s && !rden_s) begin               // Write operation
         dcount_rg <= dcount_rg + 1 ;
      end                    
      else if (!wren_s && rden_s) begin          // Read operation
         dcount_rg <= dcount_rg - 1 ;         
      end

   end

end


/*-------------------------------------------------------------------------------------------------------------------------------
   Continuous Assignments
-------------------------------------------------------------------------------------------------------------------------------*/

// Full and Empty internal
assign full_s      = (dcount_rg == DEPTH) ? 1'b1 : 0                ; 
assign empty_s     = (dcount_rg == 0    ) ? 1'b1 : 0                ;

// Write and Read Enables internal
assign wren_s      = i_wren & !full_s                               ;  
assign rden_s      = i_rden & !empty_s                              ;

// Full and Empty to output
assign o_full      = full_s  || !ready_rg                           ;
assign o_empty     = empty_s                                        ;

// Almost-full and Almost-empty to output
assign o_alm_full  = ((dcount_rg > UPP_TH) ? 1'b1 : 0)              ;
assign o_alm_empty = (dcount_rg < LOW_TH) ? 1'b1 : 0                ;  

// Read-data to output
assign o_rddata    = data_rg [rdptr_rg]                             ;   


endmodule









