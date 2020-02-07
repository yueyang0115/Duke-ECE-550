module register_0(q, d, clk, en, clr);
	input [31:0] d;
	input clk, en, clr;
	wire clr;
  	output reg [31:0] q;
  
  	initial
     	begin
       	     q = 32'h00000000;
        end
	always @(posedge clk or posedge clr) begin
     	     if (clr) begin
                  q <= 32'h00000000;
     	     end
     	     else if (en) begin
                  q <= 32'h00000000;
     	     end
        end
endmodule
