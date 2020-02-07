module clk_imem (clk, reset, clk_out);
	output reg clk_out;
	input clk ;
	input reset;

	/*initial
	begin
		clk_out = 1'b0;
   end*/
	
	always @(negedge clk)
	begin
	if (reset)
		clk_out <= 1'b0;
	else
		clk_out <= ~clk_out;	
	end
endmodule