`timescale 1ns / 1ps

module tb_StagedDatapath2();

    // Parameters
    parameter CLK_PERIOD = 30; // Clock period in ns
    parameter clocknumber = 0;
    integer counter = 0;
    // Signals
    reg CLK;
    reg reset;
    reg [15:0] IN;
    wire signed [15:0] reggie_out;
    wire [15:0] pc_out;
    wire signed [15:0] OUT;
    wire [15:0] numInstructionsExecuted;
    // Instantiate the module under test
    StagedDatapath dut (
        .CLK(CLK),
        .reset(reset),
        .IN(IN),
        .reggie_out(reggie_out),
        .pc_out(pc_out),
	.OUT(OUT),
    .numInstructionsExecuted(numInstructionsExecuted)
    );

    // Initial clock
    initial begin
        CLK = 0;
        forever begin
	counter = counter+1;
		 #((CLK_PERIOD)/2) CLK = ~CLK; end // Toggle clock every half period
     end

    // Reset
    initial begin
        reset = 1;
        #50; // Wait for a few clock cycles
        reset = 0;
    end

    // Test cases
    initial begin
        // Test case 1: IN = 18, expected reggie_out = 5
        IN = 16'h13b0;
        wait(OUT==11);
        $display("Number of Instr is: %d", numInstructionsExecuted);
        $display("Final Answer is: %d %d", reggie_out, counter/2);
	reset = 1;
	#120
	reset = 0;
	
	
	IN = 16'h0906;
	#120;
	reset =0;
	counter = 0;
        wait(OUT==13);
       $display("Final Answer is: %d %d", reggie_out, counter/2);
	
	IN = 16'h7540;
	#120;
        reset =0;
	counter =0;
	
        wait(OUT==17);
        $display("Final Answer is: %d %d", reggie_out, counter/2);

	$stop;

     
    end

endmodule
