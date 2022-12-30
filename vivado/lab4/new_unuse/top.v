module top(
    input clk,resetn
    );

    //mips
    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] readdata;

    //inst sram
    wire        inst_en;
    wire [3 :0] inst_wen;
    wire [31:0] inst_addr;
    wire [31:0] inst_wdata;
    wire [31:0] inst_rdata;

    //data sram
    wire        data_en;
    wire [3 :0] data_wen;
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [31:0] data_rdata;

    assign inst_en      = 1'b1;
    assign inst_wen     = 4'b0;
    assign inst_addr    = pc;
    assign inst_wdata   = 32'b0;
    assign instr        = inst_rdata;

    assign data_en      = 1'b1;
    assign data_wen     = {4{memwrite}};
    assign data_addr    = aluout;
    assign data_wdata   = writedata;
    assign readdata     = data_sram_rdata;

    mips mips
    (
        .clk            (~clk       ),
        .rst            (~resetn    ),
        .instrF         (instr      ),
        .readdataM      (readdata   ),

        .memwriteM      (memwrite   ),
        .aluoutM        (aluout     ),
        .writedataM     (writedata  ),
        
        .pcF            (pc         )
        );

    inst_ram inst_ram
    (
        .clka           (clk        ),   
        .ena            (inst_en    ),
        .wea            (inst_wen   ),
        .addra          (inst_addr  ),
        .dina           (inst_wdata ),
        .douta          (inst_rdata ) 
    );

    data_ram data_ram
    (
        .clka           (clk        ),   
        .ena            (data_en    ),
        .wea            (data_wen   ),
        .addra          (data_addr  ),
        .dina           (data_wdata ),
        .douta          (data_rdata ) 
    );

    //ascii
    instdec instdec
    (
        .instr          (instr      )
    );

endmodule