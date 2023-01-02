`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/31 20:50:35
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
	input  wire [5:0] op,
	input  wire [5:0] funct,
	input  wire [4:0] rs,
	input  wire [4:0] rt,
	output wire [3:0] aluop,
	output wire [1:0] alusrc,
	output wire [1:0] hilowrite,
	output wire regwrite,
	output wire regdst,
	output wire memwrite,
	output wire memtoreg,
	output wire branch,
	output wire bal,
	output wire j,
	output wire jal,
	output wire jr,
	output wire jalr,
	output wire cp0write,
	output wire syscall,
	output wire break,
	output wire eret,
	output reg  invalidity
    );

	reg [21:0] controls;

	assign {aluop,alusrc,hilowrite,regwrite,regdst,memwrite,memtoreg,branch,bal,j,jal,jr,jalr,cp0write,syscall,break,eret} = controls;

	always @ (*)
	begin
		invalidity <= 1'b0;
		controls <= 22'b0;
		case (op)
			`R_TYPE:
			begin
				case (funct)
					// 逻辑运算
					`AND:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`OR:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`XOR:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`NOR:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};

					// 移位
					`SLL:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SRL:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SRA:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SLLV:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SRLV:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SRAV:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};

					// 算术运算
					`ADD:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`ADDU:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SUB:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SUBU:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SLT:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`SLTU:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};

					// 数据移动
					`MFHI:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`MFLO:	controls <= {`R_TYPE_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_0_0_0_0_0};
					`MTHI:	controls <= {`R_TYPE_OP, 18'b00_10_0_0_0_0_0_0_0_0_0_0_0_0_0_0};
					`MTLO:	controls <= {`R_TYPE_OP, 18'b00_01_0_0_0_0_0_0_0_0_0_0_0_0_0_0};

					// 乘除法
					`MULT:	controls <= {`R_TYPE_OP, 18'b00_11_0_0_0_0_0_0_0_0_0_0_0_0_0_0};
					`MULTU:	controls <= {`R_TYPE_OP, 18'b00_11_0_0_0_0_0_0_0_0_0_0_0_0_0_0};
					`DIV:	controls <= {`R_TYPE_OP, 18'b00_11_0_0_0_0_0_0_0_0_0_0_0_0_0_0};
					`DIVU:	controls <= {`R_TYPE_OP, 18'b00_11_0_0_0_0_0_0_0_0_0_0_0_0_0_0};

					// 跳转           
					`JR:	controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_0_0_0_0_1_0_0_0_0_0};
					`JALR:	controls <= {`USELESS_OP, 18'b00_00_1_1_0_0_0_0_0_0_0_1_0_0_0_0};

					// 自陷
					`SYSCALL: controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_0_0_0_0_0_0_0_1_0_0};
					`BREAK:	  controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_0_0_0_0_0_0_0_0_1_0};
					
					default: invalidity <= 1'b1;
				endcase
			end

			// 逻辑运算(I型)
			`ANDI:  controls <= {`ANDI_OP,	18'b10_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`XORI:	controls <= {`XORI_OP,	18'b10_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`LUI:	controls <= {`LUI_OP,	18'b10_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`ORI:	controls <= {`ORI_OP,	18'b10_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};

			// 算术运算(I型)
			`ADDI:	controls <= {`ADDI_OP, 	18'b01_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`ADDIU:	controls <= {`ADDIU_OP,	18'b01_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`SLTI:	controls <= {`SLTI_OP, 	18'b01_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
			`SLTIU: controls <= {`SLTIU_OP,	18'b01_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};

			// 分支跳转
			`BEQ: 	controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
			`BNE:	controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
			`BLEZ:	controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
			`BGTZ:	controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
			`REGIMM_INST:
			begin
				case (rt)
					`BLTZ:	 controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
					`BLTZAL: controls <= {`USELESS_OP, 18'b00_00_1_0_0_0_1_1_0_0_0_0_0_0_0_0};
					`BGEZ:	 controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_1_0_0_0_0_0_0_0_0_0};
					`BGEZAL: controls <= {`USELESS_OP, 18'b00_00_1_0_0_0_1_1_0_0_0_0_0_0_0_0};

					default: invalidity <= 1'b1;
				endcase
			end
			`J:		controls <= {`USELESS_OP, 18'b00_00_0_0_0_0_0_0_1_0_0_0_0_0_0_0};
			`JAL:	controls <= {`USELESS_OP, 18'b00_00_1_0_0_0_0_0_0_1_0_0_0_0_0_0};

			// 访存
			`LB:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LBU:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LH:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LHU:	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`LW: 	controls <= {`MEM_OP, 18'b01_00_1_0_1_1_0_0_0_0_0_0_0_0_0_0};
			`SB:	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};
			`SH:	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};
			`SW: 	controls <= {`MEM_OP, 18'b01_00_0_0_1_0_0_0_0_0_0_0_0_0_0_0};

			// 特权
			`SPECIAL3_INST:
			begin
				case (rs)
					`MFC0: controls <= {`MFC0_OP,	 18'b00_00_1_0_0_0_0_0_0_0_0_0_0_0_0_0};
					`MTC0: controls <= {`MTC0_OP,	 18'b00_00_0_0_0_0_0_0_0_0_0_0_1_0_0_0};
					`ERET: controls <= {`USELESS_OP, 18'b00_00_1_0_0_0_0_0_0_0_0_0_0_0_0_1};

					default: invalidity <= 1'b1;
				endcase
			end
			
			default: invalidity <= 1'b1;
		endcase
	end

endmodule
