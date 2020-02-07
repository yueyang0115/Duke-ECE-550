module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
   wire [31:0] add_result, sub_result, AND_result, OR_result, SRA_result, SLL_result;
   wire add_cout, add_ovf, sub_cout, sub_ovf, sub_isNotEqual, sub_isLessThan;
   
   ADD ADD0 (data_operandA, data_operandB, add_result, add_cout, add_ovf);
	
   SUBTRACT SUBTRACT0 (data_operandA, data_operandB, sub_result, sub_cout, sub_ovf);
   IsNotEqual IsNotEqual0 (sub_result, sub_cout, sub_isNotEqual);
   IsLessThan IsLessThan0 (sub_result, sub_ovf, sub_isLessThan);
	
   Bitwise_AND Bitwise_AND0 (data_operandA, data_operandB, AND_result);
   Bitwise_OR Bitwise_OR0 (data_operandA, data_operandB, OR_result);
	
   SLL SLL0 (data_operandA, ctrl_shiftamt, SLL_result);
   SRA SRA0 (data_operandA, ctrl_shiftamt, SRA_result);
	
   assign data_result = ctrl_ALUopcode[2]? (ctrl_ALUopcode[1]? 32'h00000000:(ctrl_ALUopcode[0]? SRA_result:SLL_result)):(ctrl_ALUopcode[1]? (ctrl_ALUopcode[0]? OR_result:AND_result):(ctrl_ALUopcode[0]? sub_result:add_result) );
   assign isNotEqual = ctrl_ALUopcode[2]? 1'b0:(ctrl_ALUopcode[1]? 1'b0:(ctrl_ALUopcode[0]? sub_isNotEqual:1'b0) );
   assign isLessThan = ctrl_ALUopcode[2]? 1'b0:(ctrl_ALUopcode[1]? 1'b0:(ctrl_ALUopcode[0]? sub_isLessThan:1'b0) );
   assign overflow = ctrl_ALUopcode[2]? 1'b0:(ctrl_ALUopcode[1]? 1'b0:(ctrl_ALUopcode[0]? sub_ovf:add_ovf) );
   
endmodule
