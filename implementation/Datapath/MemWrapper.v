// We are going from a 2^16 byte addr mem to a 2^10 word addr mem
//So wrapper is needed fo memory
module MemWrapper(
    input [0:0] CLK,
    input [0:0] memw,
    input [15:0] dataw_in,
    input [15:0] addr_in,
    output reg signed [15:0] mem_out,

    //for the datapath io/ mem wrapper
    input [15:0] dp_input, //data path input
    output reg signed [15:0] dp_out  //don't have to map the output
);
// wire [15:0] w2mem;
wire [15:0] ram_out;



//Sets the mux for the input addr when memw is high or low
//assign w2mem = memw ? dataw_in : addr_in;  
MemoryFile mem(
    .clk(CLK),
    .memw(memw),
    .data(dataw_in), 
    //Already shifted by starting at 1 in bus tap
    .addr(addr_in[10:1]),//decides between the addr in and dataw_in and trims the bits appropiately
    .q(ram_out)
);

always @(memw,addr_in,dp_input,ram_out,dataw_in) begin
        // Memory Read

        if(addr_in == 'h3FFE) begin //keeps it even and on word bound and serves as placeholder until meeting
            mem_out = dp_input;            
        end
        else begin
            mem_out = ram_out;
        end

        if(addr_in == 'h3FFC && memw == 1) begin//placeholder until meeting 2-12 to decide for mem map
            dp_out = dataw_in;
        end
        
end
endmodule

