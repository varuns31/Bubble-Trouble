
module lab61soc (
	clk_clk,
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
	button_export,
	keycode_export,
	usb_irq_export,
	usb_gpx_export,
	usb_rst_export,
	hex_digits_export,
	leds_export,
	key_external_connection_export);	

	input		clk_clk;
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
	input		button_export;
	output	[7:0]	keycode_export;
	input		usb_irq_export;
	input		usb_gpx_export;
	output		usb_rst_export;
	output	[15:0]	hex_digits_export;
	output	[13:0]	leds_export;
	input	[1:0]	key_external_connection_export;
endmodule
