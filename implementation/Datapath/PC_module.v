module PC_module;

    reg [15:0] reg_in;
    reg [0:0] reg_w;
    reg [0:0] reset;
    reg [0:0] CLK;
    reg [15:0] ALU_out;
    reg [15:0] PC_out;
    reg [0:0] IorD_select;
    wire [15:0] IorD_out;

    // Instantiate PC_Register module
    register PC_Register (
        .reg_in(reg_in),
        .reg_w(reg_w),
        .reset(reset),
        .CLK(CLK),
        .reg_out(PC_out)
    );

    // Instantiate Mux_IorD module
    Mux Mux_IorD (
        .inputA(ALU_out),
        .inputB(PC_out),
        .mux_select(IorD_select),
        .mux_out(IorD_out)
    );

    
endmodule
