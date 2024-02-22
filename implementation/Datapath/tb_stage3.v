module tb_stage3;
    // Stage3 Inputs (Stage3 doesn't exist yet so this is tentative)
    reg [0:0] CLK;
    reg [0:0] reset;
    reg [0:0] irw;
    reg [15:0] instr;
    reg [0:0] ccw; // Comp code write bit

    wire [15:0] immOut;
    wire [1:0] compcodeOut; 
    wire [3:0] opcodeOut; // Opcode gets fed to control unit

    parameter HALF_PERIOD = 50;
    parameter PLACEHOLDER_INSTRUCTION = 16'b0000001010101111;
    parameter PLACEHOLDER_IMMEDIATE = 16'b0000000000101010;
    parameter PLACEHOLDER_OPCODE = 4'b1111;

    Stage3 stage3(
        .CLK(CLK),
        .reset(reset),
        .irw(irw),
        .instr(instr),
        .ccw(ccw),
        .immOut(immOut),
        .compcodeOut(compcodeOut),
        .opcodeOut(opcodeOut)
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

        // Test Opcode and Immediate Generator
        irw = 1;
        instr = PLACEHOLDER_INSTRUCTION;
        #(2*HALF_PERIOD);
        irw = 0;
        $display("Testing Opcode Output");
        if(opcodeOut == PLACEHOLDER_OPCODE) begin
            $display("Passed");
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_OPCODE, opcodeOut);
        end

        $display("Testing Immediate Generator");
        if(immOut == PLACEHOLDER_IMMEDIATE) begin
            $display("Passed");
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_IMMEDIATE, immOut);
        end

        $display("Testing Comp Code Write");
        ccw = 1;
        #(2*HALF_PERIOD);
        if(immOut == PLACEHOLDER_IMMEDIATE) begin
            $display("Passed");
        end
        else begin
            $display("Failed. Expected %d, was %d.", PLACEHOLDER_IMMEDIATE, immOut);
        end
    end
endmodule