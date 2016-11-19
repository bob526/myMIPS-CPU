`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,
	DX_lwFlag,
	DX_swFlag,
	
	ALUout,
	XM_RD,
	XM_lwFlag,
	XM_swFlag
);

input clk,rst,ALUop;
input [31:0] A,B;
input [4:0]DX_RD;
input [2:0] ALUctr;
input DX_lwFlag, DX_swFlag;

output reg [31:0]ALUout;
output reg [4:0]XM_RD;
output reg XM_lwFlag, XM_swFlag;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
		XM_lwFlag <=1'b0;
		XM_swFlag <=1'b0;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
		XM_lwFlag <= DX_lwFlag;
		XM_swFlag <= DX_swFlag;
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
					ALUout <=A-B;
				//define sub behavior here
		  end
			3'd2:	//slt
			begin
					if (A<B)
					begin
							ALUout <=32'd1;
					end
					else
					begin
							ALUout <=32'd0;
					end
			end
	  endcase
	end
end
endmodule
	
