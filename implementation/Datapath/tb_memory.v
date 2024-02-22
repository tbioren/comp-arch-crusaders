`timescale 1 ns / 1 ps

module tb_memory;

	// Inputs
    reg CLK;
    reg memR;
    reg memW;
    reg[15:0] dataW_in;
    reg[15:0] addr_in;
	
	// Outputs
	wire[15:0] mem_out;
	
	parameter HALF_PERIOD = 50;
	parameter MEM_VALUE = 16'hABCD;	// Placeholder hex value
	
	integer cycle_counter = 0;
	integer failures = 0;
	
	initial begin
		 CLK = 0;
		 forever begin
			  #(HALF_PERIOD);
			  CLK = ~CLK;
		 end
	end

    // UUT	
    Memory mem(
        .CLK(CLK),
		.memW(memW),
		.memR(memR),
		.dataW_in(dataW_in),
		.addr_in(addr_in),
		.mem_out(mem_out)
    );

    initial begin
		addr_in = 0;
		dataW_in = MEM_VALUE;
		CLK = 0;
		#(100*HALF_PERIOD);
		repeat(8193) begin
			$display("Testing Address %d", addr_in);
			memW = 1;
			memR = 0;
			#(2*HALF_PERIOD);
			memW = 0;
			memR = 1;
			#(2*HALF_PERIOD);
			if(mem_out != MEM_VALUE) begin
				$diplay("Address %d failed. Expected %d, was %d", addr_in, MEM_VALUE, mem_out);
			end
			else begin
				$display("Address %d passed. Was: %d", addr_in, mem_out);
			end
			addr_in = addr_in + 1;
		end
		$stop;
    end
	
endmodule
