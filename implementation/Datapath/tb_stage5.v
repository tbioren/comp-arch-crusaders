`timescale 1ns / 1ps

module tb_stage5;
    reg [0:0] CLK;
    reg [0:0] reset;

    // ALU Source A
    reg [15:0] MDRout;
    reg [15:0] immGenOut;
    reg [15:0] CCout;
    reg [1:0] ALUsrcA;

    // ALU Source B
    reg [15:0] reggieOut;
    reg [1:0] ALUsrcB;

    // ALU
    reg [1:0] ALUop;

    // ALU Output Register
    reg [0:0] ALU_in;

    // SR Register
    reg [0:0] SRw;
    
    wire signed [15:0] ALUoutputVal;
    wire signed [1:0] SRout;

    parameter HALF_PERIOD = 50;
    parameter PLACEHOLDER_VALUE = 16'hABCD;

    Stage5 stage5(
        .CLK(CLK),
        .reset(reset),
        .MDRout(MDRout),
        .immGenOut(immGenOut),
        .CCout(CCout),
        .ALUsrcA(ALUsrcA),
        .reggieOut(reggieOut),
        .ALUsrcB(ALUsrcB),
        .ALUop(ALUop),
        .ALU_in(ALU_in),
        .SRw(SRw),
        .ALUoutputVal(ALUoutputVal),
        .SRout(SRout)
    );

    initial begin
        CLK = 0;
        forever begin
            #(HALF_PERIOD);
            CLK = ~CLK;
        end
    end

    initial begin
        // Reset
        reset = 1;
        #(2*HALF_PERIOD);
        reset = 0;
        #(2*HALF_PERIOD);

        // Test ALU Out
        // Testing Subtraction B - A
        $display("Testing Subtraction");
        MDRout = PLACEHOLDER_VALUE; // A
        reggieOut = PLACEHOLDER_VALUE;  // B
        ALUsrcA = 2'b00;
        ALUsrcB = 2'b01;
        ALUop = 2'b11;
        ALU_in = 1'b1;
        SRw = 1'b1;

        // I'm not sure how many cycles ALU takes.
        // TODO: Whoever is implementing Stage5, update the delay.
        #(2*HALF_PERIOD);
        if(ALUoutputVal == 16'h0000) begin
            $display("Passed. Expected %d, was %d.", 16'h0000, ALUoutputVal);
        end
        else begin
            $display("Failed. Expected %d, was %d.", 16'h0000, ALUoutputVal);
        end

        $display("Testing SR");
        if(SRout == 2'b10) begin
            $display("Passed.");
        end
        else begin
            $display("Failed. Expected 2, was %d.", SRout);
        end
        // TODO: Whoever is implementing Stage5, add more tests until you feel
        // confident that your module is working correctly.

        $stop;
    end
endmodule