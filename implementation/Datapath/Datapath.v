module Datapath(
    input [0:0] CLK,
    input [0:0] reset,
    input wire [15:0] IN,

    output wire [15:0] OUT
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
    wire [0:0] isDecode;

    //mux outputs to be input to other components 
    wire [1:0] IorD_out;
    wire [1:0] regsrc_out;
    wire [1:0] pcsrc_out;

    //output from IR to go to control, imm gen, etc
    wire [11:4] ir_address;
    wire [3:0] ir_opcode;
    wire [15:4] ir_immediate;
    wire [15:12] ir_compcode;

    //output from other components
    wire [0:0] isZero;
    wire [15:0] mem_out;
    wire [15:0] alu_out;
    wire [1:0] compcode_out;
    wire [3:0] opcode;

    parameter HALF_PERIOD = 50;

    // Control FSM
    Control control(
        .opcode(opcode),
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
        .isDecode(isDecode)
    );

    CompCode compcode(
        .CLK(CLK),
        .reset(reset),
        .reg_in(ir_compcode),
        .reg_w(compcodew),
        .reg_out(compcode_out)
    );
    InstructionRegister IR(
        .reset(reset),
        .CLK(CLK),
        .irw(irw),
        .instr(IorD_out),

        .address(ir_address),
        .opcode(ir_opcode),
        .immediate(ir_immediate),
        .compcode(ir_compcode)
    );

    // Program Counter
    Register PC(
        .CLK(CLK),
        .reset(reset),
        .reg_in(pcsrc_out),
        .reg_w(pcw)
    );

    MemoryFile mem(
        .CLK(CLK),
        .memw(memw),
        .data(imm_out),
        .addr(IorD_out),
        .q(mem_out)
    );

    Register MDR(
        .CLK(CLK),
        .reset(reset),
        .reg_in(mem_out),
        .reg_w(mdrw)
    );
    StatusRegister sr(
        .CLK(CLK),
        .Reg2_in(2'b00),
        .SRw(srw),
        .isZero(isZero),
        .reset(reset),
        .Reg2_out(sr_out)
    );
    // MUX for source of PC
    Mux mux_pcsrc(
        .inputA(ALUoutput_out),
        .inputB(imm_out),
        .inputC(mem_out),
        .inputD(0),
        .mux_select(pcsrc),
        .mux_out(pcsrc_out)
    );

    // IorD MUX
    Mux mux_IorD(
        .inputA(pc_out),
        .inputB(ALUoutput_out),
        .inputC(imm_out),
        .inputD(mdr_out),
        .mux_select(IorD),
        .mux_out(IorD_out)
    );

    // Mux to select source for Reggie
    Mux mux_reggiesrc(
        .inputA(mem_out),
        .inputB(ALUoutput_out),
        .inputC(imm_out),
        .inputD(INPUT),
        .mux_select(regsrc),
        .mux_out(regsrc_out)
    );

    // MUX to select ALU Source A
    Mux mux_alusrcA(
        .inputA(mdr_out),
        .inputB(imm_out),
        .inputC(compcode_out),
        .inputD(pc_out),
        .mux_select(aluSrcA),
        .mux_out(aluSrcA_out)
    );

    // MUX to select ALU Source B
    Mux mux_alusrcB(
        .inputA(sr_out),
        .inputB(reggie_out),
        .inputC(2),
        .inputD(0),
        .mux_select(aluSrcB),
        .mux_out(aluSrcB_out)
    );

    // Reggie
    AccumulatorRegister Reggie(
        .CLK(CLK),
        .reset(reset),
        .reg_in(regsrc_out),
        .reg_w(regw),
        .isLLI(isLLI),
        .isSLLI(isSLLI)
    );
    
    // ALU
    ALU alu(
        .aluA_in(aluSrcA_out),
        .aluB_in(aluSrcB_out),
        .aluop(opcode),
        .alu_out(alu_out),
        .isZero(isZero)
    );

    // ALU Output Register
    Register ALUoutput(
        .CLK(CLK),
        .reset(reset),
        .reg_in(aluoutsrc_out),
        .reg_w(aluoutw),
        .reg_out(ALUoutput_out)
    );

    MUX aluoutsrc(
        .inputA(alu_out),
        .inputB(ir_address),
        .inputC(0),
        .inputD(0),
        .mux_select(isDecode),
        .mux_out(aluoutsrc_out)
    );
    
endmodule