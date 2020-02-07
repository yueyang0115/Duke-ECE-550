module control(opcode, Rtar, ALUinB, ALUop_ctrl, BR, Rwd,JP, DMwe, Rwe, is_R, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx);
	
	input [4:0] opcode;
	output Rtar, ALUinB, ALUop_ctrl, BR, Rwd, JP, DMwe, Rwe, is_R, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx;
	
	wire [4:0] opcode;
	wire Rtar, ALUinB, ALUop_ctrl, BR, Rwd,JP, DMwe, Rwe,is_R, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx;
	
	assign is_R = (~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]);//00000 
	assign is_addi = (~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(opcode[0]);//00101
	assign is_sw = (~opcode[4])&(~opcode[3])&(opcode[2])&(opcode[1])&(opcode[0]);//00111
	assign is_lw = (~opcode[4])&(opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]);//01000
	assign is_j = (~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(opcode[0]);//00001
	assign is_bne = (~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(~opcode[0]);//00010
	assign is_jal = (~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//00011
	assign is_jr = (~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]);//00100
	assign is_blt = (~opcode[4])&(~opcode[3])&(opcode[2])&(opcode[1])&(~opcode[0]);//00110
	assign is_bex = (opcode[4])&(~opcode[3])&(opcode[2])&(opcode[1])&(~opcode[0]);//10110
	assign is_setx = (opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(opcode[0]);//10101
	
	assign Rtar = is_sw|is_bne|is_jr|is_blt;
	assign ALUinB = is_addi|is_sw|is_lw;
	assign ALUop_ctrl = is_bne|is_blt|is_bex;
	assign BR = is_bne|is_blt;
	assign JP = is_j|is_jal;
	assign DMwe = is_sw;
	assign Rwd = is_lw;
	assign Rwe = is_R|is_addi|is_lw|is_jal|is_setx;
	
endmodule	