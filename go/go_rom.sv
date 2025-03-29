module go_rom (
	input logic clock,
	input logic [10:0] address,
	output logic [5:0] q
);

logic [5:0] memory [0:1199] /* synthesis ram_init_file = "./go/go.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
