`timescale 1 ns/1 ps

module tb_memwrapper();

	reg [15:0] din;
	reg [15:0] addr;
	reg we;
	reg CLK;

	wire [15:0] dout;


    MemWrapper memorywrapper(
		.dataw_in(din),	// input [DATA_WIDTH-1:0] data_sig
		.addr_in(addr),	// input [ADDR_WIDTH-1:0] addr_sig
		.memw(we),	// input  we_sig
		.CLK(CLK),	// input  clk_sig
		.mem_out(dout) 	// output [DATA_WIDTH-1:0] q_sig
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
		addr = 'h000;
		din = 'h1111;
		
		
		#PERIOD
		if (dout != 'h1234) begin 
			$display("FAIL: Dout = %h , Expected: 1234", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: 1234", dout);
        end
		
		
		#PERIOD; 
		//reading at addr 1 expecting 1337 in dout
		
		we = 0;
		addr = 'h001;
		din = 'h1111;
		
		#PERIOD
		if (dout != 'h1337) begin 
			$display("FAIL: Dout = %h , Expected: 1337", dout);
		end
        else begin
            $display("PASS: Dout = %h,Expected: 1337", dout);
        end
		
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
		$stop;

	end
endmodule
