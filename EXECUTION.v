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
	DX_compareFlag,
	DX_PC,

	ALUout,
	XM_RD,
	XM_lwFlag,
	XM_swFlag,
	XM_compareFlag,
	XF_ALUout
);

input clk,rst,ALUop;
input [31:0] A,B,DX_PC;
input [4:0]DX_RD;
input [2:0] ALUctr;
input DX_lwFlag, DX_swFlag;
input [2:0] DX_compareFlag;

output reg [31:0]ALUout, XF_ALUout;
output reg [4:0]XM_RD;
output reg XM_lwFlag, XM_swFlag;
output reg [2:0] XM_compareFlag;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
		XM_lwFlag <=1'b0;
		XM_swFlag <=1'b0;
		XM_compareFlag <=3'd0;
		XF_ALUout <= 32'd0;
	end
  else
	begin
	  XM_RD <= DX_RD;
		XM_lwFlag <= DX_lwFlag;
		XM_swFlag <= DX_swFlag;
		XM_compareFlag <= DX_compareFlag;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	  XF_ALUout <= 32'd0;
	end
  else
	begin
	  case(ALUctr)
	    3'd0: //add //lw //sw
		  begin
	        ALUout <=A+B;
			XF_ALUout <= 32'd0;
		  end
			3'd1: //sub
		  begin
					ALUout <=A-B;
					XF_ALUout <= 32'd0;
				//define sub behavior here
		  end
			3'd2:	//opcode about combare and jump
			begin
				$display("Do you enter here DX_compareFlag=%d?\n",DX_compareFlag);
				case(DX_compareFlag)
					3'd0:	//slt
					begin
						if (A<B)
						begin

							ALUout <=32'd1;
							XF_ALUout <= 32'd0;
						end
						else
						begin
							ALUout <=32'd0;
							XF_ALUout <= 32'd0;
						end
					end
					3'd1:	//beq
					begin
						if (A==DX_RD)
						begin
							ALUout <=(DX_PC+(B<<2));
							XF_ALUout <= (DX_PC+(B<<2));
							//Move PC forward "RD(offset)"<<2
						end
						//else do nothing
					end
					3'd2:		//j
					begin
						ALUout <= ((DX_PC & 32'hf0000000) | (B<<2));
						XF_ALUout <= ((DX_PC & 32'hf0000000) | (B<<2));
					end
				endcase
			end
	  endcase
	end
end
endmodule
