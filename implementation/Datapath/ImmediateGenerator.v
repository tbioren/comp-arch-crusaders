/*
Big Endian
Imm Gen needs to sign extend a 12 bit number into a 16 bit number.
*/

module ImmediateGenerator( CLK, imm_in, imm_out );
	input[11:0] imm_in;
	input CLK;
	output[15:0] imm_out;

	reg[15:0] imm_out;
	wire[11:0] imm_in;

	always @(imm_in) begin
		 imm_out[15:0] <= { {4{imm_in[11]}}, imm_in[11:0] };
	end
endmodule