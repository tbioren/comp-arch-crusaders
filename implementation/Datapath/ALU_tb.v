`timescale 1ns / 1ps

module ALU_tb;
    
    // Signals
    reg [15:0] aluA_in, aluB_in;
    reg [1:0] aluop;
    wire [15:0] alu_out;
    wire isZero;
    reg [0:0] CLK;

    parameter HALF_PERIOD = 50;
    
    // Instantiate the alu module
    ALU uut (
        .aluA_in(aluA_in),
        .aluB_in(aluB_in),
        .aluop(aluop),
        .alu_out(alu_out),
        .isZero(isZero)
    );
    
    initial begin
        forever begin
            #(2*HALF_PERIOD);
            CLK = ~CLK;
        end
    end
    
    initial begin
        // Test add
        $display("Testing add");
        aluA_in = 32;
        aluB_in = 32;
        aluop = 2'b11;
        #(10*HALF_PERIOD);
        if(alu_out == 0) begin
            $display("Test passed");
        end
        else begin
            $display("Test failed. Expected 0, was %d", alu_out);
        end

        if(isZero == 1) begin
            $display("Test passed");
        end
        else begin
            $display("Test failed. Expected 1, was %d", isZero);
        end
        $stop;
    end

endmodule