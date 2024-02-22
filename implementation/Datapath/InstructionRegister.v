module InstructionRegister(
input reset,
input CLK,
input irw,
input [15:0] instr,
output reg [9:0] address,
output reg [3:0] opcode,
output reg [11:0] immediate,
//output reg [3:0] compcode
output reg [1:0] compcode

);



always@(posedge CLK)
begin
	if(reset ==0 && irw == 1) begin
	address=instr[13:4];
	opcode=instr[3:0];
	immediate=instr[15:4];
	compcode=instr[15:14];
	end
end
// Continuous assignment implies read returns NEW data. could use <=
endmodule