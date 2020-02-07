//carry_lookahead adder

module CLA(x, y, cin, s, cout, ovf);
	input [31:0] x, y;
	input cin;
	output [31:0] s;
	output cout, ovf;
	wire c8, c16, c24, c7, c15, c23, c31;
	wire G0, G1, G2, G3, P0, P1, P2, P3;
	wire P0cin, P1G0, P1P0cin, P2G1, P2P1G0, P2P1P0cin, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0cin;
	
	block block0 (x[7:0], y[7:0], cin, s[7:0], G0, P0, c7);
	block block1 (x[15:8], y[15:8], c8, s[15:8], G1, P1, c15);
	block block2 (x[23:16], y[23:16], c16, s[23:16], G2, P2, c23);
	block block3 (x[31:24], y[31:24], c24, s[31:24], G3, P3, c31);
	
	//calculate c8 c16 c32
	or or0 (c8, G0, P0cin);
	or or1 (c16, G1, P1G0, P1P0cin);
	or or2 (c24, G2, P2G1, P2P1G0, P2P1P0cin);
	or or3 (cout, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0cin);
	
	and and0 (P0cin, P0, cin);
	and and1 (P1G0, P1, G0);
	and and2 (P1P0cin, P1, P0cin);
	and and3 (P2G1, P2, G1);
	and and4 (P2P1G0, P2, P1G0);
	and and5 (P2P1P0cin, P2, P1P0cin);
	and and6 (P3G2, P3, G2);
	and and7 (P3P2G1, P3, P2G1);
	and and8 (P3P2P1G0, P3, P2P1G0);
	and and9 (P3P2P1P0cin, P3, P2P1P0cin);
	
	xor xor0 (ovf, c31, cout);
	
endmodule