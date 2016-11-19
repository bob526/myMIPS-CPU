`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,
	XM_lwFlag,
	XM_swFlag,
	
	MW_ALUout,
	MW_RD
);
input clk, rst;
input [31:0] ALUout;
input [4:0] XM_RD;
input XM_lwFlag, XM_swFlag;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;

//data memory
reg [31:0] DM [0:127];
/*
//always store word to data memory
always @(posedge clk)
  if(XM_MemWrite)
    DM[ALUout[6:0]] <= XM_MD;
*/


//send to Dst REG: "load word from data memory" or  "ALUout"
always @(posedge clk)
begin
  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;
	end
	else if (XM_lwFlag)
	begin
		MW_ALUout	<=	DM[ALUout];		//Access data
	  MW_RD		<=	XM_RD;
	end
	else if (XM_swFlag)
	begin
		DM[ALUout] <= XM_RD;		//Store data to data memory.
		//Wrong, I should get the reg number RD 's value and write to DM
		MW_ALUout <= ALUout;
		MW_RD <=5'b0;
		$display("Hello?? XM_RD=%d ALUout=%d DM[ALUout]=%d\n",XM_RD,ALUout,DM[ALUout]);
	end
  else
    begin
		MW_ALUout	<=	ALUout;
	  MW_RD		<=	XM_RD;
	end
end

endmodule
