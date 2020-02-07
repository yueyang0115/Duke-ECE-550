module debounce(press_w,clk_50hz,key_press);
input key_press;
output press_w;
input clk_50hz;
reg new_press;

reg counter;
always @( posedge clk_50hz or posedge key_press)
begin
	if(key_press=='d1)
	begin
		new_press ='d1;
	end
	
	else if(clk_50hz=='d1)
	begin
		if(counter == 'd1)
		begin
			counter ='d0;
			new_press = 'd0;
		end
		else if(new_press==1)
		begin
			counter = counter + 1;
		end	
	end
	
end
assign press_w = new_press;
endmodule