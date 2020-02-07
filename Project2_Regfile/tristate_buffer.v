module tristate_buffer
(
output [31:0] buffer_out, 
input [4:0] select_bits, 
input [31:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, 
reg_out6, reg_out7, reg_out8, reg_out9, reg_out10, reg_out11, reg_out12, reg_out13,
reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20, reg_out21, 
reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, 
reg_out30, reg_out31
);

	wire [31:0] out0, out1, out2, out3;
	
	wire [31:0] select_32bits;
	assign out0 = select_bits[0] ? 32'h00000002: 32'h00000001;
	assign out1 = select_bits[1] ? {out0[29:0], 2'b00} : out0;
	assign out2 = select_bits[2] ? {out1[27:0], 4'h0} : out1;
	assign out3 = select_bits[3] ? {out2[23:0], 8'h00} : out2;
	assign select_32bits  = select_bits[4] ? {out3[15:0], 16'h0000} : out3;
	
	wire [31:0] buffer_in[31:0];
   	assign buffer_in[0] = select_32bits[0] ? reg_out0 : 1'bz;
	assign buffer_in[1] = select_32bits[1] ? reg_out1 : 1'bz;
	assign buffer_in[2] = select_32bits[2] ? reg_out2 : 1'bz;
	assign buffer_in[3] = select_32bits[3] ? reg_out3 : 1'bz;
	assign buffer_in[4] = select_32bits[4] ? reg_out4 : 1'bz;
	assign buffer_in[5] = select_32bits[5] ? reg_out5 : 1'bz;
	assign buffer_in[6] = select_32bits[6] ? reg_out6 : 1'bz;
	assign buffer_in[7] = select_32bits[7] ? reg_out7 : 1'bz;
	assign buffer_in[8] = select_32bits[8] ? reg_out8 : 1'bz;
	assign buffer_in[9] = select_32bits[9] ? reg_out9 : 1'bz;
	assign buffer_in[10] = select_32bits[10] ? reg_out10 : 1'bz;
	assign buffer_in[11] = select_32bits[11] ? reg_out11 : 1'bz;
	assign buffer_in[12] = select_32bits[12] ? reg_out12 : 1'bz;
	assign buffer_in[13] = select_32bits[13] ? reg_out13 : 1'bz;
	assign buffer_in[14] = select_32bits[14] ? reg_out14 : 1'bz;
	assign buffer_in[15] = select_32bits[15] ? reg_out15 : 1'bz;
	assign buffer_in[16] = select_32bits[16] ? reg_out16 : 1'bz;
	assign buffer_in[17] = select_32bits[17] ? reg_out17 : 1'bz;
	assign buffer_in[18] = select_32bits[18] ? reg_out18 : 1'bz;
	assign buffer_in[19] = select_32bits[19] ? reg_out19 : 1'bz;
	assign buffer_in[20] = select_32bits[20] ? reg_out20 : 1'bz;
	assign buffer_in[21] = select_32bits[21] ? reg_out21 : 1'bz;
	assign buffer_in[22] = select_32bits[22] ? reg_out22 : 1'bz;
	assign buffer_in[23] = select_32bits[23] ? reg_out23 : 1'bz;
	assign buffer_in[24] = select_32bits[24] ? reg_out24 : 1'bz;
	assign buffer_in[25] = select_32bits[25] ? reg_out25 : 1'bz;
	assign buffer_in[26] = select_32bits[26] ? reg_out26 : 1'bz;
	assign buffer_in[27] = select_32bits[27] ? reg_out27 : 1'bz;
	assign buffer_in[28] = select_32bits[28] ? reg_out28 : 1'bz;
	assign buffer_in[29] = select_32bits[29] ? reg_out29 : 1'bz;
	assign buffer_in[30] = select_32bits[30] ? reg_out30 : 1'bz;
	assign buffer_in[31] = select_32bits[31] ? reg_out31 : 1'bz;

	assign buffer_out = buffer_in[select_bits];
endmodule
