`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,
	
	ALUout,
	XM_RD
);

input clk,rst,ALUop;
input [31:0] A,B;
input [4:0]DX_RD;
input [2:0] ALUctr;

output reg [31:0]ALUout;
output reg [4:0]XM_RD;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	end 
  else 
	begin
	  case(ALUctr)
	    3'd0: //add //lw //sw
		  begin
	        ALUout <=A+B;
		  end
		3'd1: //sub
		  begin
		    //define sub behavior here
		  end
	  endcase
	end
end
endmodule
	
