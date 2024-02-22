module ALU(       
      input [15:0] aluA_in,          //src1  
      input [15:0] aluB_in,          //src2  
      input [1:0] aluop,     
      output reg signed [15:0] alu_out,          //result       
      output reg [0:0] isZero
    );

    parameter ADD = 2'b10;
    parameter SUB = 2'b11;
    parameter SLLI = 2'b01;

    always@(aluA_in, aluB_in, aluop) begin 
        case(aluop)
            ADD: alu_out = aluA_in + aluB_in;
            SUB: alu_out = aluB_in - aluA_in;
            SLLI: alu_out = aluA_in << aluB_in;
        endcase
    end

    always@(alu_out) begin
        if(alu_out == 0) begin
            isZero = 1;
        end
        else begin
            isZero = 0;
        end
    end
endmodule