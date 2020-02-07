module key_change(dat,out_dat);
	input [7:0] dat;
	output [7:0] out_dat;
	alway@(posedge clk)
	begin
	if (dat==8'h15)
	begin
	out_dat=8'h71;
	end
	else if(dat==8'h1d)
	begin
	out_dat=8'h77;
	end
	else if(dat==8'h24)
	begin
	out_dat= 8'h65;
	end
	else if(dat==8'h2d)
	begin
	out_dat = 8'h72;
	end
enmodule
	