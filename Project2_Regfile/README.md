# Project Checkpoint 1
 - Author: Yue Yang
 - Course: ECE 550
 - Term: 2019 fall
 - Professor: Rabih Younes

## Design Description
I have designed and simulated a register file using Verilog. It supports 2 read ports, 1 write port and 32 registers (registers are 32-bits wide). A read port takes in data from all of the registers in the register file and outputs only the data (data_readRegA or data_readRegB) from the desired register, as designated by control bits (ctrl_readRegA, ctrl_readRegB). A write port uses similar control bits (ctrl_writeReg) to determine which register to write data (data_writeReg) to.
There are three modules in my design: registers, decoder and tristate buffer.

### Register
I use DFFE to build registers. I designe 32 registers with 32-bits wide by using a register array with size of 32 * 32. I also assign the output of Register_0 to 0 no matter what is written to it.

### Decoder
The decoder is used for writing data to the register. It takes in the 5-bit wide write control bits(ctrl_writeReg) and the 1-bit wide write enable bit(ctrl_writeEnable). Then the decoder use one-hot decoding method to turn the write control bits with 5 bits width to decoder_output with 32 bits width. Only one of the 32 bits of the decoder_output will have the value of 1, and it corresponds to the the desired register.

### Tristate buffer
The tristate bufeer is used for outputing only the data from the desired register. It takes in data from 32 registers and also takes in the 5-bit wide read control bits(ctrl_readRegA/ctrl_readRegB). Then the tristate buffer use one-hot decoding method to turn the read control bits with 5 bits width to 32-bit wide enable bits. Then it outputs only the data from the desired register, other register will be connected to a z state, which means open circuit.

Then the reg file can work. The write port works using the decoding result, it writes data to the desired register. The read ports work using the output of tristate buffer and the two ports read data from desired register seperately. 

