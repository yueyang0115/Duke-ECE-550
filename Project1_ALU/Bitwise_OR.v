module Bitwise_OR(a, b, result);
	input [31:0] a;
	input [31:0] b;
	output [31:0] result;

	genvar i;
	generate
		for (i = 0; i < 32; i = i+1)
		begin : or_loop
			or u_or (result[i], a[i], b[i]);
		end
	endgenerate

endmodule