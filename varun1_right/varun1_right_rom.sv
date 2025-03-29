module varun1_right_rom (
	input logic clock,
	input logic [11:0] address,
	output logic [8:0] q
);

logic [8:0] memory [0:2149] /* synthesis ram_init_file = "./varun1_right/varun1_right.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
