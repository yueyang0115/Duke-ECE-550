module IsLessThan(sub_result, sub_ovf, isLessThan);
	input [31:0] sub_result; 
	input sub_ovf;  
	output isLessThan;
	
	xor xor0 (isLessThan, sub_result[31], sub_ovf);
		
endmodule
	
	
