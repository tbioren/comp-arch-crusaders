// ALUsrcA, ALUsrcB, ALU, ALUoutput, and SR

module Stage5 (
    input [0:0] CLK,
    input [0:0] reset,

    // ALU Source A
    input signed [15:0] MDRout,
    input signed [15:0] immGenOut,
    input signed [1:0] CCout,
    input signed [1:0] ALUsrcA,
    input signed [9:0] ir_address,
    input wire [15:0] PCout,

    // ALU Source B
    input signed [15:0] reggieOut,
    input signed [1:0] ALUsrcB,
    
    // ALU
    input [1:0] ALUop,

    // ALU Output Register
    input [0:0] ALU_in,

    // SR Register
    input [0:0] SRw,

    input [1:0] isDecode,

    // Temporary Outputs
    output signed [15:0]  ALUoutputVal,
    output signed [1:0] SRout
    );
    wire signed [15:0] ALUoutput;
    wire [15:0] ALUsrcAout;
    wire [15:0] ALUsrcBout;
    wire [15:0] aluoutput_src;
    wire [0:0] isZero;

    // Instantiate ALUsrcA MUX
    Mux ALUsrcA_component (
        .inputA(MDRout),
        .inputB(immGenOut),
        .inputC({14'b0, CCout}), // Zero-extend CCout 
        .inputD(PCout), 
        .mux_select(ALUsrcA),
        .mux_out(ALUsrcAout)
    );

    // Instantiate ALUsrcB MUX
    Mux ALUsrcB_component (
        .inputA({14'b0, SRout}),    // Zero-extend SRout 
        .inputB(reggieOut),
        .inputC(16'b0000000000000010),
        .inputD(ALUoutput), 
        .mux_select(ALUsrcB),
        .mux_out(ALUsrcBout)
    );
    // Instantiate ALUsrcB MUX
    Mux ALUouput_src (
        .inputA(ALUoutput),    // Zero-extend SRout 
        .inputB({6'b0, ir_address}),
        .inputC(16'b0000000000000000),
        .inputD(16'b0000000000000000), 
        .mux_select(isDecode),
        .mux_out(aluoutput_src)
    );

    // Instantiate ALU
    ALU ALU_component (
        .aluA_in(ALUsrcAout),
        .aluB_in(ALUsrcBout),
        .aluop(ALUop),
        .isZero(isZero),
        .alu_out(ALUoutput)
    );

    // ALU Output Register
    Register ALUout_register (
        .CLK(CLK),
        .reset(reset),
        .reg_in(aluoutput_src),
        .reg_w(ALU_in),
        .reg_out(ALUoutputVal)
    );

    // SR Register
    StatusRegister sr (
        .CLK(CLK),
        .reset(reset),
        .negFlag(ALUoutput[15]),
        .isZero(isZero),
        .SRw(SRw),
        .srOut(SRout)
    );

endmodule