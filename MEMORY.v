`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,
	
	MW_ALUout,
	MW_RD
);
input clk, rst;
input [31:0] ALUout;
input [4:0] XM_RD;

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
  else
    begin
	  MW_ALUout	<=	ALUout;
	  MW_RD		<=	XM_RD;
	end
end

endmodule
