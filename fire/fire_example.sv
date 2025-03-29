module fire_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic [2:0] lives,
	output logic [3:0] red, green, blue,
	output logic lives_on
);

logic [9:0] rom_address,rom_address2,rom_address3,rom_address4;
logic [8:0] rom_q,rom_q2,rom_q3,rom_q4;

logic [3:0] palette_red, palette_green, palette_blue,palette_red2, palette_green2, palette_blue2,palette_red3, palette_green3, palette_blue3,palette_red4, palette_green4, palette_blue4;

logic negedge_vga_clk;

logic [9:0] lives_limit;


// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;


// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = (DrawX - 52) + ((DrawY - 425) * 34);
assign rom_address2 = (DrawX - 86) + ((DrawY - 425) * 34);
assign rom_address3 = (DrawX - 120) + ((DrawY - 425) * 34);
assign rom_address4 = (DrawX - 154) + ((DrawY - 425) * 34);



always_comb
	begin
		if ((DrawX < (86)) && (DrawX >= 52) && (DrawY >= 425) && (DrawY < 441))
		begin
			lives_on = 1'b1;
			red = palette_red;
			green = palette_green;
			blue = palette_blue;
		end
		else if ((DrawX < (120)) && (DrawX >= 86) && (DrawY >= 425) && (DrawY < 441) && lives >= 1)
		begin
			lives_on = 1'b1;
			red = palette_red2;
			green = palette_green2;
			blue = palette_blue2;
		end
		else if ((DrawX < (154)) && (DrawX >= 120) && (DrawY >= 425) && (DrawY < 441) && lives >= 2)
		begin
			lives_on = 1'b1;
			red = palette_red3;
			green = palette_green3;
			blue = palette_blue3;
		end
		else if ((DrawX < (188)) && (DrawX >= 154) && (DrawY >= 425) && (DrawY < 441) && lives >= 3)
		begin
			lives_on = 1'b1;
			red = palette_red4;
			green = palette_green4;
			blue = palette_blue4;
		end
		else
		begin
			lives_on = 1'b0;
			red = palette_red;
			green = palette_green;
			blue = palette_blue;
		end
	end

fire_rom fire_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

fire_palette fire_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

fire_rom fire_rom2 (
	.clock   (negedge_vga_clk),
	.address (rom_address2),
	.q       (rom_q2)
);

fire_palette fire_palette2 (
	.index (rom_q2),
	.red   (palette_red2),
	.green (palette_green2),
	.blue  (palette_blue2)
);

fire_rom fire_rom3 (
	.clock   (negedge_vga_clk),
	.address (rom_address3),
	.q       (rom_q3)
);

fire_palette fire_palette3 (
	.index (rom_q3),
	.red   (palette_red3),
	.green (palette_green3),
	.blue  (palette_blue3)
);

fire_rom fire_rom4 (
	.clock   (negedge_vga_clk),
	.address (rom_address4),
	.q       (rom_q4)
);

fire_palette fire_palette4 (
	.index (rom_q4),
	.red   (palette_red4),
	.green (palette_green4),
	.blue  (palette_blue4)
);

endmodule
