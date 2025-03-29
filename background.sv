module background (
	input logic vga_clk,
	input logic hs,
	input logic [9:0] DrawX, DrawY,level,
	input logic blank,
	input logic [3:0] red_back, green_back, blue_back,
	output logic [3:0] red, green, blue
);
logic [15:0] rom_address,rom_address2;
logic [8:0] rom_q , rom_q2;
logic [9:0] tempy;

logic [3:0] palette_red_bottom, palette_green_bottom, palette_blue_bottom;
logic [3:0] palette_red_brick, palette_green_brick, palette_blue_brick;


logic negedge_vga_clk;

always_ff@(posedge hs)
begin
	if(DrawY < 56)
		tempy <= DrawY;
	else if(tempy < 56)
		tempy <= tempy + 1;
	else
		tempy <= 0;
end

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

always_comb
begin
	if(DrawX < 51)
	begin
		rom_address2 = DrawX + (tempy * 50);
	end
	else if(DrawX < 590)
	begin
		rom_address2 = (DrawX - 120) + (tempy * 50);
	end
	else
	begin
		rom_address2 = (DrawX - 590) + (tempy * 50);
	end
end

assign rom_address = (DrawX - 50) + ((DrawY - 398) * 540);

always_comb
begin
	if((level == 4 || level == 5 || level == 6) && DrawX >= 120 && DrawX < 170 && DrawY >= 224 && DrawY < 398)
	begin
		red = palette_red_brick;
		green = palette_green_brick;
		blue = palette_blue_brick;
	end
	else if(DrawX > 50 && DrawX < 590 && DrawY<398)
	begin
		red = red_back;
		green = green_back;
		blue = blue_back;
	end
	else if(DrawX > 50 && DrawX < 590)
	begin
		red = palette_red_bottom;
		green = palette_green_bottom;
		blue = palette_blue_bottom;
	end
	else
	begin
		red = palette_red_brick;
		green = palette_green_brick;
		blue = palette_blue_brick;
	end
	
end


bottom_screen_rom bottom_screen_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

bottom_screen_palette bottom_screen_palette (
	.index (rom_q),
	.red   (palette_red_bottom),
	.green (palette_green_bottom),
	.blue  (palette_blue_bottom)
);


brick_rom brick_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address2),
	.q       (rom_q2)
);

brick_palette brick_palette (
	.index (rom_q2),
	.red   (palette_red_brick),
	.green (palette_green_brick),
	.blue  (palette_blue_brick)
);

endmodule