`timescale 1ns / 1ps

module StagedDatapath_tb;

    // Parameters
    parameter CLK_PERIOD = 30; // Clock period in ns

    // Signals
    reg CLK;
    reg reset;
    reg [15:0] IN;
    wire [15:0] reggie_out;

    // Instantiate the module under test
    StagedDatapath dut (
        .CLK(CLK),
        .reset(reset),
        .IN(IN),
        .OUT(reggie_out)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) CLK = ~CLK;

    // Initial stimulus
    initial begin
        CLK = 0;
        reset = 1;
        IN = 16'h0000; // Initial input data

        // Reset
        #(10*CLK_PERIOD);
        reset = 0;

        // Send some inputs
        IN = 16'hABCD; // Example input data
        #(10*CLK_PERIOD);  // Wait some time
        
        // Add more stimulus here as needed
         // Send some inputs
        IN = 16'hBEEF; // Example input data
        #(10*CLK_PERIOD);  // Wait some time
        
        IN = 16'hDEAD; // Example input data
        #(10*CLK_PERIOD);  // Wait some time
        $stop;

        // End simulation
        #1000;
        $finish;
    end

    // Monitor
    always @(posedge CLK) begin
        // Display output values
        // $display("reggie_out = %h", reggie_out);
    end

endmodule