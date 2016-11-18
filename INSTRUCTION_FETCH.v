`timescale 1ns/1ps

module INSTRUCTION_FETCH(
	clk,
	rst,
	
	PC,
	IR
);

input clk, rst;
output reg 	[31:0] PC, IR;

//instruction memory
reg [31:0] instruction [127:0];

//output instruction
always @(posedge clk or posedge rst)
begin
	if(rst)
		IR <= 32'd0;
	else
		IR <= instruction[PC[10:2]];
end

// output program counter
always @(posedge clk or posedge rst)
begin
	if(rst)
		PC <= 32'd0;
	else//add new PC address here, ex: branch, jump...
		PC <= PC+4;
end

endmodule