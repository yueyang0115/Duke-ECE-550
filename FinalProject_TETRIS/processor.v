module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
	 //pc_out
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 //output [31:0] pc_out;

    /* YOUR CODE STARTS HERE */
	 
	 wire [31:0] pc_out;
	 wire [31:0] pc_in, signex_N, unsignex_T, alu_dataA, alu_dataB, alu_out, regf_wrdata, pc_plus1, pc_plusN1, dmem_wrdata, mux_BR_out, mux_JP_out, ovf_wrdata;
	 wire Rtar, ALUinB, ALUop_ctrl, BR, Rwd,JP, DMwe, Rwe, is_R, isR_add, isR_sub, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx, is_ne, is_lt, is_ovf;
	 wire [16:0] N;
	 wire [26:0] T;
	 wire [4:0] opcode, ALUop, shamt, Rs, Rt, Rd;
	 wire [31:0] Instr, dmem_out, regfile_dataA, regfile_dataB;
	 wire wren, ctrl_writeEnable;
	 
	 //pc
	 pc mypc1(.clock(clock), .reset(reset), .pc_in(mux_JP_out), .pc_out(pc_out)); 
	 assign pc_plus1 = pc_out+32'd1;
	 assign pc_plusN1 = pc_plus1 + signex_N;
	 
	 //RCA_32bit myRCA1(pc_plus1,pc_out, 32'd1);
	 //RCA_32bit myRCA2(pc_plusN1,pc_plus1, signex_N);
	 assign mux_BR_out = (is_bne&is_ne|is_blt&(~is_lt)&is_ne)? pc_plusN1:pc_plus1;
	 assign mux_JP_out = is_jr?regfile_dataB: (is_bex&is_ne)? unsignex_T: (JP?unsignex_T: mux_BR_out);
	 
	 //imem
	 assign address_imem = pc_out[11:0]; 	//output_imem
	 assign Instr = q_imem;
	
	 
	 //Instr and regfile
	 assign opcode = Instr[31:27];
	 control mycontrol(opcode, Rtar, ALUinB, ALUop_ctrl, BR, Rwd, JP, DMwe, Rwe, is_R, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx);
	 assign isR_add = is_R&(~ALUop[4])&(~ALUop[3])&(~ALUop[2])&(~ALUop[1])&(~ALUop[0]); 
	 assign isR_sub = is_R&(~ALUop[4])&(~ALUop[3])&(~ALUop[2])&(~ALUop[1])&(ALUop[0]); 
	 assign ovf_wrdata= isR_add? 32'd1:isR_sub?32'd3:is_addi?32'd2:32'd0;
	 
	 assign ALUop = is_R? Instr[6:2]: ALUop_ctrl? 5'b00001:5'b00000;
	 assign shamt = is_R? Instr[11:7]: 5'b00000;
	 assign Rs = is_bex? 5'b00000: Instr[21:17];
	 assign Rt = is_bex? 5'b11110: Rtar? Instr[26:22]: Instr[16:12];
	 assign Rd = is_setx? 5'b11110: is_jal? 5'b11111:((isR_add|isR_sub|is_addi)? (is_ovf? 5'b11110: Instr[26:22]): Instr[26:22]);
	 assign N = Instr[16:0];
	 assign signex_N = {{15{N[16]}},N};
	 assign T = Instr[26:0];
	 assign unsignex_T = {5'd0,T};
	 
	 assign regf_wrdata = is_setx? unsignex_T: is_jal? pc_plus1:(is_lw? dmem_out:(isR_add|isR_sub|is_addi)?(is_ovf?ovf_wrdata:alu_out):alu_out);
	 
	 assign ctrl_readRegA = Rs; 	//output_regfile
	 assign ctrl_readRegB = Rt; 	//output_regfile
	 assign ctrl_writeReg = Rd; 	//output_regfile
	 assign data_writeReg = regf_wrdata; 	//output_regfile
	 
	 assign regfile_dataA = data_readRegA; 	//input_regfile
	 assign regfile_dataB = data_readRegB; 	//input_regfile
	 assign ctrl_writeEnable = Rwe;  			//output_regfile
	 
	 
	 //alu
	 assign alu_dataB = ALUinB? signex_N: regfile_dataB; 
	 alu myalu(.data_operandA(regfile_dataA), .data_operandB(alu_dataB), .ctrl_ALUopcode(ALUop), .ctrl_shiftamt(shamt), .data_result(alu_out), .isNotEqual(is_ne), .isLessThan(is_lt), .overflow(is_ovf));
	 
	 //dmem
	 assign address_dmem = alu_out[11:0];  //output_dmem
	 assign data = regfile_dataB;		//output_dmem
	 
	 assign dmem_out = q_dmem; //input_dmem
	 assign wren = DMwe;       //output_dmem
	 
	 
endmodule



/*module processor(clock, reset, ps2_key_pressed, ps2_out, lcd_write, lcd_data, dmem_data_in, dmem_address);

	input 			clock, reset, ps2_key_pressed;
	//input 	[7:0]	ps2_out;
	
	//output 			lcd_write;
	//output 	[31:0] 	lcd_data;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	output 	[31:0] 	dmem_data_in;
	output	[11:0]	dmem_address;
	
	
	// your processor here
	//
	
	//////////////////////////////////////
	////// THIS IS REQUIRED FOR GRADING
	// CHANGE THIS TO ASSIGN YOUR DMEM WRITE ADDRESS ALSO TO debug_addr
	assign dmem_address = (12'b000000000001);
	// CHANGE THIS TO ASSIGN YOUR DMEM DATA INPUT (TO BE WRITTEN) ALSO TO debug_data
	assign dmem_data_in = (12'b000000000001);
	////////////////////////////////////////////////////////////
	
		
	// You'll need to change where the dmem and imem read and write...
	dmem mydmem(	.address	(dmem_address),
					.clock		(clock),
					.data		(debug_data),
					.wren		(1'b1) //,	//need to fix this!
					//.q			(wherever_you_want) // change where output q goes...
	);
	
	imem myimem(	.address 	(dmem_data_in),
					.clken		(1'b1),
					.clock		(clock) //,
					//.q			(wherever_you_want) // change where output q goes...
	); 
	
endmodule
*/