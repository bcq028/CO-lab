`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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

module alu(
	input 	wire[31:0] 	a,
	input 	wire[31:0] 	b,
	input 	wire[4:0] 	alucontrol,
	output 	reg[31:0] 	y
	// output reg overflow,
	// output wire zero
    );

	always @(*) 
	begin
		case (alucontrol)
			// 逻辑运算指令
			`AND_CONTROL: 	y <= a & b;
			`OR_CONTROL:  	y <= a | b;
			`XOR_CONTROL: 	y <= a ^ b;
			`NOR_CONTROL: 	y <= ~(a | b);
			`LUI_CONTROL: 	y <= {b[15:0], 16'b0};

			// 移位指令
			// `SLL_CONTROL: 	y <= b << sa;
			// `SRL_CONTROL: 	y <= b >> sa;
			// `SRA_CONTROL: 	y <= b >> sa | ({32{b[31]}} << (6'd32 - {1'b0,sa}));
			`SLLV_CONTROL: 	y <= b << a[4:0];
			`SRLV_CONTROL: 	y <= b >> a[4:0];
			`SRAV_CONTROL: 	y <= b >> a[4:0] | ({32{b[31]}} << (6'd32 - {1'b0,a[4:0]}));

			`ADD_CONTROL: 	y <= a + b;
			`SUB_CONTROL: 	y <= a - b;
			`SLT_CONTROL: 	y <= (a < b);
			default: 		y <= 32'b0;
		endcase
	end
	// wire[31:0] s,bout;
	// assign bout = alucontrol[2] ? ~b : b;
	// assign s = a + bout + alucontrol[2];
	// always @(*) begin
	// 	case (alucontrol[1:0])
	// 		2'b00: y <= a & bout;
	// 		2'b01: y <= a | bout;
	// 		2'b10: y <= s;
	// 		2'b11: y <= s[31];
	// 		default : y <= 32'b0;
	// 	endcase	
	// end
	// assign zero = (y == 32'b0);

	// always @(*) begin
	// 	case (alucontrol[2:1])
	// 		2'b01:overflow <= a[31] & b[31] & ~s[31] |
	// 						~a[31] & ~b[31] & s[31];
	// 		2'b11:overflow <= ~a[31] & b[31] & s[31] |
	// 						a[31] & ~b[31] & ~s[31];
	// 		default : overflow <= 1'b0;
	// 	endcase	
	// end
endmodule
