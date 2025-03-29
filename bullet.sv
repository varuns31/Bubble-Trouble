module bullet(input Reset, frame_clk,pixel_clk,
					input [7:0] keycode,keycode2,keycode3,keycode4,
					input [1:0] game_on,
					input [1:0] player,
					input collected_player1,collected_player2,
					input  [9:0]DrawX, DrawY,
					input [9:0] shoot,
					input inplay,collision,
					input [9:0]  PlayerX, PlayerY, PlayerS,
					input bullet_hit_1,bullet_hit_2,bullet_hit_3,bullet_hit_4,bullet_hit_5,bullet_hit_6, powerup,
               output [9:0]  BulletX, BulletY, BulletS,
					output bullet_on);

	parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis\
	logic bullet_curr;
	parameter [9:0] bullet_y_motion = 5;
	logic [9:0] shot;
	logic half_clk;

	always_ff@(posedge frame_clk)
	begin
		if(game_on == 1)
		begin
			if((keycode == shoot || keycode2 == shoot || keycode3 == shoot || keycode4 == shoot) && bullet_curr == 0)
			begin
				bullet_curr <= 1;
				BulletX <= PlayerX + 20;
				shot <= PlayerX + 20;
			end
			else if(bullet_hit_1 == 1 || bullet_hit_2 == 1 || bullet_hit_3 == 1 || bullet_hit_4 == 1 || bullet_hit_5 == 1 || bullet_hit_6 == 1)
			begin
				bullet_curr <= 0;
				BulletY <= PlayerY;
				BulletX <= PlayerX;
			end
			else if(bullet_curr == 1 && BulletY <= Bullet_Y_Min && ((collected_player1 && player == 1) || (collected_player2 && player == 2)))
			begin
				BulletY <= BulletY;
				BulletX <= shot;
				bullet_curr <= 1;
			end
			else if(bullet_curr == 1 && BulletY > Bullet_Y_Min)
			begin
				BulletY <= BulletY - bullet_y_motion;
				BulletX <= shot;
			end
			else
			begin
				bullet_curr <= 0;
				BulletY <= PlayerY;
				BulletX <= PlayerX;
			end
		end
		
		else
		begin
				BulletY <= PlayerY;
				BulletX <= PlayerX;
		end
		half_clk <= ~half_clk;
	end
	
    always_comb
    begin
		  if (bullet_curr == 1 && inplay && ~collision)
		  begin
			  if (BulletY < (DrawY) && DrawX == (BulletX) && BulletY < 440 && DrawY < 398 && half_clk) 
					bullet_on = 1'b1;
	//		  else if ( ( Dist2X <= (Size) && Dist2Y <= Size && Dist2X > 0 && Dist2Y > 0)) 
	//            player_on = 1'b1;
			  else 
					bullet_on = 1'b0;
			end
			
			else
				bullet_on = 1'b0;
     end 	
	

endmodule




module powerup(input Reset, frame_clk,pixel_clk,
					input power_possible, collected_player1,collected_player2,
					input [1:0] game_on,
					input  [9:0]DrawX, DrawY,level,
					output power_on,
					output [3:0] red,blue,green);
					
					
	 always_comb
    begin
		  if (power_possible == 1)
		  begin
			  if (DrawY < 398 && DrawY >= 370 && DrawX < 120 && DrawX >= 100 && (collected_player1 || collected_player2)) 
					power_on = 0;
	//		  else if ( ( Dist2X <= (Size) && Dist2Y <= Size && Dist2X > 0 && Dist2Y > 0)) 
	//            player_on = 1'b1;
			  else if (DrawY < 398 && DrawY > 370 && DrawX < 120 && DrawX > 100 && level == 2) 
					power_on = 1'b1;
				else 
					power_on = 1'b0;
			end
			
			else
				power_on = 1'b0;
     end 

		
	logic [9:0] rom_address;
	logic [8:0] rom_q;

	logic [3:0] palette_red, palette_green, palette_blue;

	logic negedge_vga_clk;

	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~pixel_clk;

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	assign rom_address = ((DrawX-100) + ((DrawY - 370) * 20));

	always_comb 
		begin
			red <= palette_red;
			green <= palette_green;
			blue <= palette_blue;
		end

	powerup_rom powerup_rom (
		.clock   (negedge_vga_clk),
		.address (rom_address),
		.q       (rom_q)
	);

	powerup_palette powerup_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);


endmodule
