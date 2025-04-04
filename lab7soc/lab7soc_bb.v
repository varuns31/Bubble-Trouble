
module lab7soc (
	button_export,
	clk_clk,
	hex_digits_export,
	key_external_connection_export,
	keycode_export,
	keycode2_export,
	keycode3_export,
	keycode4_export,
	leds_export,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	spi0_MISO,
	spi0_MOSI,
	spi0_SCLK,
	spi0_SS_n,
	usb_gpx_export,
	usb_irq_export,
	usb_rst_export,
	vga_port_new_signal,
	vga_port_new_signal_1,
	vga_port_new_signal_2,
	vga_port_new_signal_3,
	vga_port_new_signal_4,
	vga_port_new_signal_5,
	vga_port_new_signal_6,
	vga_port_new_signal_7,
	vga_port_new_signal_8);	

	input		button_export;
	input		clk_clk;
	output	[15:0]	hex_digits_export;
	input	[1:0]	key_external_connection_export;
	output	[7:0]	keycode_export;
	output	[7:0]	keycode2_export;
	output	[7:0]	keycode3_export;
	output	[7:0]	keycode4_export;
	output	[13:0]	leds_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input		spi0_MISO;
	output		spi0_MOSI;
	output		spi0_SCLK;
	output		spi0_SS_n;
	input		usb_gpx_export;
	input		usb_irq_export;
	output		usb_rst_export;
	output	[3:0]	vga_port_new_signal;
	output	[3:0]	vga_port_new_signal_1;
	output		vga_port_new_signal_2;
	output		vga_port_new_signal_3;
	output	[3:0]	vga_port_new_signal_4;
	input	[7:0]	vga_port_new_signal_5;
	input	[7:0]	vga_port_new_signal_6;
	input	[7:0]	vga_port_new_signal_7;
	input	[7:0]	vga_port_new_signal_8;
endmodule
