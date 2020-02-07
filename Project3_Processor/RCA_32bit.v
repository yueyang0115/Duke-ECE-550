module RCA_32bit(s,a, b);
	input [31:0] a, b;
	output [31:0] s;
	wire Cout0,Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11,Cout12,Cout13,Cout14,Cout15,Cout16,Cout17,Cout18,Cout19,Cout20,Cout21,Cout22,Cout23,Cout24,Cout25,Cout26,Cout27,Cout28,Cout29,Cout30,Cout;
	
	full_adder full_adder0(a[0], b[0], 1'b0, s[0], Cout0);
	full_adder full_adder1(a[1], b[1], Cout0, s[1], Cout1);
	full_adder full_adder2(a[2], b[2], Cout1, s[2], Cout2);
	full_adder full_adder3(a[3], b[3], Cout2, s[3], Cout3);
	full_adder full_adder4(a[4], b[4], Cout3, s[4], Cout4);
	full_adder full_adder5(a[5], b[5], Cout4, s[5], Cout5);
	full_adder full_adder6(a[6], b[6], Cout5, s[6], Cout6);
	full_adder full_adder7(a[7], b[7], Cout6, s[7], Cout7);
	full_adder full_adder8(a[8], b[8], Cout7, s[8], Cout8);
	full_adder full_adder9(a[9], b[9], Cout8, s[9], Cout9);
	full_adder full_adder10(a[10], b[10], Cout9, s[10], Cout10);
	full_adder full_adder11(a[11], b[11], Cout10, s[11], Cout11);
	full_adder full_adder12(a[12], b[12], Cout11, s[12], Cout12);
	full_adder full_adder13(a[13], b[13], Cout12, s[13], Cout13);
	full_adder full_adder14(a[14], b[14], Cout13, s[14], Cout14);
	full_adder full_adder15(a[15], b[15], Cout14, s[15], Cout15);
	full_adder full_adder16(a[16], b[16], Cout15, s[16], Cout16);
	full_adder full_adder17(a[17], b[17], Cout16, s[17], Cout17);
	full_adder full_adder18(a[18], b[18], Cout17, s[18], Cout18);
	full_adder full_adder19(a[19], b[19], Cout18, s[19], Cout19);
	full_adder full_adder20(a[20], b[20], Cout19, s[20], Cout20);
	full_adder full_adder21(a[21], b[21], Cout20, s[21], Cout21);
	full_adder full_adder22(a[22], b[22], Cout21, s[22], Cout22);
	full_adder full_adder23(a[23], b[23], Cout22, s[23], Cout23);
	full_adder full_adder24(a[24], b[24], Cout23, s[24], Cout24);
	full_adder full_adder25(a[25], b[25], Cout24, s[25], Cout25);
	full_adder full_adder26(a[26], b[26], Cout25, s[26], Cout26);
	full_adder full_adder27(a[27], b[27], Cout26, s[27], Cout27);
	full_adder full_adder28(a[28], b[28], Cout27, s[28], Cout28);
	full_adder full_adder29(a[29], b[29], Cout28, s[29], Cout29);
	full_adder full_adder30(a[30], b[30], Cout29, s[30], Cout30);
	full_adder full_adder31(a[31], b[31], Cout30, s[31], Cout);
	
endmodule