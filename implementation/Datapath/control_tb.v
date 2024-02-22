`timescale 1ns / 1ps

module control_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in nanoseconds
    
    // Signals
    reg [3:0] opcode;
    wire IorD, memw, regw, pcw, srw;
    wire [1:0] aluop, regop, aluSrcA, aluSrcB;
    wire compcodew;
    
    // Instantiate the control module
    Control dut (
        .opcode(opcode),
        .IorD(IorD),
        .memw(memw),
        .regw(regw),
        .pcw(pcw),
        .srw(srw),
        .aluop(aluop),
        .regop(regop),
        .aluSrcA(aluSrcA),
        .aluSrcB(aluSrcB),
        .compcodew(compcodew)
    );
    
    // Clock generation
    reg clk = 0;
    always #((CLK_PERIOD)/2) clk = ~clk;
    
    // Test stimulus
    initial begin
        // Test case 1: lw
        opcode = 4'b0000;
        #(10*CLK_PERIOD);
        
        // Test case 2: sw
        opcode = 4'b0001;
        #(10*CLK_PERIOD);
        
        // Test case 3: add
        opcode = 4'b0100;
        #(10*CLK_PERIOD);
        
        // Test case 4: sub
        opcode = 4'b0101;
        #(10*CLK_PERIOD);
        
        // Add more test cases as needed
        
        // End simulation
        $stop;
    end
    
    // Monitor
    always @(posedge clk) begin
        $display("Opcode: %b, IorD: %b, memw: %b, regw: %b, pcw: %b, srw: %b, aluop: %b, regop: %b, aluSrcA: %b, aluSrcB: %b, compcodew: %b",
                 opcode, IorD, memw, regw, pcw, srw, aluop, regop, aluSrcA, aluSrcB, compcodew);
    end

endmodule
