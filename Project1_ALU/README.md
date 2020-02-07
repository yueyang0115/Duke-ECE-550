# Project Checkpoint 1
 - Author: Yue Yang
 - Date: 09/17/2019
 - Course: ECE 550, Duke University, Durham, NC
 - Term: 2019 fall
 - Professor Rabih Younes

## Duke Community Standard, Affirmation
I understand that each `git` commit I create in this repository is a submission. I affirm that each submission complies with the Duke Community Standard and the guidelines set forth for this assignment. I further acknowledge that any content not included in this commit under the version control system cannot be considered as a part of my submission. Finally, I understand that a submission is considered submitted when it has been pushed to the server.m

### Design Description
I design and simulate an ALU using Verilog. My ALU includes operation for addition, subtraction, bitwise AND, bitwise OR and 32-bit barrel shifter with SLL and SRA. The inputs are data_operandA, data_operandB, ctrl_ALUopcode and ctrl_shiftamt. The outputs are data_result, isNotEqual, isLessThan and overflow.

My ALU runs all the six opreations(add, sub, and...) for the inputs data_operandA, data_operandB and ctrl_shiftamt. My ALU stores the outputs of the six operation seperately(add_result, sub_result, and_result...). Then depending on the input ctrl_ALUopcode, the ALU assigns the corresponding result to the output data_result, isNotEqual, isLessThan and overflow. 

**Module ADD**
<br>I use Carry-Lookahead Adders to do addition operation. For a 32- bit adder, I use 4x 8-bit CLA blocks. The inputs of CLA are two 32-bit operands and a carry_in. The outputs are add_result, carry_out and signal_overflow. The CLA contains four blocks which work in serial. For each block, the inputs are two 8-bit operands(x,y) and a carry_in from the former block. The outputs are G, P and carry_out for the block. G and P are calculated by using generate function g and propagate function p. The value of G, P and carry are calculated as below:
g=xiyi, p=xi+yi, ci+1=gi+pici, P=p7p6p5p4p3p2p1p0, G=g7+p7g6+p7p6g5+...+p7p6p5p4p3p2p1g0 

**Module SUBTRACT**
<br>I use the 4x 8-bit CLA adder designed in Module ADD to do subtract operation. Since A-B=A+(~B)+1, I first inverse every bit of operand B, then I assign the input carry_in in CLA to 1. 

**Module Bitwise_AND**
<br>I do operand_A & operand_B in a for loop bit by bit. First I do operand_A_0 & operand_B_0, then I do operand_A_1 & operand_B_1, operand_A_2 & operand_B_2 and so on.

**Module Bitwise_OR**
<br>I do operand_A | operand_B in a for loop bit by bit. First I do operand_A_0 | operand_B_0, then I do operand_A_1 |operand_B_1, operand_A_2 | operand_B_2 and so on.

**Module SLL**
<br>Logical left-shift on operandA is done in five stages. The ALU first reads the least significant bit of ctrl_shiftamt, if ctrl_shiftamt_0 = 1, the ALU will throw away the most significant bit of operand_A, only keep operand_A(30:0) and add a 0 on the rightside of the operand_A. Else the original operand_A will be kept. In this way we got the first_stage_result. Then the ALU reads bit_one of shiftamt, if ctrl_shiftamt_1 = 1, the ALU will throw away the the first two bits of the first_stage_result, only keep first_stage_result(29:0) and add two 0's on the rightside of the first_stage_result. Else the original first_stage_result will be kept. The ALU does similar things in stage 3, 4, and 5, reads the bits of ctrl_shiftamt, throws away corresponding bits and adds corresponding zeros to the former result. Finally we got the left-shift result.

**Module SRA:**
<br>Arithmetic right-shift on operandA is done in similar 5 stages as Logical left-shift. The ALU reads the most significant bit of operand_A, if it's an 1, we add 1's after shifting. If it's a 0, we add 0s. The ALU first reads the least significant bit of ctrl_shiftamt, if ctrl_shiftamt_0 = 1, the ALU will throw away the leat significant bit of operand_A, only keep operand_A(31:1) and add a 1(or 0) on the leftside of the operand_A. Else the original operand_A will be kept. Then the ALU reads bit_one of shiftamt, if ctrl_shiftamt_1 = 1, the ALU will throw away the the last two bits of the first_stage_result, only keep first_stage_result(31:2) and add two 1's(or 0's) on the leftside of the first_stage_result. Else the original first_stage_result will be kept. The ALU does similar things in stage 3, 4, and 5, reads the bits of ctrl_shiftamt, throws away corresponding bits and adds corresponding 1's(or 0's) on the former result. Finally we got the right-shift result.

**IsNotEqual**
<br>IsNotEqual is determined by the subtract_result and the carry_out after subtraction. If the most significat bit of subtract_result is 0 and the carry_out after subtraction is 0, operand_A = oprerand_B. At this time we define signal IsEqual is 0, and we reverse signal IsEqual to get signal IsNotEqual.

**Overflow**
<br>Overflow is determined after subtraction and addition. And it's written inside the module ADD and Module SUBTRACT. If the carry_in of the last bit is not equal with the carry_out of the last bit during the addition or subtraction, we set Overflow to 1.

**IsLessThan**
<br>Overflow is determined after subtraction. If the most significant bit of subtract_result is 1 and sub_overflow is 0, operand_A < B. If the most significant bit of subtract_result is 0 and sub_overflow is 1, operand_A < B. So we let the most significant bit of subtract_result XOR sub_overflow, and we assign the result of XOR to the signal IsLessThan.
