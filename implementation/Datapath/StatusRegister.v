module StatusRegister(

input CLK,
input [0:0] negFlag,
input [0:0] SRw,
input [0:0] isZero,
input [0:0] reset,
output reg [1:0] srOut
);

parameter POSITIVE = 2'b00;
parameter NEGATIVE = 2'b01;
parameter ZERO = 2'b10;

always @(posedge CLK) begin
    if(reset) begin
        srOut = 2'b00;
    end
    else if(SRw) begin
        if(isZero) begin
            srOut = ZERO;
        end
        else if(negFlag) begin
            srOut = 2'b01;
        end
        else if(!negFlag) begin
            srOut = 2'b11;
        end
    end
end

endmodule