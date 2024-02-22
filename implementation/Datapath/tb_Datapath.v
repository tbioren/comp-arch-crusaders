`timescale 1 ns / 1 ps

module tb_Datapath;
    // Inputs
    
    // Datapath variables
    reg [0:0] CLK;
    reg [0:0] reset;
    reg [1:0] IorD;
    reg [1:0] aluop;
    reg [1:0] regsrc;
    reg [1:0] pcsrc;
    reg [1:0] aluSrcA;
    reg [1:0] aluSrcB;
    reg [0:0] memw;
    reg [0:0] regw;
    reg [0:0] mdrw;
    reg [0:0] srw;
    reg [0:0] irw;
    reg [0:0] pcw;
    reg [0:0] compcodew;
    reg [0:0] outputw;
    reg [0:0] aluoutw;
    reg [0:0] isLLI;
    reg [0:0] isSLLI;
    reg [0:0] isDecode;

    parameter HALF_PERIOD = 50;
    parameter DEFAULT_PC = 0;
    parameter TEST_VALUE = 16'h1234;

    Datapath dp(
        .CLK(CLK),
        .reset(reset),
        .IorD(IorD),
        .aluop(aluop),
        .regsrc(regsrc),
        .pcsrc(pcsrc),
        .aluSrcA(aluSrcA),
        .aluSrcB(aluSrcB),
        .memw(memw),
        .regw(regw),
        .mdrw(mdrw),
        .srw(srw),
        .irw(irw),
        .pcw(pcw),
        .compcodew(compcodew),
        .outputw(outputw),
        .aluoutw(aluoutw),
        .isLLI(isLLI),
        .isSLLI(isSLLI),
        .isDecode(isDecode)
    );

    initial begin
		 CLK = 0;
		 forever begin
			  #(HALF_PERIOD);
			  CLK = ~CLK;
		 end
	end

    initial begin
        CLK = 0;

        // 
    end
endmodule