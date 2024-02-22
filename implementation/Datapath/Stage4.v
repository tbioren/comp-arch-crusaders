module Stage4(    
input [0:0] CLK,
input [0:0] reset,
input [15:0] INPUT,
input [15:0] mdr_out,
input [15:0] alu_out,
input [15:0] imm_out,
input [1:0] regsrc,
input [0:0] regw,
input [0:0] isLLI,
input [0:0] isSLLI,
input[0:0] outputw,
output wire [15:0] FinalOut,
output [15:0] reggie_out,
output [15:0] temp
);    

wire [15:0] regsrc_out;


  Mux mux_reggiesrc(
        .inputA(mdr_out),
        .inputB(alu_out),
        .inputC(imm_out),
        .inputD(INPUT),
        .mux_select(regsrc),
        .mux_out(regsrc_out)
    );


 AccumulatorRegister Reggie(
        .CLK(CLK),
        .reset(reset),
        .reg_in(regsrc_out),
        .reg_w(regw),
        .isLLI(isLLI),
        .isSLLI(isSLLI),
         .reg_out(reggie_out)
    );

Register OutputReg(
  .reg_in(reggie_out),
        .reg_w(outputw),
        .reset(reset),
        .CLK(CLK),
        .reg_out(temp)
);

endmodule