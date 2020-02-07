module vga_controller(score,
							 iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,keyin, key_press,clk_50,flag,processor_score);

	
input iRST_n;
input iVGA_CLK,key_press;
input [7:0] keyin;
input clk_50;
input [31:0] processor_score;

output reg [31:0] score;

output reg [31:0] flag;
//input wire keylc,keyrc,keyupc,keydc;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////  
reg debounce,prev;
reg [15:0] random;
wire enable;                   
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
reg [5:0] x;
reg [5:0] y;
reg [32:0] counter,counter2,counter_3;
reg clk,clk_50hz,clock_8;
wire new_press;
wire new_flag;
reg [2:0] num;
reg [1:0] rotate,rshape;
reg [7:0] width,height;
reg [9:0] background[14:0];
reg [1:0] speed;
//reg [9:0] bg[14:0];
//reg j;
reg [1:0]x1,y1,x2,y2,x3,y3,x4,y4;
//reg [3:0] bg_add[1:0];
integer i,j,k;
//wire key_outl,key_outr,key_outup,key_outd;
initial
begin
	flag <= 32'd0;
	//score<=32'd0;
   x <= 0;
	y <= 0;
	x1 <= 0;
	y1 <= 0;
   x2 <= 0;
   y2 <= 0;
	x3 <= 0;
   y3 <= 0;
	x4 <= 0;
   y4 <= 0;
	speed <= 2'd1;
	counter <= 0;
	counter2<=0;
	clk <= 0;
	num <= 0;
	width <= 0;
	height <= 0;
	rotate<=2'd0;
	rshape<=2'd0;
	random <=16'd2;
	
	for(i=0;i<15;i=i+1)
	begin
			background[i] <= 10'b0;
	end
end
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////

always@(posedge  VGA_CLK_n)
begin
	counter2<=counter2+1;
	if(counter2==2000000)
	begin
		clk_50hz=~clk_50hz;
		counter2<=0;
	end
end


//assign enable=key;
////Addresss generator
always@( posedge clk_50)
begin
	counter<=counter+1;
	if(counter==22000000)
	begin
		clk=~clk;
		counter<=0;
	end
end

always@(posedge clk_50)
begin
	counter_3<=counter_3+1;
	if(counter_3==6)
	begin
		clock_8=~clock_8;
		counter_3<=0;
	end
end

stableflag mystableflag(new_flag,clock_8,flag);

always@(posedge clk)
begin
	for(j=14;j>0;j=j-1)
	flag = 31'd0;
				begin
					if(background[j] == 10'b1111111111)
					begin
							flag = 31'd1;
							background[j] = 10'd0;
							//score <= score + 1;
							/*if(score==3)
								speed = 2;*/
							for(k=j;k>0;k=k-1)
								background[k] = background[k-1];
							flag = 31'd0;
					end
				end
	if(y+height>=15||background[y+y4+speed][x+x4]=='b1||background[y+y3+speed][x+x3]=='b1||background[y+y2+speed][x+x2]=='b1|background[y+y1+speed][x+x1]=='b1)
	begin
		background[y+y1][x+x1]='b1;
		background[y+y2][x+x2]='b1;
		background[y+y3][x+x3]='b1;
		background[y+y4][x+x4]='b1;
		y <= 0;
		//random = random +1;
		//random = ((x1*5)+(x2*6))/(y3+y4)*3+x3+x4*2;
		num = random %5;
		/*if(num==4)
		begin
			num<=0;
			//rshape<=0;
		end
		else
			num <= num+1;*/
	end
	else
	begin
		y<=y+1;	
	end
end

debounce mydebounce(new_press,clk_50hz,key_press);
always@(negedge new_press)
begin

	if(keyin==8'h75&& y+width<15 && x+height<20)//up
	begin
		random = random+1;
		if(rotate == rshape)
			rotate = 0;
		else
			rotate = rotate +1;
			
	end

	else if(keyin==8'h6b)
	begin
		random = random+1;
		if(x<1||background[y+y1][x+x1-1]=='b1||background[y+y2][x+x2-1]=='b1||background[y+y3][x+x3-1]=='b1||background[y+y4][x+x4-1]=='b1)
		begin 
			x<=x;
		end
		else
		begin
			x<=x-1;
		end
	end
	
	else if(keyin==8'h74)
	begin
		random = (random+1);
		if((x+width)*32>=320||background[y+y1][x+x1+1]=='b1||background[y+y2][x+x2+1]=='b1||background[y+y3][x+x3+1]=='b1||background[y+y4][x+x4+1]=='b1)//move right	
			x<=x;
		
		else 
			x<=x+1;
		//y<=y;
	end
	
	else
		x<=x;
end


always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end


//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;		
/*
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q (bgr_data_raw)
	);	
	
*/


task showunit;
input [31:0] score;
input [18:0] ADDR;
output [23:0] bgr_data;
reg [3:0] unit;

unit = score %10;

case(unit)
	0:
	begin
		if (((ADDR%640/10==47) && (ADDR/640/10<=16) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48) && (ADDR%640/10<=49) && (ADDR/640/10 == 10))||
		((ADDR%640/10==50) && (ADDR/640/10<17) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48) && (ADDR%640/10<50) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	1:
	begin
		if ((ADDR%640/10 == 50) && ((ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	2:
	begin
		if (((ADDR%640/10>=47) && (ADDR%640/10<51) && (ADDR/640/10==10))||
		((ADDR%640/10 == 50) && (ADDR/640/10>=11)&&(ADDR/640/10<=12))||	
		((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10 == 13))||
		((ADDR%640/10==47)  && (ADDR/640/10>=14)&&(ADDR/640/10<=15))||
		((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	3:
	begin
		if (((ADDR%640/10>=47) && (ADDR%640/10<=49) && ((ADDR/640/10==10)||
		(ADDR/640/10==13)||(ADDR/640/10==16)))||
		((ADDR%640/10 == 50) && (ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end
	4:
	begin
		if (((ADDR%640/10 == 47) && (ADDR/640/10<=13) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48) && (ADDR%640/10<=49) && (ADDR/640/10==13))||
		((ADDR%640/10 == 50) && (ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end
	5:
	begin
	if (((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10==10))||
		((ADDR%640/10 == 47) && (ADDR/640/10>=11)&&(ADDR/640/10<=12))||	
		((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10 == 13))||
		((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10 == 16))||
		((ADDR%640/10==50)  && (ADDR/640/10>=14)&&(ADDR/640/10<=15))||
		((ADDR%640/10>=47) && (ADDR%640/10<=50) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	6:
	begin
		if (((ADDR%640/10>=48) && (ADDR%640/10<=50) && (ADDR/640/10==10))||
		((ADDR%640/10 == 47) && (ADDR/640/10>=10)&&(ADDR/640/10<=16))||	
		((ADDR%640/10>=48) && (ADDR%640/10<=50) && (ADDR/640/10 == 13))||
		((ADDR%640/10>=48) && (ADDR%640/10<=50) && (ADDR/640/10 == 16))||
		((ADDR%640/10==50)  && (ADDR/640/10>=13)&&(ADDR/640/10<=15)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	7:
	begin
		if (((ADDR%640/10 == 50) && (ADDR/640/10<=16) && (ADDR/640/10>=10))||((ADDR%640/10>=47) && (ADDR%640/10<=49) && (ADDR/640/10==10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	8:
	begin
	if (((ADDR%640/10>=47) && (ADDR%640/10<48) && (ADDR/640/10<17) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48) && (ADDR%640/10<50) && (ADDR/640/10 == 10))||
		((ADDR%640/10==50) && (ADDR/640/10<17) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48) && (ADDR%640/10<50) && (ADDR/640/10 == 16))||
		((ADDR%640/10>=48) && (ADDR%640/10<=49) && (ADDR/640/10 == 13)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	9:
	begin
	if (((ADDR%640/10==47) && (ADDR/640/10<=13) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48) && (ADDR%640/10<=49) && (ADDR/640/10 == 10))||
		((ADDR%640/10 == 50) && (ADDR/640/10<=16) && (ADDR/640/10>=10))||
		((ADDR%640/10>=47) && (ADDR%640/10<50) && (ADDR/640/10 == 16))||
		((ADDR%640/10>=48) && (ADDR%640/10<=49) && (ADDR/640/10 == 13)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end	
endcase	
endtask


task showstens;
input [31:0] score;
input [18:0] ADDR;
output [23:0] bgr_data;
reg [3:0] tens;

tens = score /10;

case(tens)
	0:
	begin
		if (((ADDR%640/10==47-5) && (ADDR/640/10<=16) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48-5) && (ADDR%640/10<=49-5) && (ADDR/640/10 == 10))||
		((ADDR%640/10==50-5) && (ADDR/640/10<17) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<50-5) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	1:
	begin
		if ((ADDR%640/10 == 50-5) && ((ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	2:
	begin
		if (((ADDR%640/10>=47-5) && (ADDR%640/10<51-5) && (ADDR/640/10==10))||
		((ADDR%640/10 == 50-5) && (ADDR/640/10>=11)&&(ADDR/640/10<=12))||	
		((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 13))||
		((ADDR%640/10==47-5)  && (ADDR/640/10>=14)&&(ADDR/640/10<=15))||
		((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	3:
	begin
		if (((ADDR%640/10>=47-5) && (ADDR%640/10<=49-5) && ((ADDR/640/10==10)||
		(ADDR/640/10==13)||(ADDR/640/10==16)))||
		((ADDR%640/10 == 50-5) && (ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end
	4:
	begin
		if (((ADDR%640 == 47-5) && (ADDR/640/10<=13) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<=49-5) && (ADDR/640/10==13))||
		((ADDR%640/10 == 50-5) && (ADDR/640/10<=16) && (ADDR/640/10>=10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end
	5:
	begin
	if (((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10==10))||
		((ADDR%640/10 == 47-5) && (ADDR/640/10>=11)&&(ADDR/640/10<=12))||	
		((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 13))||
		((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 16))||
		((ADDR%640/10==50-5)  && (ADDR/640/10>=14)&&(ADDR/640/10<=15))||
		((ADDR%640/10>=47-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 16)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	6:
	begin
		if (((ADDR%640/10>=48-5) && (ADDR%640/10<=50-5) && (ADDR/640/10==10))||
		((ADDR%640/10 == 47-5) && (ADDR/640/10>=10)&&(ADDR/640/10<=16))||	
		((ADDR%640/10>=48-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 13))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<=50-5) && (ADDR/640/10 == 16))||
		((ADDR%640/10==50-5)  && (ADDR/640/10>=13)&&(ADDR/640/10<=15)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	7:
	begin
		if (((ADDR%640/10 == 50-5) && (ADDR/640/10<=16) && (ADDR/640/10>=10))||((ADDR%640/10>=47-5) && (ADDR%640/10<=49-5) && (ADDR/640/10==10)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	8:
	begin
	if (((ADDR%640/10>=47-5) && (ADDR%640/10<48-5) && (ADDR/640/10<17) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48-5) && (ADDR%640/10<50-5) && (ADDR/640/10 == 10))||
		((ADDR%640/10==50-5) && (ADDR/640/10<17) && (ADDR/640/10>=10))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<50-5) && (ADDR/640/10 == 16))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<=49-5) && (ADDR/640/10 == 13)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end	
	end
	9:
	begin
	if (((ADDR%640/10==47-5) && (ADDR/640/10<=13) && (ADDR/640/10>=10))|| 
		((ADDR%640/10>=48-5) && (ADDR%640/10<=49-5) && (ADDR/640/10 == 10))||
		((ADDR%640/10 == 50-5) && (ADDR/640/10<=16) && (ADDR/640/10>=10))||
		((ADDR%640/10>=47-5) && (ADDR%640/10<50-5) && (ADDR/640/10 == 16))||
		((ADDR%640/10>=48-5) && (ADDR%640/10<=49-5) && (ADDR/640/10 == 13)))
		begin 
			bgr_data <= 24'h000000;
		end
		else
		begin
			bgr_data <= 24'b011000001111001111100000;
		end
	end
endcase
endtask

//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) 
begin
//if(num==0&&(rotate==0||rotate==1||rotate==2||rotate==3))begin
	score = processor_score;
case(num)
	0://original square*/
	begin
		if((ADDR%640>x*32)&&((ADDR%640)<32*(x+2))&&((ADDR/640)+1<=32*(y+2))&&((ADDR/640+1)>32*y))//pattern 3
			begin 
				bgr_data <= 24'b000000001111111111111111;
				x1 <= 0; y1 <= 0;
				x2 <= 0; y2 <= 1;
				x3 <= 1; y3 <= 0;
				x4 <= 1; y4 <= 1;
				height <= 2;
				width <= 2;
				rshape <= 0;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	/*****************************/
	//if(num==1&&rotate==0)begin
	1:
	begin
	case (rotate)
	0:
	if (((ADDR%640>x*32) && (ADDR%640<(x+1)*32) && (ADDR/640+1<(y+3)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>=(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>(y+2)*32) && (ADDR/640+1<(y+3)*32)))
			begin 
				bgr_data <= 24'b000011111111111100000000; //pattren 2
				x1<=0;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 0; y3<=2;
				x4<=1; y4<=2;
				height <= 3;
				width <= 2;
				rshape <=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
	else 
		begin
			bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
		end

	//if(num==1&&rotate==1)begin
	1: 
	if (((ADDR%640>x*32) && (ADDR%640<(x+3)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>=x*32) && (ADDR%640<(x+1)*32) && (ADDR/640+1>y*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b000011111111111100000000; //pattren 2
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 2; y3<=0;
				x4<=0; y4<=1;
				height <= 2;
				width <= 3;
				rshape<=3;
			
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	//if(num==1&&rotate==2)begin
	2: 
	if (((ADDR%640>x*32) && (ADDR%640<(x+1)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>=(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>y*32) && (ADDR/640+1<(y+3)*32)))
			begin 
				bgr_data <= 24'b000011111111111100000000; //pattren 2
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 1; y3<=1;
				x4<=1; y4<=2;
				height <= 3;
				width <= 1;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end

//	if(num==1&&rotate==3)begin
	/*****/3: if (((ADDR%640>=(x+2)*32) && (ADDR%640<(x+3)*32) && (ADDR/640+1<(y+2)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>=x*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>=(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b000011111111111100000000; //pattren 2
				x1<=2;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=2; y4<=1;
				height <= 2;
				width <= 3;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	endcase
	end
	
	/**********************************/
	//if(num==2&&rotate==0)begin
	2:
	begin
	case (rotate)
	0:
	begin/*****/
	if (((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1<(y+3)*32) && (ADDR/640+1>y*32))|| 
	((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1>(y+2)*32) && (ADDR/640+1<(y+3)*32)))
			begin 
				bgr_data <= 24'b111111100001111100000000; //pattren 3
				x1<=1;y1<=0;
				x2<= 1; y2<= 1;
				x3<= 1; y3<=2;
				x4<=0; y4<=2;
				height <= 3;
				width <= 2;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==2&&rotate==1)begin
	1:
	begin
	if (((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1<(y+2)*32) && (ADDR/640+1>y*32))|| 
	((ADDR%640>(x+1)*32) && (ADDR%640<=(x+3)*32) && (ADDR/640+1>(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111111100001111100000000; //pattren 3
				x1<=0;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=2; y4<=1;
				height <= 2;
				width <= 3;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==2&&rotate==2)begin
	2:
	begin
	if (((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1<(y+3)*32) && (ADDR/640+1>y*32))|| 
	((ADDR%640>(x+1)*32) && (ADDR%640<=(x+2)*32) && (ADDR/640+1>y*32) && (ADDR/640+1<(y+1)*32)))
			begin 
				bgr_data <= 24'b111111100001111100000000; //pattren 3
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 0; y3<=1;
				x4<=0; y4<=2;
				height <= 3;
				width <= 2;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==2&&rotate==3)begin
	3:
	begin
	if (((ADDR%640>x*32) && (ADDR%640<=(x+2)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
	((ADDR%640>(x+2)*32) && (ADDR%640<=(x+3)*32) && (ADDR/640+1>y*32) && (ADDR/640+1<(y+2)*32)))
	begin 
				bgr_data <= 24'b111111100001111100000000; //pattren 3
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 2; y3<=0;
				x4<=2; y4<=1;
				height <= 2;
				width <= 3;
				rshape<=3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	endcase
	end
	
	/************************************/
	//if(num==3&&rotate==0)begin
	3:
	begin
	case(rotate)
	0:
	begin
		if (((ADDR%640>x*32) && (ADDR%640<(x+3)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>=(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 4
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 2; y3<=0;
				x4<=1; y4<=1;
				height <= 2;
				width <= 3;
				rshape <= 3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==3&&rotate==1)
	//begin
	1:
	begin
		if (((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1<(y+2)*32) && (ADDR/640+1>(y+1)*32))|| 
		((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>=y*32) && (ADDR/640+1<(y+3)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 4
				x1<=1;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=1; y4<=2;
				height <= 3;
				width <= 2;
				rshape <= 3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==3&&rotate==2)
	//begin
	2:
	begin
		if (((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>x*32) && (ADDR%640<(x+3)*32) && (ADDR/640+1>=(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 4
				x1<=1;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=2; y4<=1;
				height <= 2;
				width <= 3;
				rshape <= 3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	//if(num==3&&rotate==3)begin
	3:
	begin
		if (((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1<(y+3)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>=(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 4
				x1<=0;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=0; y4<=2;
				height <= 3;
				width <= 2;
				rshape <= 3;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	endcase
	end
	/***********************************/
	//if(num==4&&(rotate==0||rotate==2))//begin
	4:
	begin
	if(rotate==0||rotate==2)
	begin
		if (((ADDR%640>x*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1<(y+1)*32) && (ADDR/640+1>y*32))|| 
		((ADDR%640>(x+1)*32) && (ADDR%640<(x+3)*32) && (ADDR/640+1>=(y+1)*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 5
				x1<=0;y1<=0;
				x2<= 1; y2<= 0;
				x3<= 1; y3<=1;
				x4<=2; y4<=1;
				height <= 2;
				width <= 3;
				rshape<= 1;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	
	if(rotate==1||rotate==3)//begin
	begin
		if (((ADDR%640>x*32) && (ADDR%640<=(x+1)*32) && (ADDR/640+1<(y+3)*32) && (ADDR/640+1>(y+1)*32))|| 
		((ADDR%640>(x+1)*32) && (ADDR%640<(x+2)*32) && (ADDR/640+1>=y*32) && (ADDR/640+1<(y+2)*32)))
			begin 
				bgr_data <= 24'b111110000111111100000000; //pattren 5
				x1<=1;y1<=0;
				x2<= 0; y2<= 1;
				x3<= 1; y3<=1;
				x4<=0; y4<=2;
				height <= 3;
				width <= 2;
				rshape<= 1;
			end
		else if ((ADDR%640)/32>=10)
			begin
				if ((ADDR%640)/10>=47&&(ADDR%640/10<51)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showunit(score,ADDR,bgr_data);
				end
				else if ((ADDR%640)/10>=42&&(ADDR%640/10<46)&&(ADDR/640/10>=10) && (ADDR/640/10<=17))
				begin
					showstens(score,ADDR,bgr_data);
				end
				else
				begin
					bgr_data <= 24'b011000001111001111100000;
				end
			end
		else 
			begin
				bgr_data <= background[(ADDR/640)/32][(ADDR%640)/32]? 24'h000000:24'hffffff;
			end
	end
	end
	
endcase
end


assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















