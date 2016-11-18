`timescale 1ns/1ps

module INSTRUCTION_DECODE(
	clk,
	rst,
	IR,
	PC,
	MW_RD,
	MW_ALUout,
	
	A,
	B,
	RD,
	ALUctr
);

input clk,rst;
input [31:0]IR, PC, MW_ALUout;
input [4:0] MW_RD;

output reg [31:0] A, B;
output reg [4:0] RD;
output reg [2:0] ALUctr;

//register file
reg [31:0] REG [0:31];

//Write back
always @(posedge clk)//add new Dst REG source here
	if(MW_RD)
	  REG[MW_RD] <= MW_ALUout;
	else
	  REG[MW_RD] <= REG[MW_RD];//keep REG[0] always equal zero

//set A, and other register content(j/beq flag and address)	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
	    A 	<=32'b0;
	  end 
	else 
	  begin
	    A 	<=REG[IR[25:21]];
	  end
end

//set control signal, choose Dst REG, and set B	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
		B 		<=32'b0;
		RD 		<=5'b0;
		ALUctr 	<=3'b0;
	  end 
	else 
	  begin
	    case(IR[31:26])
		  6'd0://R-Type
		    begin
			  case(IR[5:0])//funct & setting ALUctr
			    6'd32://add
				  begin
		            B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd0;//self define ALUctr value
				  end
				6'd34://sub
				  begin
					//define sub behavior here
					ALUctr <=3'd1;//self define ALUctr value
				  end
				6'd42://slt
				  begin
					//define slt behavior here
				  end
			  endcase
			end
	      6'd35://lw
			begin
			  //define lw behavior here
			end
	      6'd43://sw
			begin
			  //define sw behavior here
			end
	      6'd4://beq
			begin
			  //define beq behavior here
			end
	      6'd2://j
			begin
			  //define j behavior here
			end
		endcase
	  end
end
endmodule
