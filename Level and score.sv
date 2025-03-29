module levelscore (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,level,score,score2,score_tens,score2_tens,score_hundreds,score2_hundreds,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic number_on
);
logic [10:0] rom_address , rom_address_score , rom_address_score2;
logic [0:7] data , data_score , data_score2;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen

assign rom_address = 768 + (level * 16) + (DrawY - 455);

always_comb begin
	if(DrawX >= 212 && DrawX <= 219 && DrawY >= 457 && DrawY < 473)
		rom_address_score = 768 + ((score % 10) * 16) + (DrawY - 457);
	else if (DrawX >= 204 && DrawX <= 211 && DrawY >= 457 && DrawY < 473)
		rom_address_score = 768 + ((score_tens % 10) * 16) + (DrawY - 457);
	else
		rom_address_score = 768 + ((score_hundreds % 10) * 16) + (DrawY - 457);
end


always_comb begin
	if(DrawX >= 422 && DrawX <= 429 && DrawY >= 457 && DrawY < 473)
		rom_address_score2 = 768 + ((score2 % 10) * 16) + (DrawY - 457);
	else if (DrawX >= 414 && DrawX <= 421 && DrawY >= 457 && DrawY < 473)
		rom_address_score2 = 768 + ((score2_tens % 10) * 16) + (DrawY - 457);
	else
		rom_address_score2 = 768 + ((score2_hundreds % 10) * 16) + (DrawY - 457);
end

always_comb begin
		if(DrawX >= 317 && DrawX <= 324 && DrawY >= 455 && DrawY < 471)
		begin
			green = 4'h0;
			blue = 4'h0;
			if(data[DrawX-317] == 1)
			begin
				red = 4'hf;
				number_on = 1;
			end
			else
			begin
				red = 4'h0;
				number_on = 0;
			end
		end
		else if(DrawX >= 212 && DrawX <= 219 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			blue = 4'h0;
			if(data_score[DrawX-212] == 1)
			begin
				red = 4'hf;
				number_on = 1;
			end
			else
			begin
				red = 4'h0;
				number_on = 0;
			end
		end
				else if(DrawX >= 204 && DrawX <= 211 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			blue = 4'h0;
			if(data_score[DrawX-204] == 1 && ~(score_tens == 0))
			begin
				red = 4'hf;
				number_on = 1;
			end
			else
			begin
				red = 4'h0;
				number_on = 0;
			end
		end
				else if(DrawX >= 196 && DrawX <= 203 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			blue = 4'h0;
			if(data_score[DrawX-196] == 1 && ~(score_hundreds == 0))
			begin
				red = 4'hf;
				number_on = 1;
			end
			else
			begin
				red = 4'h0;
				number_on = 0;
			end
		end
		
				else if(DrawX >= 422 && DrawX <= 429 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			red = 4'h0;
			if(data_score2[DrawX-422] == 1)
			begin
				blue = 4'hf;
				number_on = 1;
			end
			else
			begin
				blue = 4'h0;
				number_on = 0;
			end
		end
				else if(DrawX >= 414 && DrawX <= 421 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			red = 4'h0;
			if(data_score2[DrawX-414] == 1 && ~(score2_tens == 0) )
			begin
				blue = 4'hf;
				number_on = 1;
			end
			else
			begin
				blue = 4'h0;
				number_on = 0;
			end
		end
				else if(DrawX >= 406 && DrawX <= 413 && DrawY >= 457 && DrawY < 473)
		begin
			green = 4'h0;
			red = 4'h0;
			if(data_score2[DrawX-406] == 1 &&  ~(score2_hundreds == 0))
			begin
				blue = 4'hf;
				number_on = 1;
			end
			else
			begin
				blue = 4'h0;
				number_on = 0;
			end
		end
		
		else
		begin
			number_on = 0;
			red = 4'h0;
			green = 4'h0;
			blue = 4'h0;
		end
end

font_rom go_rom (
	.addr (rom_address),
	.data       (data)
);

font_rom go_rom2 (
	.addr (rom_address_score),
	.data       (data_score)
);


font_rom go_rom3 (
	.addr (rom_address_score2),
	.data       (data_score2)
);

endmodule
