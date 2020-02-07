//module block, used in module CLA

module block(x, y, cin, s, G, P, cout_n_1);

	input [7:0] x,y;
	input cin;
	output [7:0] s;
	output G,P, cout_n_1;
	wire p7, p6, p5, p4, p3, p2, p1, p0, g7, g6, g5, g4, g3, g2, g1, g0;
	wire p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0;
	wire p0cin, p1g0, p1p0cin, p2g1, p2p1g0, p2p1p0cin, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0cin;
	wire p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0cin;
	wire p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0cin;
	wire p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0cin;
	wire c1, c2, c3, c4, c5, c6, c7, cout_n_1;
	
	//calculate g0-g7 p0-p7
	and and0 (g0, x[0], y[0]);
	and and1 (g1, x[1], y[1]);
	and and2 (g2, x[2], y[2]);
	and and3 (g3, x[3], y[3]);
	and and4 (g4, x[4], y[4]);
	and and5 (g5, x[5], y[5]);
	and and6 (g6, x[6], y[6]);
	and and7 (g7, x[7], y[7]);
	
	or or0 (p0, x[0], y[0]);
	or or1 (p1, x[1], y[1]);
	or or2 (p2, x[2], y[2]);
	or or3 (p3, x[3], y[3]);
	or or4 (p4, x[4], y[4]);
	or or5 (p5, x[5], y[5]);
	or or6 (p6, x[6], y[6]);
	or or7 (p7, x[7], y[7]);
	
	//calculate P
	and and8 (P, p7, p6, p5, p4, p3, p2, p1, p0);
	
	//calculate G
	and and9 (p7g6, p7, g6);
	and and10 (p7p6g5, p7, p6, g5);
	and and11 (p7p6p5g4, p7, p6, p5, g4);
	and and12 (p7p6p5p4g3, p7, p6, p5, p4, g3);
	and and13 (p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
	and and14 (p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
	and and15 (p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);
	
	or or8 (G, g7, p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0);
	
	//calculate s
	xor xor0 (s[0], x[0], y[0], cin);
	xor xor1 (s[1], x[1], y[1], c1);
	xor xor2 (s[2], x[2], y[2], c2);
	xor xor3 (s[3], x[3], y[3], c3);
	xor xor4 (s[4], x[4], y[4], c4);
	xor xor5 (s[5], x[5], y[5], c5);
	xor xor6 (s[6], x[6], y[6], c6);
	xor xor7 (s[7], x[7], y[7], c7);
	
	or or9 (c1, g0, p0cin);
	or or10 (c2, g1, p1g0, p1p0cin);
	or or11 (c3, g2, p2g1, p2p1g0, p2p1p0cin);
	or or12 (c4, g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0cin);
	or or13 (c5, g4, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0cin);
	or or14 (c6, g5, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0cin);
	or or15 (c7, g6, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0cin);
	assign cout_n_1 = c7;
	
	and and16 (p0cin, p0, cin);
	
	and and17 (p1g0, p1, g0);
	and and18 (p1p0cin, p1, p0cin);
	
	and and19 (p2g1, p2, g1);
	and and20 (p2p1g0, p2, p1g0);
	and and21 (p2p1p0cin, p2, p1p0cin);
	
	and and22 (p3g2, p3, g2);
	and and23 (p3p2g1, p3, p2g1);
	and and24 (p3p2p1g0, p3, p2p1g0);
	and and25 (p3p2p1p0cin, p3, p2p1p0cin);
	
	and and26 (p4g3, p4, g3);
	and and27 (p4p3g2, p4, p3g2);
	and and28 (p4p3p2g1, p4, p3p2g1);
	and and29 (p4p3p2p1g0, p4, p3p2p1g0);
	and and30 (p4p3p2p1p0cin, p4, p3p2p1p0cin);
	
	and and31 (p5g4, p5, g4);
	and and32 (p5p4g3, p5, p4g3);
	and and33 (p5p4p3g2, p5, p4p3g2);
	and and34 (p5p4p3p2g1, p5, p4p3p2g1);
	and and35 (p5p4p3p2p1g0, p5, p4p3p2p1g0);
	and and36 (p5p4p3p2p1p0cin, p5, p4p3p2p1p0cin);
	
	and and37 (p6g5, p6, g5);
	and and38 (p6p5g4, p6, p5g4);
	and and39 (p6p5p4g3, p6, p5p4g3);
	and and40 (p6p5p4p3g2, p6, p5p4p3g2);
	and and41 (p6p5p4p3p2g1, p6, p5p4p3p2g1);
	and and42 (p6p5p4p3p2p1g0, p6, p5p4p3p2p1g0);
	and and43 (p6p5p4p3p2p1p0cin, p6, p5p4p3p2p1p0cin);
	
	
endmodule
	
	
	
	