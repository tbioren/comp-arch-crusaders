module Mux (
    input [15:0] inputA,
    input [15:0] inputB,
    input [15:0] inputC,
    input [15:0] inputD,
    input [1:0] mux_select,
    output reg [15:0] mux_out
);

    always @*
    begin
        case (mux_select)
            0: mux_out = inputA;
            1: mux_out = inputB;
            2: mux_out = inputC;
            3: mux_out = inputD;
            default: mux_out = 16'b0; // Handle any other cases
        endcase
    end

endmodule