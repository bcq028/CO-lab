`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	output wire[5:0] opD,functD,
	//execute stage
	input wire memtoregE,
	input wire[1:0] alusrcE,
	input wire regdstE,
	input wire regwriteE,
	input wire[4:0] alucontrolE,
	output wire flushE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW
    );
	
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D,instrD;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE;
	wire [31:0] aluout2E;
	wire [5:0] opE;
	//mem stage
	wire [31:0] instrM;
	wire [31:0] pcM;
	wire [5:0] opM;
	wire [4:0] rdM;
	wire [4:0] writeregM;
	wire [1:0] hilowriteM;
	wire [31:0] hialuoutM;
	wire [31:0] loaluoutM;
	wire [31:0] writedataM;
	wire [31:0] finaldataM;
	wire [31:0] erroraddrM;
	wire laddrerrorM;
	wire saddrerrorM;
	wire isindelayslotM;
	wire [7:0] exceptionM;
	wire [31:0] exceptiontypeM;
	wire [31:0] pcexceptionM;
	wire [31:0] countout;
	wire [31:0] compareout;
	wire [31:0] statusout;
	wire [31:0] causeout;
	wire [31:0] epcout;
	wire [31:0] configout;
	wire [31:0] pridout;
	wire [31:0] badvaddrout;
	wire timerintout;
	//writeback stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;

	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		//execute stage
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,
		forwardaE,forwardbE,
		flushE,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,
		//write back stage
		writeregW,
		regwriteW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	// 取指
	pc #(32) pcreg(clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);

	// 译码
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	flopenrc #(32) r3D (clk,rst,~stallD,flushD,pcF,pcD);
	signext se(instrD[15:0],signimmD);
	zeroext ze(instrD[15:0],zeroimmD); // 实现无符号拓展
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];

	//execute stage
	floprc #(32) r1E(clk,rst,flushE,srcaD,srcaE);
	floprc #(32) r2E(clk,rst,flushE,srcbD,srcbE);
	floprc #(32) r3E(clk,rst,flushE,signimmD,signimmE);
	floprc #(5) r4E(clk,rst,flushE,rsD,rsE);
	floprc #(5) r5E(clk,rst,flushE,rtD,rtE);
	floprc #(5) r6E(clk,rst,flushE,rdD,rdE);
	floprc #(32) r7E(clk,rst,flushE,zeroimmD,zeroimmE); // 连接zeroext
	flopenrc #(32) r15E (clk,rst,~stallE,flushE,opD,opE);

	flopenrc #(32) r11E (clk,rst,~stallE,flushE,pcD,pcE);
	
	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	// 将srcbmux改成mux3
	// mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	mux3 #(32) srcbmux(srcb2E,signimmE,zeroimmE,alusrcE,srcb3E);
	alu alu(srca2E,srcb3E,alucontrolE,aluoutE);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);

	//mem stage
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
	flopr #(5) r3M(clk,rst,writeregE,writeregM);

	//writeback stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	mux2 #(32) resmux(aluoutW,readdataW,memtoregW,resultW);

	//memory visit
	floprc #(32) r1M (clk,rst,flushM,srcb2E,writedataM);
	floprc #(32) r2M (clk,rst,flushM,aluoutE,aluoutM);
	floprc #(5)  r3M (clk,rst,flushM,writereg2E,writeregM);
	floprc #(2)  r4M (clk,rst,flushM,hilowrite2E,hilowriteM);
	floprc #(64) r5M (clk,rst,flushM,{hialuout2E,loaluout2E},{hialuoutM,loaluoutM});
	floprc #(32) r6M (clk,rst,flushM,pcE,pcM);
	floprc #(32) r7M (clk,rst,flushM,opE,opM);
	floprc #(5)  r8M (clk,rst,flushM,rdE,rdM);
	floprc #(1)  r9M (clk,rst,flushM,isindelayslotE,isindelayslotM);
	floprc #(8)  r10M (clk,rst,flushM,{exceptionE[7:3],overflow,exceptionE[1:0]},exceptionM);
	floprc #(32) r11M (clk,rst,flushM,instrE,instrM);

	memsel memsel (pcM,opM,aluoutM,writedataM,readdataM,selM,writedata2M,finaldataM,erroraddrM,laddrerrorM,saddrerrorM);

endmodule
