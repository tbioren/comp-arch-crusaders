module StagedDatapath(
    input [0:0] CLK,
    input [0:0] reset,
    input wire [15:0] IN,

    output signed [15:0] reggie_out,
    output [15:0] pc_out,
    output signed [15:0] OUT,
    output [15:0] numInstructionsExecuted
    );
    
    //control outputs
    wire [1:0] IorD;
    wire [1:0] aluop;
    wire [1:0] regsrc;
    wire [1:0] pcsrc;
    wire [1:0] aluSrcA;
    wire [1:0] aluSrcB;
    wire [0:0] memw;
    wire [0:0] regw;
    wire [0:0] mdrw;
    wire [0:0] srw;
    wire [0:0] irw;
    wire [0:0] pcw;
    wire [0:0] compcodew;
    wire [0:0] outputw;
    wire [0:0] aluoutw;
    wire [0:0] isLLI;
    wire [0:0] isSLLI;
    wire [1:0] isDecode;

    //mux outputs to be input to other components 
    wire [15:0] IorD_out;
    wire [15:0] pcsrc_out;

    //output from IR to go to control, imm gen, etc
    wire [9:0] ir_address;
    wire [3:0] ir_opcode;
    wire [11:0] ir_immediate;
    wire [1:0] ir_compcode;
    
    reg [0:0] pcBranchWrite;
    reg [0:0] pcFinalWrite;

    //output from registers
    wire [15:0] ALUoutput_out;
    wire [15:0] imm_out;
    // wire [15:0] pc_out;
    wire [15:0] mdr_out;
    //output from other components
   // wire [0:0] isZero;
    wire [15:0] mem_out;
    wire [1:0] compcode_out;

    wire [0:0] isBranch;
    //
    wire [1:0] sr_out;

    parameter HALF_PERIOD = 50;
    initial begin
        pcBranchWrite = 0;
        pcFinalWrite = 0;
    end 
    //determine if branch is taken
    always@(compcode_out, ir_opcode, sr_out, pcw, isBranch)
    begin
    if(compcode_out == sr_out || compcode_out == 2'b00) begin
        if((ir_opcode == 9 || ir_opcode == 10) && isBranch == 1) begin
            pcBranchWrite = 1;
        end
        else pcBranchWrite = 0;
    end
    else pcBranchWrite = 0;
    //pcw = 1 when it shoudnt be
    if(pcBranchWrite == 1 || pcw == 1) pcFinalWrite = 1;
    else pcFinalWrite = 0;
    end 


    // Control FSM
    Control control(
        .opcode(ir_opcode),
        .CLK(CLK),
        .reset(reset),
        .compcode(compcode_out),
        .sr(sr_out),

        .IorD(IorD),
        .aluop(aluop),
        .regsrc(regsrc),
        .pcsrc(pcsrc),
        .aluSrcA(aluSrcA),
        .aluSrcB(aluSrcB),
        .regw(regw),
        .memw(memw),
        .mdrw(mdrw),
        .srw(srw),
        .irw(irw),
        .pcw(pcw),
        .compcodew(compcodew),
        .outputw(outputw),
        .aluoutw(aluoutw),
        .isLLI(isLLI),
        .isSLLI(isSLLI),
        .isDecode(isDecode),
        .isBranch(isBranch),
        .numInstructionsExecuted(numInstructionsExecuted)
    );

  

    Stage1 run_1 (
        .CLK(CLK),
        .reset(reset),
        .PCw(pcFinalWrite),
        .pcsrc(pcsrc),
        .IorD(IorD),
        .ALUoutput_out(ALUoutput_out),
        .imm_out(imm_out),
        .IorD_out(IorD_out),
        .mem_out(mem_out),
        .mdr_out(mdr_out),
        .alu_out(ALUoutput_out),
        .PCout(pc_out)
    );
    
    Stage2 run_2(
        .CLK(CLK),
        .reset(reset),
        .dataw_in(reggie_out), 
        .mdrw(mdrw),
        .memw(memw),
        .addr_in(IorD_out),
        .mem_out(mem_out),
        .mdr_out(mdr_out), 


    //for the datapath io/ mem wrapper
        .dp_input() 
        //.dp_out(OUT)
    );
    Stage3 run_3(   
        .CLK(CLK),
        .reset(reset),
        .irw(irw),
        .mem_out(mem_out),
        .ccw(compcodew), // Comp code write bit
        .ir_immediate(ir_immediate),
        .ir_compcode(ir_compcode),
        .ir_opcode(ir_opcode),
        .ir_address(ir_address),
        .compcode_out(compcode_out),
        .imm_out(imm_out)
    );
    
    Stage4 run_4(
        .CLK(CLK),
        .reset(reset),
        .INPUT(IN),
        .mdr_out(mem_out),
        .alu_out(ALUoutput_out),
        .imm_out(imm_out),
        .regsrc(regsrc),
        .regw(regw),
        .isLLI(isLLI),
        .isSLLI(isSLLI),
        .reggie_out(reggie_out),
        .temp(OUT),
        .outputw(outputw)
    );

    Stage5 run_5 (
        .CLK(CLK),
        .reset(reset),

        // ALU Source A
        .MDRout(mem_out),
        .immGenOut(imm_out),
        .CCout(compcode_out),
        .ALUsrcA(aluSrcA),
        .PCout(pc_out),
        // ALU Source B
        .reggieOut(reggie_out),
        .ALUsrcB(aluSrcB),
        
        // ALU and its output
        .ALUop(aluop),
        
        // ALU Output Register
        .ALU_in(aluoutw),

        // SR Register
        .SRw(srw),
        // Temporary Outputs
        .ALUoutputVal(ALUoutput_out),
        .SRout(sr_out),
        .isDecode(isDecode),
        .ir_address(ir_address)
    );
    
    
endmodule