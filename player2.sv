

module  player_2( input Reset, frame_clk,
					input vga_clk,
					input [7:0] keycode,keycode2,keycode3,keycode4,
					input  [9:0]DrawX, DrawY,level,
					output [3:0] Red,Blue,Green,
					input [1:0] game_on,
					input collision2,
					input [9:0] right,left,
					input player_2_inplay,
               output [9:0]  PlayerX, PlayerY, PlayerS, 
					output player_on);
    
    logic [9:0] Player_X_Pos, Player_X_Motion, Player_Y_Pos, Player_Y_Motion, Player_Size;
//	 logic [4:0] timer;
	 
    parameter [9:0] Player_X_Center=380;  // Center position on the X axis
//    parameter [9:0] Player_Y_Center=450;  // 240  - original Center position on the Y axis
    parameter [9:0] Player_X_Min=10;       // Leftmost point on the X axis
	 parameter [9:0] Player_X_Min_wall=130;       // Leftmost point on the X axis
    parameter [9:0] Player_X_Max=590;     // Rightmost point on the X axis
//    parameter [9:0] Player_Y_Min=300;       // Topmost point on the Y axis
//    parameter [9:0] Player_Y_Max=479;     // Bottommost point on the Y axis
    logic     [1:0] Player_X_lStep;      // Step size on the X axis on left
	 logic     [1:0] Player_X_rStep;      // Step size on the X axis on right
	
	logic [11:0] rom_address;
	
	logic [8:0] rom_q , rom_q2 , rom_q3;

	logic [3:0] palette_red, palette_green, palette_blue,palette_red_right, palette_green_right, palette_blue_right,palette_red_forward, palette_green_forward, palette_blue_forward;

	logic negedge_vga_clk;

	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;
	
//	always_comb
//	begin
//			rom_address = (DistX);
//	end

	assign rom_address = (DistX) + (DistY * 43);
	
	varun1_rom bubble_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
	);

	varun1_palette bubble_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);
	
		varun1_forward_rom bubble_rom_3 (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q3)
	);

	varun1_forward_palette bubble_palette_3 (
		.index (rom_q3),
		.red   (palette_red_forward),
		.green (palette_green_forward),
		.blue  (palette_blue_forward)
	);
	
	varun1_right_rom bubble_rom_2 (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q2)
	);

	varun1_right_palette bubble_palette_2 (
		.index (rom_q2),
		.red   (palette_red_right),
		.green (palette_green_right),
		.blue  (palette_blue_right)
	);

	
    parameter [9:0] player_x_size = 43;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    parameter [9:0] player_y_size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Player
        if (Reset)  // Asynchronous Reset
        begin 
				Player_X_lStep <= 2;
				Player_X_rStep <= 2;
				Player_X_Pos <= Player_X_Center;
//				Player_Y_Pos <= Player_Y_Center;
//				timer <= 4'b0000;
        end
		  
		  else if(game_on == 0)
		  begin
					Player_X_Pos <= Player_X_Center;
//					Player_Y_Pos <= Player_Y_Center;
		  end
           
        else 
        begin

				 if ( (Player_X_Pos + player_x_size) >= Player_X_Max )  // Player is at the Right edge, BOUNCE!
					  Player_X_rStep <= 0;  // 2's complement.
					  
				 else if ( (Player_X_Pos - player_x_size) <= Player_X_Min_wall && (level == 4 || level == 5 || level == 6))  // Player is at the Left edge, BOUNCE!
					  Player_X_lStep <= 0;
					  
				 else if ( (Player_X_Pos - player_x_size) <= Player_X_Min )  // Player is at the Left edge, BOUNCE!
					  Player_X_lStep <= 0;
					  
				 else 
				 begin
						Player_X_lStep <= 2;
						Player_X_rStep <= 2;
				 end
				 
				 	 if (keycode == left || keycode2 == left || keycode3 == left|| keycode4== left)
					 begin
							Player_X_Pos <= (Player_X_Pos - Player_X_lStep) ;
					 end
					else if (keycode == right || keycode2 == right || keycode3 == right || keycode4 == right)		  
					begin
						Player_X_Pos <= (Player_X_Pos + Player_X_rStep) ;
					end
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Player_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Player_Y_pos.  Will the new value of Player_Y_Motion be used,
          or the old?  How will this impact behavior of the Player during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/  
		end
	 end
       
	 
    assign PlayerX = Player_X_Pos;
   
    assign PlayerY = 350;
   
    assign PlayerS = player_y_size;
	 
	 int DistX, DistY, Size;
	 assign DistX = DrawX - PlayerX;
    assign DistY = DrawY - PlayerY;
	 assign Dist2X = PlayerX - DrawX ;
    assign Dist2Y = PlayerY - DrawY ;
	  
    always_comb
    begin:Player_on
        if ( ( DistX <= (player_x_size) && DistY <= (player_y_size) && DistX > 0 && DistY > 0) && ~collision2) 
        begin
				if(rom_q2 == 1 && (keycode == right || keycode2 == right || keycode3 == right || keycode4 == right) && player_2_inplay)
				begin
					player_on = 1'b0;
					Red = palette_red_right;
					Green = palette_green_right;
					Blue = palette_blue_right + 5;
				end
				else if((keycode == right || keycode2 == right || keycode3 == right || keycode4 == right) && player_2_inplay)
				begin
					player_on = 1'b1;
					Red = palette_red_right;
					Green = palette_green_right;
					Blue = palette_blue_right + 5;
				end
				else if(rom_q == 1 &&  (keycode == left || keycode2 == left || keycode3 == left|| keycode4== left) && player_2_inplay)
				begin
					player_on = 1'b0;
					Red = palette_red;
					Green = palette_green;
					Blue = palette_blue + 5;	
				end
				else if( (keycode == left || keycode2 == left || keycode3 == left|| keycode4== left) && player_2_inplay)
				begin
					player_on = 1'b1;
					Red = palette_red;
					Green = palette_green;
					Blue = palette_blue + 5;	
				end
				else if(rom_q3 == 0 || player_2_inplay == 0)
				begin
					player_on = 1'b0;
					Red = palette_red_forward;
					Green = palette_green_forward;
					Blue = palette_blue_forward + 5;	
				end
				else
				begin
					player_on = 1'b1;
					Red = palette_red_forward;
					Green = palette_green_forward;
					Blue = palette_blue_forward + 5;
				end
			end
//		  else if ( ( Dist2X <= (Size) && Dist2Y <= Size && Dist2X > 0 && Dist2Y > 0)) 
//            player_on = 1'b1;
//		  else if ( ( Dist2X <= (Size) && Dist2Y <= Size && Dist2X > 0 && Dist2Y > 0)) 
//            player_on = 1'b1;
        else 
		  begin
            player_on = 1'b0;
				Red = 4'hf;
				Blue = 4'hf;
				Green = 4'hf;
			end
     end 
    
    

endmodule
