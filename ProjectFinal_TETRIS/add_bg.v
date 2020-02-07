module add_bg(x,y,bg,height,width,num);
input [9:0] x,y;
input [7:0] width,height;
inout [640*460-1:0] bg;
input [2:0] num;


//case(num)
	//0:
	//begin
	
		//for(i=y; i<y+height; i=i+1)
			//bg[(i-1)*640+x:(i-1)*640+x+width]=1;
			
	//end
//endcase	
	
endmodule
