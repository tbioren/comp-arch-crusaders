// Testbench for PC Register and IorD MUX
// Three tests:
    // 1: Test PC Write
    // 2: Test IorD ALUoutput
    // 3: Test IorD PC

module tb_stage1;
    reg [0:0] CLK;
    reg [0:0] reset;
    reg [0:0] PCw;
    reg [15:0] ALUresult;
    reg [1:0] IorD;
    reg [15:0] ALUoutput;

    wire [15:0] PCout;
    wire [15:0] IorDout;

    parameter HALF_PERIOD = 50;
    parameter PLACEHOLDER_VALUE1 = 16'hABCD;
    parameter PLACEHOLDER_VALUE2 = 16'h1234;

    // Instantiate Stage1. Jada: Implement this module
    Stage1 stage1(
        .CLK(CLK),
        .reset(reset),
        .PCw(PCw),
        .ALUresult(ALUresult),
        .IorD(IorD),
        .ALUoutput(ALUoutput),
        .PCout(PCout),
        .IorDout(IorDout)
    );

    initial begin
        CLK = 0;
        forever begin
            #(HALF_PERIOD);
            CLK = ~CLK;
        end
    end

    initial begin
        #(100*HALF_PERIOD);
        
        // Test PC Write
        #(10*HALF_PERIOD);
        $display("Testing PC Write");
        PCw = 1;
        ALUresult = PLACEHOLDER_VALUE1;
        #(2*HALF_PERIOD);
        if(PCout == PLACEHOLDER_VALUE1) begin
            $display("Passed. Expected %d, was %d.", PLACEHOLDER_VALUE1, PCout);
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE1, PCout);
        end
        PCw = 1;
        ALUresult = PLACEHOLDER_VALUE2;
        #(2*HALF_PERIOD);
        if(PCout == PLACEHOLDER_VALUE2) begin
            $display("Passed. Expected %d, was %d.", PLACEHOLDER_VALUE2, PCout);
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE2, PCout);
        end

        // Test IorD ALUoutput
        #(10*HALF_PERIOD);
        $display("Testing IorD ALUoutput");
        // Write PLACEHOLDER_VALUE1 to PC
        PCw = 1;
        ALUresult = PLACEHOLDER_VALUE1;
        #(2*HALF_PERIOD);
        // Set up parameters
        PCw = 0;
        ALUoutput = PLACEHOLDER_VALUE2;
        IorD = 1;
        #(2*HALF_PERIOD);
        if(IorDout == PLACEHOLDER_VALUE2) begin
            $display("Passed. Expected %d, was %d.", PLACEHOLDER_VALUE2, IorDout);
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE2, IorDout);
        end

        // Test IorD PC
        #(10*HALF_PERIOD);
        $display("Testing IorD PC");
        // Write PLACEHOLDER_VALUE1 to PC
        PCw = 1;
        ALUresult = PLACEHOLDER_VALUE1;
        #(2*HALF_PERIOD);
        // Set up parameters
        PCw = 0;
        ALUoutput = PLACEHOLDER_VALUE2;
        IorD = 0;
        #(2*HALF_PERIOD);
        if(IorDout == PLACEHOLDER_VALUE1) begin
            $display("Passed. Expected %d, was %d.", PLACEHOLDER_VALUE1, IorDout);
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_VALUE1, IorDout);
        end
        $stop;
    end
endmodule