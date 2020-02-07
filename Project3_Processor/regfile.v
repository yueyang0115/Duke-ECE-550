module regfile(
	clock, ctrl_writeEnable, reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB
);
	input clock, ctrl_writeEnable, reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
	//output [31:0] r1,r2,r3,r4,r5,r6,r7,r8,r30,r31;
	reg[31:0] registers[31:0];
	
	always @(posedge clock or posedge reset)
	begin
		if(reset)
			begin
				integer i;  
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] = 32'd0;
					end 
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] = data_writeReg;
	end
	
	assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	
	/*assign r1=registers[1];
	assign r2=registers[2];
	assign r3=registers[3];
	assign r4=registers[4];
	assign r5=registers[5];
	assign r6=registers[6];
	assign r7=registers[7];
	assign r8=registers[8];
	assign r30=registers[30];
	assign r31=registers[31];
	*/
	
endmodule