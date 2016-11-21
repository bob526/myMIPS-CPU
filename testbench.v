`define CYCLE_TIME 66
`define INSTRUCTION_NUMBERS 66
`timescale 1ns/1ps
`include "CPU.v"

module testbench;
reg Clk, Rst;
reg [31:0] cycles, i;

// Instruction DM initialilation
initial
begin
		for (i=0; i<46; i=i+1)	cpu.IF.instruction[ i] = 32'b000000_00000_00000_00000_00000_100000;
		cpu.IF.instruction[ 0] = 32'b100011_00000_00011_00000_00000_000000;	//lw $3, $0
		cpu.IF.instruction[ 1] = 32'b100011_00001_00100_00000_00000_000000;	//lw $4, $1
		
		//Loop
		cpu.IF.instruction[ 5] = 32'b000100_00011_00100_00000_00000_100011;	//beq $3, $4, Output->(41-6=35)
		cpu.IF.instruction[ 9] = 32'b000100_00011_00000_00000_00000_001111;	//beq $3, $0(zero), swap(25-10=15)
		cpu.IF.instruction[ 13] = 32'b000100_00100_00000_00000_00000_011011;	//beq $4, $0(zero), Output(41-14=27)
		cpu.IF.instruction[ 17] = 32'b000000_00100_00011_00101_00000_101010;	//slt $5, $4, $3
		cpu.IF.instruction[ 21] = 32'b000100_00101_00001_00000_00000_001011;	//beq $5, $1, minus(33-22=11)
		//Swap
		cpu.IF.instruction[ 25] = 32'b000000_00000_00011_00101_00000_100000;	//add $5, $0, $3
		cpu.IF.instruction[ 26] = 32'b000000_00000_00100_00011_00000_100000;	//add $3, $0, $4
		cpu.IF.instruction[ 29] = 32'b000000_00000_00101_00100_00000_100000;	//add $4, $0, $5
		//Minus
		cpu.IF.instruction[ 33] = 32'b000000_00011_00100_00011_00000_100010;	//sub $3, $3, $4
		cpu.IF.instruction[ 37] = 32'b000101_00011_00100_11111_11111_011111;	//bne $3, $4, Loop(5-38=-33)
		//Output
		cpu.IF.instruction[ 41] = 32'b101011_00010_00011_00000_00000_000000;	//sw $3, $2


		cpu.IF.PC = 0;
end

// Data Memory & Register Files initialilation
initial
begin
	cpu.MEM.DM[0] = 32'd9;
	cpu.MEM.DM[1] = 32'd3;
	for (i=2; i<128; i=i+1) cpu.MEM.DM[i] = 32'b0;

	cpu.ID.REG[0] = 32'd0;
	cpu.ID.REG[1] = 32'd1;
	cpu.ID.REG[2] = 32'd2;
	for (i=3; i<32; i=i+1) cpu.ID.REG[i] = 32'b0;

end

//clock cycle time is 20ns, inverse Clk value per 10ns
initial Clk = 1'b1;
always #(`CYCLE_TIME/2) Clk = ~Clk;

//Rst signal
initial begin
	cycles = 32'b0;
	Rst = 1'b1;
	#12 Rst = 1'b0;
end

CPU cpu(
	.clk(Clk),
	.rst(Rst)
);

//display all Register value and Data memory content
always @(posedge Clk) begin
	cycles <= cycles + 1;
	if (cycles == `INSTRUCTION_NUMBERS) $finish; // Finish when excute the 24-th instruction (End label).
	$display("PC: %d cycles: %d", cpu.FD_PC>>2 , cycles);
	$display("  R00-R07: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[0], cpu.ID.REG[1], cpu.ID.REG[2], cpu.ID.REG[3],cpu.ID.REG[4], cpu.ID.REG[5], cpu.ID.REG[6], cpu.ID.REG[7]);
	$display("  R08-R15: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[8], cpu.ID.REG[9], cpu.ID.REG[10], cpu.ID.REG[11],cpu.ID.REG[12], cpu.ID.REG[13], cpu.ID.REG[14], cpu.ID.REG[15]);
	$display("  R16-R23: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[16], cpu.ID.REG[17], cpu.ID.REG[18], cpu.ID.REG[19],cpu.ID.REG[20], cpu.ID.REG[21], cpu.ID.REG[22], cpu.ID.REG[23]);
	$display("  R24-R31: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[24], cpu.ID.REG[25], cpu.ID.REG[26], cpu.ID.REG[27],cpu.ID.REG[28], cpu.ID.REG[29], cpu.ID.REG[30], cpu.ID.REG[31]);
	$display("  0x00   : %08x %08x %08x %08x %08x %08x %08x %08x", cpu.MEM.DM[0],cpu.MEM.DM[1],cpu.MEM.DM[2],cpu.MEM.DM[3],cpu.MEM.DM[4],cpu.MEM.DM[5],cpu.MEM.DM[6],cpu.MEM.DM[7]);
	$display("  0x08   : %08x %08x %08x %08x %08x %08x %08x %08x", cpu.MEM.DM[8],cpu.MEM.DM[9],cpu.MEM.DM[10],cpu.MEM.DM[11],cpu.MEM.DM[12],cpu.MEM.DM[13],cpu.MEM.DM[14],cpu.MEM.DM[15]);
end

//generate wave file, it can use gtkwave to display
initial begin
	$dumpfile("cpu_hw.vcd");
	$dumpvars;
end
endmodule
