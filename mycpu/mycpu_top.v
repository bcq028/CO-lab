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


module mycpu_top(
	input  wire clk,
	input  wire resetn,
	input  wire [5:0] ext_int,

	output wire inst_sram_en,
	output wire [3:0] inst_sram_wen,
	output wire [31:0] inst_sram_addr,
	output wire [31:0] inst_sram_wdata,
	input  wire [31:0] inst_sram_rdata,

	output wire data_sram_en,
	output wire [3:0] data_sram_wen,
	output wire [31:0] data_sram_addr,
	output wire [31:0] data_sram_wdata,
	input  wire [31:0] data_sram_rdata,

	output wire [31:0] debug_wb_pc,
	output wire [3:0] debug_wb_rf_wen,
	output wire [4:0] debug_wb_rf_wnum,
	output wire [31:0] debug_wb_rf_wdata
	);
	
	wire [31:0] pcF;
	wire [31:0] instrF;
	wire memwriteM;
	wire [31:0] aluoutM;
	wire [31:0] writedata2M;
	wire [31:0] readdataM;
	wire [3:0] selM;

	assign inst_sram_en = 1'b1;
	assign inst_sram_wen = 1'b0;
	assign inst_sram_wdata = 32'b0;
	assign instrF = inst_sram_rdata;

	assign data_sram_en = 1'b1;
	assign data_sram_wen = selM;
	assign data_sram_wdata = writedata2M;
	assign readdataM = data_sram_rdata;

	assign debug_wb_pc = pcW;
	assign debug_wb_rf_wen = {4{regwriteW}};
	assign debug_wb_rf_wnum = writeregW;
	assign debug_wb_rf_wdata = resultW;
	

	wire regwriteW;
	wire [31:0] pcW;
	wire [4:0] writeregW;
	wire [31:0] resultW;
	
	datapath datapath (
		.clk			(~clk			),
		.rst 			(~resetn		),
		.pcF			(pcF			),
		.aluoutM		(aluoutM		),
		.writedata2M	(writedata2M	),
		.readdataM		(readdataM		),
		.selM			(selM			),
		.regwriteW		(regwriteW		),
		.pcW			(pcW			),
		.writeregW		(writeregW		),
		.resultW		(resultW		),
	);

  /* verilator lint_off PINMISSING */

    mmu mmu( 
        .inst_vaddr(pcF),
        .inst_paddr(inst_sram_addr),
        .data_vaddr(aluoutM),
        .data_paddr(data_sram_addr)
    );

	
endmodule
