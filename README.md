 A synchronous FIFO refers to a FIFO design where data values are written sequentially into a memory array using a clock signal, and the data values are sequentially read out from the memory array using the same clock signal

 # BLOCK DIAGRAM

 ![fifo_block](https://github.com/rakshitharnayak/Synchronous_FIFO/assets/73732585/c76d0161-10e7-4fda-8e47-1d8053901f46)

# ARCHITECTURE DIAGAM

![_fifo_testbench_architecture+one agent drawio](https://github.com/rakshitharnayak/Synchronous_FIFO/assets/73732585/f4a37865-ea0d-474b-8bca-6d8cabc93685)

 
//////////////////////////////////////////////////////////////////////////

 DATA_W 128           // Data width
 
 DEPTH 1024        // Depth of FIFO
 
 UPP_TH 4           // Upper threshold to generate Almost-full
 
 LOW_TH 2           //  Lower threshold to generate Almost-empty
 
//////////////////////////////////////////////////////////////////////////


Here is the [EDA link](https://www.edaplayground.com/x/Tc6H) and execute it in order to get better understanding



