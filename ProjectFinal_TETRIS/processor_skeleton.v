module processer_skeleton(clock, reset,flag,processor_score);
    input clock, reset;
	 input [31:0] flag;
	 output wire [31:0] processor_score;
	 //output imem_clock, dmem_clock, processor_clock, regfile_clock;
	 //output wire [31:0] r1,r2,r3,r4,r5,r6,r7,r8,r30,r31,pc_out;
	 
	 /** CLOCK **/
	 wire regfile_clock, imem_clock, dmem_clock, processor_clock;
	 
	 clk_div4 myclk1(.clk(clock), .reset(reset), .clk_out(processor_clock)); //processor_clock
	 clk_div2 myclk2(.clk(clock), .reset(reset), .clk_out(dmem_clock)); //dmem_clock
	 assign imem_clock = clock; 					//imem_clock
	 assign regfile_clock = processor_clock;  //regfile_clock
	 
	 
    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (imem_clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (dmem_clock),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        regfile_clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  flag, // input reg_flag
		  processor_score
		  //r1,r2,r3,r4,r5,r6,r7,r8,r30,r31
    );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        processor_clock,                // I: The master clock
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

endmodule