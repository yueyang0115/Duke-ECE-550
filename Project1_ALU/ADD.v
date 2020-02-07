module ADD(a, b, result, cout, ovf);
	input [31:0] a, b;
	output [31:0] result;
	output cout, ovf;
	
	CLA CLA0(a, b, 1'b0, result, cout, ovf);

endmodule
