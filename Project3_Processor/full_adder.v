module full_adder(a, b, Cin, sum, Cout);
	input a, b, Cin;
	output sum, Cout;
	wire d, e, f;
	
	xor xor0(d, a, b);
	xor xor1(sum, d, Cin);
	
	and and0(e, d, Cin); 
	and and1(f, a, b);
	
	or or0(Cout, e, f);
	

endmodule