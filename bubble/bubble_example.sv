module bubble_example (
	input logic [9:0] DrawX, DrawY,
	input logic vga_clk, blank,
	output logic [3:0] red, green, blue
);

logic [16:0] rom_address;
logic [5:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);

logic negedge_vga_clk;
assign negedge_vga_clk = ~vga_clk;

always_comb begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
end

bubble_rom bubble_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

bubble_palette bubble_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
