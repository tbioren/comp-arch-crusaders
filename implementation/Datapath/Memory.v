 module Memory(CLK, memW, memR, dataW_in, addr_in, mem_out);
    // Inputs
     input CLK;
     input memW;
     input memR;
     input[15:0] dataW_in;
     input[15:0] addr_in;

    // Outputs
    output[15:0] mem_out;

    // TODO: Ask Williamson if I need this
     reg[15:0] mem_out;
     wire[15:0] dataW_in;
     wire[15:0] addr_in;

    // Memory
    reg[15:0] memory[65535:0];
     always @(posedge CLK) begin
        // Memory Read
        if(memR) begin
            mem_out <= memory[addr_in << 3];
        end
        // Memory Write
        else if(memW) begin
            memory[addr_in << 3] <= dataW_in;
        end
     end
 endmodule