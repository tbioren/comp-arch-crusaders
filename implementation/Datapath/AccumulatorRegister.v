module AccumulatorRegister(
    input [15:0] reg_in,
    input [0:0] reg_w,
    input [0:0] isLLI,
    input [0:0] isSLLI,
    input [0:0] reset,
    input [0:0] CLK,

    output reg signed [15:0] reg_out
);

initial begin
	reg_out = 0;
end

always @ (posedge(CLK))
begin
	if (reset == 1) begin 
		reg_out = 0;
	end
    else begin
        if(reg_w==1) begin
            // $display("Reggie is writing");
            reg_out=reg_in;
            if(isLLI == 1)begin
                reg_out[11:0] = {{4{reg_in[11]}},reg_in[11:0]};
            end
            else if(isSLLI == 1) begin
                reg_out = reg_out[15:0] << reg_in[3:0];
            end
        end  
    end
end
endmodule