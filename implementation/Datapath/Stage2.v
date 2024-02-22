module Stage2(
    input [0:0] CLK,
    input [0:0] reset,
    input [15:0] dataw_in, 
    input [0:0] mdrw,
    input [0:0] memw,
    input [15:0] addr_in,
    output  [15:0] mem_out,
    output wire [15:0] mdr_out, 


    //for the datapath io/ mem wrapper
    input [15:0] dp_input, //data path input
    output [15:0] dp_out
);

//Instantiate MemWrapper
MemWrapper memwrapper(
    .CLK(CLK),
    .memw(memw),
    .dataw_in(dataw_in),
    .addr_in(addr_in),
    .mem_out(mem_out),
    .dp_input(dp_input), 
    .dp_out(dp_out)  
    //figure out whether or not a reset will occur 
);

//Instantiate MDR Register
Register MDR(
    .CLK(CLK),
    .reset(reset),
    .reg_in(mem_out),
    .reg_w(1),
    .reg_out(mdr_out)
);
endmodule