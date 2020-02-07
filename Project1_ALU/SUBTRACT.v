module SUBTRACT(a, b, result, cout, ovf);
	input [31:0] a, b;
	output [31:0] result;
	output cout, ovf;
	wire [31:0] nb;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i+1)
		begin : not_loop
			not u_not (nb[i], b[i]);
		end
	endgenerate
	
	CLA CLA1(a, nb, 1'b1, result, cout, ovf);

endmodule