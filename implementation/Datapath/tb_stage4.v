module tb_stage4;
    reg CLK;
    reg reset;
    reg regop;
    reg regw;
    reg mdrOut;
    reg memOut;

    wire reggieOut;

    parameter HALF_PERIOD = 50;
    parameter PLACEHOLDER_VALUE1 = 16'hABCD;
    parameter PLACEHOLDER_VALUE2 = 16'h1234;

    Stage4 stage4(
        .CLK(CLK),
        .reset(reset),
        .regop(regop),
        .regw(regw),
        .mdrOut(mdrOut),
        .memOut(memOut),
        .reggieOut(reggieOut)
    );
    
    initial begin
        CLK = 0;
        forever begin
            #(50);
            CLK = ~CLK;
        end
    end

    initial begin
        // Reset
        reset = 1;
        #(2*HALF_PERIOD);
        reset = 0;

        mdrOut = PLACEHOLDER_VALUE1;
        memOut = PLACEHOLDER_VALUE2;

        // Test MDR Input
        $display("Testing MDR Input");
        regop = 1;
        regw = 1;
        #(2*HALF_PERIOD);
        if(reggieOut == PLACEHOLDER_VALUE1) begin
            $display("Passed");
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE1, reggieOut);
        end

        // Test Memory Input
        $display("Testing Memory Input");
        regop = 0;
        regw = 1;
        #(2*HALF_PERIOD);
        if(reggieOut == PLACEHOLDER_VALUE2) begin
            $display("Passed");
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE2, reggieOut);
        end
    end
endmodule