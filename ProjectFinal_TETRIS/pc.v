
module pc(clock, reset, pc_in, pc_out);
	input clock, reset;
	input [31:0] pc_in;
	output [31:0] pc_out;
	reg [31:0] pc_out;
	
	initial
   begin
			pc_out=32'd0;
   end
	always @ (posedge clock or posedge reset)
	begin
		if(reset)
			pc_out<=32'd0;
		else
			pc_out<=pc_in;
	end
endmodule
