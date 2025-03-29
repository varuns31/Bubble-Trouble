module varun1_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue
);

logic [11:0] rom_address;
logic [8:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = ((DrawX * 43) / 80) + (((DrawY * 50) / 60) * 43);

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		if(DrawY > 300)
		begin
			red <= 4'hf;
			green <= 4'hf;
			blue <= 4'hf;
		end
		else
		begin
			red <= palette_red;
			green <= palette_green;
			blue <= palette_blue;
		end	
	end
end

varun1_rom varun1_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

varun1_palette varun1_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
