`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input 	wire 		clk,
	input 	wire 		rst,

	//instr
	input 	wire[31:0] 	instrF,
	output 	wire[31:0] 	pcF,
	
	//data
	input 	wire[31:0] 	readdataM,
	output 	wire 		memwriteM,
	output 	wire[31:0] 	aluoutM,
	output 	wire[31:0] 	writedataM
    );
	
	//controller 
	wire [5:0] opD,functD;
	wire regdstE,pcsrcD,memtoregE,memtoregM,memtoregW,regwriteE,regwriteM,regwriteW;
	wire [1:0] alusrcE;
	wire [4:0] alucontrolE;
	wire flushE,equalD;

	controller c(
		clk,rst,
		// 译码
		opD,functD,
		pcsrcD,branchD,equalD,jumpD,
		
		// 执行
		flushE,
		memtoregE,alusrcE,
		regdstE,regwriteE,	
		alucontrolE,

		// 访存
		memtoregM,memwriteM,
		regwriteM,

		// 写回
		memtoregW,regwriteW
		);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		jumpD,
		equalD,
		opD,functD,
		//execute stage
		memtoregE,
		alusrcE,regdstE,
		regwriteE,
		alucontrolE,
		flushE,
		//mem stage
		memtoregM,
		regwriteM,
		aluoutM,writedataM,
		readdataM,
		//writeback stage
		memtoregW,
		regwriteW
	    );
	
endmodule
