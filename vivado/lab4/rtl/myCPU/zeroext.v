module zeroext(
	input wire [15:0] a,
	output wire [31:0] y
    );

	assign y = {16'b0, a};

endmodule