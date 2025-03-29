module brick_rom (
	input logic clock,
	input logic [11:0] address,
	output logic [8:0] q
);

logic [8:0] memory [0:2799] /* synthesis ram_init_file = "./brick/brick.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
