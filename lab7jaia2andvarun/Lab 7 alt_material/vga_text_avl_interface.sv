/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [3:0][7:0] LOCAL_REG       [`NUM_REGS]; // Registers

logic [9:0] DrawX,DrawY;
logic pixel_clk;
logic blank;
logic sync;
logic [7:0] curr_char;
logic [0:7] font_val;
logic [10:0] font_addr;
logic [3:0] for_red , for_green , for_blue , bkg_red, bkg_green, bkg_blue;
logic curr_bit;
//put other local variables here

always_comb
begin
	curr_char = LOCAL_REG[20*DrawY[9:4] + DrawX[9:5]] [DrawX[4:3]];
	font_addr = {curr_char[6:0], DrawY[3:0]};
	
	for_red = {LOCAL_REG[600][3][0] , LOCAL_REG[600][2][7:5]} ;
	for_green = LOCAL_REG[600][2][4:1];
	for_blue = {LOCAL_REG[600][2][0] , LOCAL_REG[600][1][7:5]} ;

	bkg_red = LOCAL_REG[600][1][4:1];
	bkg_green = {LOCAL_REG[600][1][0] , LOCAL_REG[600][0][7:5]} ;
	bkg_blue = LOCAL_REG[600][0][4:1];
	
	curr_bit = font_val[DrawX[2:0]];
end

//Declare submodules..e.g. VGA controller, ROMS, etc

vga_controller our_vga(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));
font_rom fontcurr(.addr(font_addr), .data(font_val));

always_ff @(posedge pixel_clk) 
begin
	if(blank == 0)
	begin
		red <= 4'h0;
		blue <= 4'h0;
		green <= 4'h0;
	end
	
	else if(curr_bit )
	begin
		red <= for_red;
		blue <= for_blue;
		green <= for_green;
	end
	
	else
	begin
		red <= bkg_red;
		blue <= bkg_blue;
		green <= bkg_green;
	end

end

   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) 
begin
	if(RESET)
	begin
		for(int i=0; i < `NUM_REGS ; i++)
		begin
			LOCAL_REG [i] <= 32'h00000000;
		end	
		
//		AVL_READDATA <= 32'h00000000;
	end
	
	else if(AVL_READ && AVL_CS)
	begin
	
		AVL_READDATA <= LOCAL_REG[AVL_ADDR];
		
	end else if(AVL_WRITE && AVL_CS)
	begin
		
		if(AVL_BYTE_EN[0])
			LOCAL_REG[AVL_ADDR][0] <= AVL_WRITEDATA[7:0];	
		if(AVL_BYTE_EN[1])
			LOCAL_REG[AVL_ADDR][1] <= AVL_WRITEDATA[15:8];	
		if(AVL_BYTE_EN[2])
			LOCAL_REG[AVL_ADDR][2] <= AVL_WRITEDATA[23:16];	
		if(AVL_BYTE_EN[3])
			LOCAL_REG[AVL_ADDR][3] <= AVL_WRITEDATA[31:24];	
		
	
	
	end
	
end



//handle drawing (may either be combinational or sequential - or both).
		//		 case (AVL_BYTE_EN)
//							
//							4'hf : begin
//										LOCAL_REG[AVL_ADDR] <= AVL_WRITEDATA;	
//									 end
//									  
//							4'hc : begin
//										LOCAL_REG[AVL_ADDR][ 3 : 2]<= AVL_WRITEDATA [ 31:16];	
//									 end
//
//							4'h3 : begin
//										LOCAL_REG[AVL_ADDR] [ 1:0 ] <= AVL_WRITEDATA [ 15:0 ];	
//									 end
//									  
//							4'h8 : begin
//									  LOCAL_REG[AVL_ADDR] [ 3 ] <= AVL_WRITEDATA [ 31:24 ];
//									 end
//							
//							4'h4 : begin
//									  LOCAL_REG[AVL_ADDR] [ 2 ] <= AVL_WRITEDATA [ 23:16 ];
//									 end	
//							
//							4'h2 : begin
//									  LOCAL_REG[AVL_ADDR] [ 1 ] <= AVL_WRITEDATA [ 15:8 ];
//									 end	
//							
//							4'h1 : begin
//									  LOCAL_REG[AVL_ADDR] [ 0 ] <= AVL_WRITEDATA [ 7:0 ];
//									 end			 
//							default:  ;
//					endcase
//	 

endmodule
