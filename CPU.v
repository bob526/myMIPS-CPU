`timescale 1ns/1ps

`include "INSTRUCTION_FETCH.v"
`include "INSTRUCTION_DECODE.v"
`include "EXECUTION.v"
`include "MEMORY.v"

module CPU(
	clk,
	rst
);
input clk, rst;
/*============================== Wire  ==============================*/
// INSTRUCTION_FETCH wires
wire [31:0] FD_PC, FD_IR;
// INSTRUCTION_DECODE wires
wire [31:0] A, B;
wire [4:0] DX_RD;
wire [2:0] ALUctr;
wire DX_lwFlag;
wire DX_swFlag;
wire [2:0] DX_compareFlag;
wire [31:0] DX_PC;
wire [31:0] DX_immediate;
// EXECUTION wires
wire [31:0] XM_ALUout;
wire [4:0] XM_RD;
wire XM_lwFlag;
wire XM_swFlag;
wire [2:0] XM_compareFlag;
wire [31:0] XF_ALUout;
wire [31:0] XM_immediate;
// DATA_MEMORY wires
wire [31:0] MW_ALUout;
wire [4:0]	MW_RD;
wire [2:0] MW_compareFlag;

/*============================== INSTRUCTION_FETCH  ==============================*/

INSTRUCTION_FETCH IF(
	.clk(clk),
	.rst(rst),
	.XF_ALUout(XF_ALUout),

	.PC(FD_PC),
	.IR(FD_IR)
);

/*============================== INSTRUCTION_DECODE ==============================*/

INSTRUCTION_DECODE ID(
	.clk(clk),
	.rst(rst),
	.PC(FD_PC),
	.IR(FD_IR),
	.MW_RD(MW_RD),
	.MW_ALUout(MW_ALUout),
	.MW_compareFlag(MW_compareFlag),

	.A(A),
	.B(B),
	.RD(DX_RD),
	.ALUctr(ALUctr),
	.DX_lwFlag(DX_lwFlag),
	.DX_swFlag(DX_swFlag),
	.DX_compareFlag(DX_compareFlag),
	.DX_PC(DX_PC),
	.DX_immediate(DX_immediate)
);

/*==============================     EXECUTION  	==============================*/

EXECUTION EXE(
	.clk(clk),
	.rst(rst),
	.A(A),
	.B(B),
	.DX_RD(DX_RD),
	.ALUctr(ALUctr),
	.DX_lwFlag(DX_lwFlag),
	.DX_swFlag(DX_swFlag),
	.DX_compareFlag(DX_compareFlag),
	.DX_PC(DX_PC),
	.DX_immediate(DX_immediate),


	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	.XM_lwFlag(XM_lwFlag),
	.XM_swFlag(XM_swFlag),
	.XM_compareFlag(XM_compareFlag),
	.XF_ALUout(XF_ALUout),
	.XM_immediate(XM_immediate)
);

/*==============================     DATA_MEMORY	==============================*/

MEMORY MEM(
	.clk(clk),
	.rst(rst),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	.XM_lwFlag(XM_lwFlag),
	.XM_swFlag(XM_swFlag),
	.XM_compareFlag(XM_compareFlag),
	.XM_immediate(XM_immediate),

	.MW_ALUout(MW_ALUout),
	.MW_RD(MW_RD),
	.MW_compareFlag(MW_compareFlag)
);

endmodule
