`timescale 1 ns / 1 ps

module tb_imm;

	// Inputs
   	reg signed [11:0] imm_in;
	reg CLK;
	
	// Outputs
	wire signed [15:0] imm_out;
	
	parameter HALF_PERIOD = 50;
	
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
    ImmediateGenerator immgen(
        .imm_in(imm_in),
        .CLK(CLK),
        .imm_out(imm_out)
    );

    initial begin
        imm_in = 12'b111111111000;
        CLK = 0;
		 #(100*HALF_PERIOD);
		  repeat(32) begin
			  imm_in = imm_in + 1;

			  // TEST 1
			  $display("Testing SE with %d", imm_in);
			  #(2*HALF_PERIOD);
			  $display("%b", imm_out);
		  end
		  $stop;
    end
	
endmodule
