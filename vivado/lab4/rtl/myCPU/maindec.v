`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.vh"

module maindec(
	input wire[5:0] op,

	output wire regwrite,
	output wire regdst,
	output wire [1:0] alusrc,
	output wire branch,
	output wire memwrite,
	output wire memtoreg,
	output wire jump,
	output wire[3:0] aluop
    );

	reg[11:0] controls;

	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop} = controls;

	always @(*) begin
		case (op)
			`R_TYPE:controls <= {8'b1_1_00_0_0_0_0, `R_TYPE_OP};
			
			`ANDI:  controls <= {8'b1_0_10_0_0_0_0, `ANDI_OP};
			`XORI:	controls <= {8'b1_0_10_0_0_0_0, `XORI_OP};
			`LUI:	controls <= {8'b1_0_10_0_0_0_0, `LUI_OP};
			`ORI:	controls <= {8'b1_0_10_0_0_0_0, `ORI_OP};

			`LW: 	controls <= {8'b1_0_01_0_0_1_0, `MEM_OP};
			`SW: 	controls <= {8'b0_0_01_0_1_0_0, `MEM_OP};
			`BEQ: 	controls <= {8'b0_0_00_1_0_0_0, `USELESS_OP};
			`ADDI: 	controls <= {8'b1_0_01_0_0_0_0, `ADDI_OP};
			`J: 	controls <= {8'b0_0_00_0_0_0_1, `USELESS_OP};
			default:  controls <= 12'b000000000000;//illegal op
		endcase
	end
endmodule
