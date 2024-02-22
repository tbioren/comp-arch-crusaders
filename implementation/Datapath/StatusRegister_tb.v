`timescale 1ns / 1ps

module StatusRegister_tb;

 
  reg CLK;
  reg [0:0] Reg2_in;
  reg [0:0] SRw;
  reg [0:0] isZero;
  reg [0:0] reset;


  wire [15:0] Reg2_out;

 
  StatusRegister uut (
    .CLK(CLK),
    .Reg2_in(Reg2_in),
    .SRw(SRw),
    .isZero(isZero),
    .reset(reset),
    .Reg2_out(Reg2_out)
  );


  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end

  // Less than
  initial begin
    $display("Test Case 1: Less Than");
    Reg2_in = 1;
    isZero = 0;
    SRw = 1;
    #10;
    $display("Output: %b", Reg2_out);
    if (Reg2_out === 2'b01)
      $display("Test Passed");
    else
      $display("Test Failed");
  end

  // Greater than
  initial begin
    $display("Test Case 2: Greater Than");
    Reg2_in = 0;
    isZero = 0;
    SRw = 1;
    #10;
    $display("Output: %b", Reg2_out);
    if (Reg2_out === 2'b11)
      $display("Test Passed");
    else
      $display("Test Failed");
  end

  //Equals
  initial begin
    $display("Test Case 3: Equals");
    isZero = 1;
    Reg2_in = 0;
    SRw = 1;
    #10;
    $display("Output: %b", Reg2_out);
    if (Reg2_out === 2'b10)
      $display("Test Passed");
    else
      $display("Test Failed");
  end

  // Reset
  initial begin
    $display("Test Case 4: Reset");
    Reg2_in = 0;
    isZero = 0;
    reset = 1;
    #5 reset = 0;
    #10;
    $display("Output: %b", Reg2_out);
    if (Reg2_out === 2'b00)
      $display("Test Passed");
    else
      $display("Test Failed");
  end

  
  initial #100 $finish;

endmodule
