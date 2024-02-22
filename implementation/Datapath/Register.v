module Register(

    input [15:0] reg_in,
    input [0:0] reg_w,
    input [0:0] reset,
    input [0:0] CLK,

    output reg signed [15:0] reg_out
);

    always @ (posedge(CLK)) begin
        if (reset == 1) begin 
            reg_out = 0;
        end
        else begin
            if(reg_w == 1) begin
                    reg_out = reg_in;
            end  
        end
    end
endmodule