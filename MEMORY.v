`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,
	XM_lwFlag,
	XM_swFlag,
	XM_compareFlag,
	XM_immediate,

	MW_ALUout,
	MW_RD,
	MW_compareFlag
);
input clk, rst;
input [31:0] ALUout, XM_immediate;
input [4:0] XM_RD;
input XM_lwFlag, XM_swFlag;
input [2:0] XM_compareFlag;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;
output reg [2:0] MW_compareFlag;

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
	  MW_compareFlag <= 3'd0;
	end
	else if (XM_lwFlag)
	begin
		MW_ALUout	<=	DM[ALUout];		//Access data
	  MW_RD		<=	XM_RD;
	  MW_compareFlag <=MW_compareFlag;
	end
	else if (XM_swFlag)
	begin
		DM[ALUout] <= XM_immediate;		//Store data to data memory.
		MW_ALUout <= ALUout;
		MW_RD <=5'b0;
		MW_compareFlag <=MW_compareFlag;
	end
	else if (XM_compareFlag>=1)
	begin
		MW_RD <=5'b0;	//Make it don't write back to reg.
		MW_ALUout <= ALUout;
		MW_compareFlag <=MW_compareFlag;
	end
  else
    begin
		MW_ALUout	<=	ALUout;
	  MW_RD		<=	XM_RD;
	  MW_compareFlag <=MW_compareFlag;
	end
end

endmodule
