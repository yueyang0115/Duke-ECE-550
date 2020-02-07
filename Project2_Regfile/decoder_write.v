module decoder_write(out, select_bits, enable);
	input [4:0] select_bits;
	input enable;
	output [31:0] out;
	
	wire [31:0] out0, out1, out2, out3;
	wire [31:0] enable_32bits;
	assign enable_32bits = {31'b0000000000000000000000000000000, enable};
	
	assign out0 = select_bits[0] ? {enable_32bits[30:0], 1'b0} : enable_32bits;
	assign out1 = select_bits[1] ? {out0[29:0], 2'b00} : out0;
	assign out2 = select_bits[2] ? {out1[27:0], 4'h0} : out1;
	assign out3 = select_bits[3] ? {out2[23:0], 8'h00} : out2;
	assign out  = select_bits[4] ? {out3[15:0], 16'h0000} : out3;
	
endmodule