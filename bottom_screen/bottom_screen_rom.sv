module bottom_screen_rom (
	input logic clock,
	input logic [15:0] address,
	output logic [8:0] q
);

logic [8:0] memory [0:44279] /* synthesis ram_init_file = "./bottom_screen/bottom_screen.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
