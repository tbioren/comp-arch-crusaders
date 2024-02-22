module Stage3(   
    input [0:0] CLK,
    input [0:0] reset,
    input [0:0] irw,
    input wire [15:0] mem_out,
    input [0:0] ccw, // Comp code write bit
    
    output wire [9:0] ir_address,
    output wire [3:0] ir_opcode,
    output wire [11:0] ir_immediate,
    output wire [1:0] ir_compcode,

    output wire [1:0] compcode_out,
    output wire [15:0] imm_out
);
    //need these for connecting ir with other components
    

    // Instantiate InstructionRegister module
    InstructionRegister IR(
        .reset(reset),
        .CLK(CLK),
        .irw(irw),
        .instr(mem_out),

        .address(ir_address),
        .opcode(ir_opcode),
        .immediate(ir_immediate),
        .compcode(ir_compcode)
    );

    // Instantiate CompCode module
    CompCode compcode(
        .CLK(CLK),
        .reset(reset),
        .reg_in(ir_compcode),
        .reg_w(ccw),
        .reg_out(compcode_out)
    );
    
    // Instantiate ImmediateGenerator module
    ImmediateGenerator immgenerator(
        .imm_in(ir_immediate),
        .CLK(CLK),
        .imm_out(imm_out)
    );
    
endmodule