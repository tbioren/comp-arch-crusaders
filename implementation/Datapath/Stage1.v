// PC and IorD MUX
// Passes all tests

module Stage1 (
    input CLK,
    input reset,
    input [0:0] PCw,
    input [1:0] IorD,
    input [1:0] pcsrc,
    input [15:0] ALUoutput_out,
    input [15:0] imm_out,
    input [15:0] mdr_out,
    input [15:0] mem_out,
    input [15:0] alu_out,
    output [15:0] IorD_out,
    output [15:0] PCout
     
    );

    wire [15:0] pcsrc_out;
    // Instantiate PC
    Register pc(
        .reg_in(pcsrc_out),
        .reg_w(PCw),
        .reset(reset),
        .CLK(CLK),
        .reg_out(PCout)
    );

    // Instantiate pc src MUX
    Mux mux_pcsrc(
        .inputA(alu_out),
        .inputB(16'b0),
        .inputC(mdr_out),
        .inputD(16'b0), //never used in our design
        .mux_select(pcsrc),
        .mux_out(pcsrc_out)
    );

    // IorD MUX
    Mux mux_IorD(
        .inputA(PCout),
        .inputB(ALUoutput_out),
        .inputC(imm_out),
        .inputD(mem_out),
        .mux_select(IorD),
        .mux_out(IorD_out)
    );
endmodule