module IsNotEqual(sub_result, sub_cout, isNotEqual);
	input [31:0] sub_result; //subtract_result
	input sub_cout;  //subtract_cout
	output isNotEqual;
	wire bitwise_or_result, n_bitwise_or_result, isEqual;
	
	or or0 (bitwise_or_result, sub_result[0], sub_result[1], sub_result[2], sub_result[3], sub_result[4], sub_result[5], sub_result[6], sub_result[7], sub_result[8], sub_result[9], sub_result[10], sub_result[11], sub_result[12], sub_result[13], sub_result[14], sub_result[15], sub_result[16], sub_result[17], sub_result[18], sub_result[19], sub_result[20], sub_result[21], sub_result[22], sub_result[23], sub_result[24], sub_result[25], sub_result[26], sub_result[27], sub_result[28], sub_result[29], sub_result[30], sub_result[31]);
	
	not not0 (n_bitwise_or_result, bitwise_or_result);
	and and0 (isEqual, sub_cout, n_bitwise_or_result);
	not not1 (isNotEqual, isEqual);
	
endmodule
	 