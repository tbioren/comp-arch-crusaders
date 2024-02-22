module MemoryFile 
#(parameter ADDR_WIDTH=10)
(
    input [15:0] data,
    input [(ADDR_WIDTH-1):0] addr,
    input memw, 
    input clk,
    output [15:0] q
);

    // Declare the RAM variable
    reg [16-1:0] ram[0:2**ADDR_WIDTH-1];

    // Variable to hold the registered read address
    reg [ADDR_WIDTH-1:0] addr_reg;

    initial begin
        $readmemh("memory.txt",ram);
    end
    
    always @ (posedge clk)
    begin
        // Write
        if (memw)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Continuous assignment implies read returns NEW data.
    // This is the natural behavior of the TriMatrix memory
    // blocks in Single Port mode.  
    assign q = ram[addr_reg];

endmodule