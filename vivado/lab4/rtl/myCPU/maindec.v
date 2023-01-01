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

	reg [21:0] controls;
	assign jump=0;
	assign {aluop,alusrc,hilowrite,regwrite,regdst,memwrite,memtoreg,branch,bal,j,jal,jr,jalr,cp0write,syscall,break,eret} = controls;

	always @(*) begin
			controls <= 22'b0;
			case (op)
			`R_TYPE:controls <= {`ORI_OP,	18'b10_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			// 访存
			`LB:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LBU:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LH:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LHU:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LW: 	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`SB:	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};
			`SH:	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};
			`SW: 	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};		
			default: controls <= 22'b0;
		endcase
	end

endmodule
