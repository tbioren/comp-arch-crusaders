module Control(
   input wire[3:0] opcode,
   input wire[0:0] CLK,
   input wire[0:0] reset,
   input wire[1:0] compcode,
   input wire[1:0] sr,

   output reg [1:0] IorD,
   output reg [1:0] aluop,
   output reg [1:0] regsrc,
   output reg [1:0] pcsrc,
   output reg [1:0] aluSrcA,
   output reg [1:0] aluSrcB,
   output reg [0:0] regw,
   output reg [0:0] memw,
   output reg [0:0] mdrw,
   output reg [0:0] srw,
   output reg [0:0] irw,
   output reg [0:0] pcw,
   output reg [0:0] compcodew,
   output reg [0:0] outputw,
   output reg [0:0] aluoutw,
   output reg [0:0] isLLI,
   output reg [0:0] isBranch,
   output reg [0:0] isSLLI,
   output reg [1:0] isDecode,

   output reg [15:0] numInstructionsExecuted
);
   
    //state flip flops
    reg [5:0]    current_state;
    reg [5:0]    next_state;

   // State Definitions
   parameter Fetch = 0;
   parameter Decode = 1;
 //  parameter BorBMEM1 = 2;
   parameter LI = 3;
   parameter SO = 4;
   parameter CMPi1 = 5;
   parameter ADDI = 6;
   parameter ADDorSUB1 = 7;
   parameter ADD = 8;
   parameter PreB = 9;
   parameter CMPi2 = 10;
   parameter B = 11;
   parameter BorBMEM2 = 12;
   parameter BMEM1 = 13; 
   parameter ADDorSUB2 = 14;
   parameter LLI = 15;
   parameter SLLI = 16;
   parameter LW1 = 17;
   parameter SW = 18;
   parameter ADDI2 = 19;
   parameter LW2 = 20;
   parameter SUB = 21;
   parameter LMEM1 = 22;
   parameter LMEM2 = 23;
   parameter BMEM2 = 24;
   parameter SMEM = 25;
   parameter CMP1 = 26;
   parameter Reset = 27;
   parameter Fetch2 = 28;
   parameter ADDSUB2 = 29;
  
    //register calculation
   always @ (posedge CLK)
     begin
        if (reset) begin 
          current_state = Reset;
          numInstructionsExecuted = 16'b0;
        end 
        else 
          current_state = next_state;
         
     end
    //OUTPUT signals for each state (depends on current state)
    always @ (current_state)
     begin
        //Reset all signals that cannot be don't cares
       regw = 0; 
       mdrw = 0;
       srw = 0;
       irw = 0;
       outputw = 0;
       memw = 0;
       compcodew = 0;
       pcw = 0;
       aluoutw = 0;
       isLLI = 0;
       isSLLI = 0; 
       isDecode = 0;
       regsrc = 3; //this might be a temp fix for loading input
       IorD = 0;
       isDecode = 0;
       isBranch = 0;
      case (current_state)
         Reset:
            begin
            end 
         Fetch:
            begin
               numInstructionsExecuted = numInstructionsExecuted + 1;
               pcsrc = 0;
               pcw = 0;
               aluSrcA = 3;
               aluSrcB = 2;
               aluop = 2'b10;
               
               aluoutw = 1;
               isDecode = 0;
               IorD = 0;
            end
         Fetch2:
         begin
            pcw = 1;
            pcsrc = 0;
            IorD = 0;
            irw = 1;
         end 
         
         Decode:
            begin 
               compcodew = 1;
                irw = 0;
                pcw = 0;
                aluoutw = 1;
                isDecode = 1;
            end 
         LI:
            begin
               aluoutw = 0;
               regw = 1;
               regsrc = 3;
            end
         SO:
            begin
                aluoutw = 0;
                outputw = 1;
            end 
         CMPi1:
            begin
               aluop = 2'b11;
               aluSrcA = 1;
               aluSrcB = 1;
               aluoutw =1;
               srw = 1;
            end
       
         ADDI:
            begin
               aluop = 2'b10;
               aluSrcA = 1;
               aluSrcB = 1;
               aluoutw = 1;
            end
         ADDI2:
            begin
               regsrc = 1;
               regw = 1;
            end
         SMEM:
         begin
            IorD = 3;
            mdrw = 1;
            memw = 1;
         end 
         // BorBMEM1:
         //    begin
         //       aluop = 2'b10;
         //       aluSrcA = 2;
         //       aluSrcB = 0;
         //    end
         ADDorSUB1:
            begin
                mdrw = 1;
                IorD = 2; 
            end 
         LW1:
            begin
                mdrw = 1;
                IorD = 2; 
            end 
      
         LW2:
            begin
               mdrw = 1;
                regw = 1;
                regsrc = 0; 
            end 
         SW:
            begin
                memw = 1;
                IorD = 2; 
            end 
            
         ADD:
         begin
            
            aluop = 2'b10;
               aluSrcA = 0;
               aluSrcB = 1;
               aluoutw = 1;
         end 
         ADDSUB2:
         begin
            aluoutw = 1;
            regw = 1;
            regsrc = 1;
         end 

         SUB:
         begin
               aluop = 2'b11;
               aluSrcA = 0;
               aluSrcB = 1;
               aluoutw = 1;
         end 

         
         
          BorBMEM2: 
             begin
               IorD = 1;
               mdrw = 1;
            end 
         PreB:
         begin 
            pcsrc = 0;
            isBranch = 1;
         end 
         B:
         begin 
            pcsrc = 0;
            isBranch = 1;
         end 
         BMEM1:
            begin
                mdrw = 1;
                IorD = 1;
            end 
        
        BMEM2:
            begin
               isBranch = 1;
                pcsrc = 2;
            end 

         
         LMEM1:
         begin
            IorD = 3;
            mdrw = 1;
         end 
        
         LMEM2:
         begin
           // mdrw = 1;
            regw = 1;
            regsrc = 0;
         end
         
       

         LLI:
            begin
              regw = 1;
              isLLI = 1;
              regsrc = 2;
            end
         SLLI:
            begin
              regw = 1;
              isSLLI = 1;
              regsrc = 2;
            end
         CMP1:
         begin
            aluoutw = 1;
            aluop = 2'b11;
            aluSrcA = 0;
            aluSrcB = 1;
            srw = 1;
         end 
            
        endcase 
     end
     //NEXT STATE calculation (depends on current state and opcode)       
   always @ (current_state, next_state, opcode)
     begin         
      //   $display("The current state is %d", current_state);
        
        case (current_state)
         Reset:
            begin
               next_state = Fetch;
            end
         // Prefetch:
         //    begin
         //       next_state = Fetch;
         //    end 
          Fetch:
            begin
               next_state = Fetch2;
            end
          
          Decode: 
            begin       
               // $display("The opcode is %d", opcode);
               case (opcode)
                  0:
                   begin
                      next_state = LW1;
                   end
                  1:
                   begin
                      next_state = SW;
                   end
                  2:
                   begin
                     //  load memory
                     next_state = ADDorSUB1;
                   end
                  3:
                   begin
                     // store memory
                      next_state = ADDorSUB1;
                   end
                  4:
                   begin next_state = ADDorSUB1;
                   end
                  5:
                   begin next_state = ADDorSUB1;
                   end
                   6:
                   begin next_state = ADDI;
                   end
                   7:
                   begin next_state = CMPi1;
                   end
                   8:
                   begin next_state = ADDorSUB1;
                   end
                   9:
                   begin next_state = PreB;
                   end
                   10:
                   begin next_state = BorBMEM2;
                   end
                   11:
                   begin next_state = LLI;
                   end
                   12:
                   begin next_state = SLLI; 
                   end
                  14:
                   begin next_state = LI;
                   end
                   15:
                   begin next_state = SO;
                   end

                 default:
                   begin 
                      next_state = Fetch; 
                   end
               endcase  
               
            end
            
            LW1: 
            begin
               next_state = LW2;
            end
            
           
            LMEM1:
               begin
                  next_state = LMEM2;
                  
               end 
            
            PreB:
            begin
               next_state = B;
            end
            ADDorSUB1:
               begin
                  if(opcode == 2)
                  next_state = LMEM1;
                  else if(opcode == 3)
                  next_state = SMEM;
                  else if(opcode == 4)
                  next_state = ADD;
                  else if(opcode == 5)
                  next_state = SUB;
                  else if(opcode == 8)
                  next_state = CMP1;
               end
            BorBMEM2:
              begin
                
               next_state = BMEM1;
                  // $display("In BorBMEM2, the next_state is %d", next_state);
                end 
            BMEM1:
               begin
                  next_state = BMEM2;
               end
            ADDI:
               begin
                  next_state = ADDI2;
               end
            Fetch2:
               begin
                  next_state = Decode;
               end
            ADD:
               begin
                  next_state = ADDSUB2;
               end
            SUB:
               begin
                  next_state = ADDSUB2;
               end

            
            default:
                   begin 
                     //  $display(" defaulting ", opcode);  
                      next_state = Fetch; 
                   end
            

        endcase
     end

endmodule