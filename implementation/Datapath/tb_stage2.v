`timescale 1 ns/1 ps

module tb_stage2();

	reg [15:0] din;
	reg [15:0] addr;
    reg reset;
	reg we;
	reg CLK;
    reg [0:0] mdrw;
    reg [0:0] memw;
    wire [15:0] mdr_out;
	wire [15:0] dout;
    reg [15:0] dp_input;
    wire [15:0] dp_out;


    Stage2 stage2(
        .CLK(CLK),
        .reset(reset),
        .dataw_in(din),
        .mdrw(1),
        .memw(we),
        .addr_in(addr),
        .mem_out(dout),
        .mdr_out(mdr_out),
        .dp_input(dp_input),
        .dp_out(dp_out)
    );   
	

	parameter HALF_PERIOD = 50;
	parameter PERIOD = HALF_PERIOD*2;
	
	initial begin 
		CLK = 0;

		forever begin
			#(HALF_PERIOD);
			CLK = ~CLK;
		end
		#(100*HALF_PERIOD);
		
	end


	/*
	This code is testing the write enable bit, what's being read and
	what is being written to memory.
	*/
	initial begin
	
		//initializes the values 
		//reading the value from the addr 'h0000 we are expecting 1234 in dout
		
		we = 0;
		CLK = 0;	
		addr = 'h0000;
		din = 'h1111;
        dp_input = 'h0001;
		
		
		#PERIOD
		if (dout != 'h1234) begin 
			$display("FAIL: Dout = %h , Expected: 1234", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: 1234", dout);
        end
		#PERIOD;
        if (mdr_out != 'h1234) begin 
			$display("FAIL: mdr_out = %h , Expected: 1111", mdr_out);
		end
        else begin
            $display("PASS: mdr_out = %h, Expected: 1111", mdr_out);
        end
		#PERIOD; 
		//reading at addr 1 expecting 1337 in dout
		
		we = 1;
		addr = 'h001;
		din = 'h1111;
		
		#PERIOD
		if (dout != 'h1337) begin 
			$display("FAIL: Dout = %h , Expected: 1337", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: 1337", dout);
        end

        #PERIOD
        if (mdr_out != 'h1234) begin 
			$display("FAIL: mdr_out = %h , Expected: 1234", mdr_out);
		end
        else begin
            $display("PASS: mdr_out = %h, Expected: 1234", mdr_out);
        end
        #PERIOD
        we = 1;
        addr = 'h3FFC;
        din = 'hdead;

        #PERIOD
        if (dout != 'hdead) begin 
			$display("FAIL: Dout = %h , Expected: dead", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: dead", dout);
            
        end

        if(dp_out!='hdead) begin
            $display("FAIL:Dp_out =%h ,Expected: dead",  dp_out);
        end
        else begin
            $display("PASS: Dout = %h,Expected: dead", dp_out);
        end

        #PERIOD

        if (mdr_out != 'h1337) begin 
			$display("FAIL: mdr_out = %h , Expected: 1337", mdr_out);
		end
        else begin
            $display("PASS: mdr_out = %h, Expected: 1337", mdr_out);
        end

        #PERIOD


		
		//writing to addr 'h001 and expecting 1111 in dout
		
		we = 1;
		addr = 'h001;
		din = 'h1111;
		
		#PERIOD;
		if (dout != 'h1111) begin 
			$display("FAIL: Dout = %h , Expected: 1111", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: 1111", dout);
        end
		
        #PERIOD
        
        if (mdr_out != 'h1337) begin 
			$display("FAIL: mdr_out = %h , Expected: 1337", mdr_out);
		end
        else begin
            $display("PASS: mdr_out = %h, Expected: 1337", mdr_out);
        end

		
		//we is 0, reading at addr 'h002 and expecting dead in dout
		
		we = 0;
		addr = 'h002; //this line is not needed because the addr is 'h001
		din = 'h1111;
		
		
		#PERIOD;
		//checks to make sure that the dout is equal to 'hdead 
		if (dout != 'hdead) begin 
			$display("FAIL: Dout = %h , Expected: dead", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: dead", dout);
        end

        #PERIOD

        if (mdr_out != 'h1337) begin 
			$display("FAIL: mdr_out = %h , Expected: 1337", mdr_out);
		end
        else begin
            $display("PASS: mdr_out = %h, Expected: 1337", mdr_out);
        end

        #PERIOD
        we = 0;
        addr = 'h3FFE;
        din = 'h0000;
        #PERIOD
        if(dout!='h0001) begin
            $display("FAIL: dout = %h , Expected: 0001", dout);
        end
        else begin
            $display("PASS: dout = %h , Expected: 0001", dout);
        end
        



		$stop;

	end
endmodule