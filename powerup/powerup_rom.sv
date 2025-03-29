module powerup_rom (
	input logic clock,
	input logic [9:0] address,
	output logic [8:0] q
);

logic [8:0] memory [0:559] /* synthesis ram_init_file = "./powerup/powerup.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
