module control (input logic Clk, Reset, 
					 input logic [7:0] keycode,keycode2,keycode3,keycode4,
					 input logic [9:0] BallSize,PlayerSize, Bally ,BallX, PlayerX, PlayerY,
					 input  [9:0]DrawX, DrawY, level, score,cur_pos,
					 input logic ball_on,player_on,collide,collide2,bullet_hit_1,bullet_hit_2,bullet_hit_3,bullet_hit_4,bullet_hit_5,bullet_hit_6,
					  output logic level_up, player_2_inplay, power_possible,
					  output logic [1:0] on,
					  output logic cont,
					  output logic [2:0] lives,
					  output logic ball_1_inplay,ball_2_inplay,ball_3_inplay,ball_4_inplay,ball_5_inplay,ball_6_inplay,
					  output logic [9:0] Ball_size_1,Ball_size_2,Ball_size_3,Ball_size_4,Ball_size_5,Ball_size_6);

    enum logic [5:0] {start, play_level1 , play_level1hit1 , play_level1hit2 , play_level1hit3, collision, play_level2, play_level2hit1, play_level2hit3, play_level2hit13, play_level2hit2, play_level2hit4, play_level2hit131, play_level2hit132, play_level2hit133, play_level2hit134,play_level2trans,play_level1_2player , play_level1hit1_2player , play_level1hit2_2player , play_level1hit3_2player, play_level2_2player, play_level2hit1_2player, play_level2hit3_2player, play_level2hit13_2player, play_level2hit2_2player, play_level2hit4_2player, play_level2hit131_2player, play_level2hit132_2player, play_level2hit133_2player, play_level2hit134_2player,play_level2trans_2player , level1lifelost ,level2lifelost}   curr_state, next_state; 
	always_ff @ (posedge Clk)  
    begin
        if (Reset)
		  begin
            curr_state <= start;
		  end
		  
        else
				curr_state <= next_state;
    end
	 
	 
	 always_ff @ (posedge Clk)
	 begin
		if(on == 0)
			lives <= 3;
		else if(collide)
			lives <= lives - 1;
	 end

	always_comb
	
    begin
		  next_state  = curr_state;
        case (curr_state) 
		  
				start				 : if ((keycode == 40 || keycode2 == 40 || keycode3 == 40 || keycode4 == 40) && cur_pos == 46)
											next_state = play_level1_2player;
										else if (keycode == 40  || keycode2 == 40 || keycode3 == 40 || keycode4 == 40)
											next_state = play_level1;
										else 
											next_state = start;
				
//				play				 : if ((((PlayerX-BallX) < (PlayerSize + BallSize)) && ((PlayerY - Bally) < (PlayerSize + BallSize))) || (((BallX - PlayerX) < (PlayerSize + BallSize)) && ((PlayerY - Bally) < (PlayerSize + BallSize))))
				play_level1		:     if (collide && lives == 0)										
												next_state = collision;
											else if(collide)
												next_state = level1lifelost;
											else if(bullet_hit_1)
												next_state = play_level1hit1;
											else 
												next_state = play_level1;
				play_level1hit1 :  if (collide && lives == 0)										
												next_state = collision;
											else if(collide)
												next_state = level1lifelost;
											else if(bullet_hit_1 && bullet_hit_2)
												next_state = play_level1hit3;
											else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level1hit2;
											else 
												next_state = play_level1hit1;
				play_level1hit2 :  if (collide && lives == 0)										
												next_state = collision;
											else if(collide)
												next_state = level1lifelost;
											else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level1hit3;
											else 
												next_state = play_level1hit2;
				play_level1hit3 : if(level == 9)
											next_state = start;
										else
										next_state = play_level2;
				
				
				play_level2		 : if (collide && lives == 0)										
												next_state = collision;
										else if(collide)
												next_state = level2lifelost;
												
										else if(bullet_hit_1)
												next_state = play_level2hit1;
										else if(bullet_hit_3)
												next_state = play_level2hit3;
										else 
												next_state = play_level2;
				
				play_level2hit1	: if (collide && lives == 0)										
												next_state = collision;
											else if(collide)
												next_state = level2lifelost;
										else if (bullet_hit_3)
												next_state = play_level2hit13;
										else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level2hit2;
										else 
												next_state = play_level2hit1;
				
				play_level2hit3	: if (collide && lives == 0)										
												next_state = collision;
										else if(collide)
												next_state = level2lifelost;
										else if(bullet_hit_1)
												next_state = play_level2hit13;
										else if(bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit4;
										else 
												next_state = play_level2hit3;
				
				play_level2hit13	: if (collide && lives == 0)										
												next_state = collision;
										else if(collide)
												next_state = level2lifelost;
												
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit131;
										else 
												next_state = play_level2hit13;
												
				play_level2hit2	: if (collide && lives == 0)										
												next_state = collision;
										
										else if(collide)
												next_state = level2lifelost;
										else if(bullet_hit_3)
												next_state = play_level2hit131;
										else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level2hit131;
										else 
												next_state = play_level2hit2;
											
				play_level2hit4	: if (collide && lives == 0)										
												next_state = collision;
										
										else if(collide)
												next_state = level2lifelost;
												
										else if(bullet_hit_1)
												next_state = play_level2hit131;
										else if(bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit131;
										else 
												next_state = play_level2hit4;
											
				level1lifelost : next_state = play_level1;
				level2lifelost : next_state = play_level2;
				
				collision		 : if (keycode == 44  || keycode2 == 44 || keycode3 == 44 || keycode4 == 44)
											next_state = start;
										else
											next_state = collision;
				
				play_level2hit131	: if (collide && lives == 0)										
												next_state = collision;
												
										else if(collide)
												next_state = level2lifelost;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit132;
										else 
												next_state = play_level2hit131;
				
				play_level2hit132	: if (collide && lives == 0)										
												next_state = collision;
										
										else if(collide)
												next_state = level2lifelost;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit133;
										else 
												next_state = play_level2hit132;
				play_level2hit133	: if (collide && lives == 0)										
												next_state = collision;
										
										else if(collide)
												next_state = level2lifelost;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit134;
										else 
												next_state = play_level2hit133;
				play_level2hit134	: if(level == 9)
											next_state = start;
										else
										next_state = play_level1;
										
				
					play_level1_2player		:     if (collide && collide2)										
												next_state = collision;
											else if(bullet_hit_1)
												next_state = play_level1hit1_2player;
											else 
												next_state = play_level1_2player;
				play_level1hit1_2player :  if (collide && collide2)										
												next_state = collision;
											else if(bullet_hit_1 && bullet_hit_2)
												next_state = play_level1hit3_2player;
											else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level1hit2_2player;
											else 
												next_state = play_level1hit1_2player;
				play_level1hit2_2player :  if (collide && collide2)										
												next_state = collision;
											else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level1hit3_2player;
											else 
												next_state = play_level1hit2_2player;
				play_level1hit3_2player : if(level == 9)
											next_state = start;
										else
										next_state = play_level2_2player;
				
				
				play_level2_2player		 : if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1)
												next_state = play_level2hit1_2player;
										else if(bullet_hit_3)
												next_state = play_level2hit3_2player;
										else 
												next_state = play_level2_2player;
				
				play_level2hit1_2player	: if (collide && collide2)										
												next_state = collision;
										else if (bullet_hit_3)
												next_state = play_level2hit13_2player;
										else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level2hit2_2player;
										else 
												next_state = play_level2hit1_2player;
				
				play_level2hit3_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1)
												next_state = play_level2hit13_2player;
										else if(bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit4_2player;
										else 
												next_state = play_level2hit3_2player;
				
				play_level2hit13_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit131_2player;
										else 
												next_state = play_level2hit13_2player;
												
				play_level2hit2_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_3)
												next_state = play_level2hit131_2player;
										else if(bullet_hit_1 || bullet_hit_2)
												next_state = play_level2hit131_2player;
										else 
												next_state = play_level2hit2_2player;
											
				play_level2hit4_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1)
												next_state = play_level2hit131_2player;
										else if(bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit131_2player;
										else 
												next_state = play_level2hit4_2player;
										
				
				play_level2hit131_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit132_2player;
										else 
												next_state = play_level2hit131_2player;
				
				play_level2hit132_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit133_2player;
										else 
												next_state = play_level2hit132_2player;
				play_level2hit133_2player	: if (collide && collide2)										
												next_state = collision;
										else if(bullet_hit_1 || bullet_hit_2 ||bullet_hit_3 || bullet_hit_4)
												next_state = play_level2hit134_2player;
										else 
												next_state = play_level2hit133_2player;
				play_level2hit134_2player	: if(level == 9)
											next_state = start;
										else
										next_state = play_level1_2player;
											
        endcase

		 on = 0;
	 
        case (curr_state) 
				start: 
	         begin
				   on = 0;
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					level_up = 0;
					player_2_inplay = 0;
//					PlayerX = 320;
//					PlayerY = 445;
//					BallX = 320;
//					BallY = 240;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level1: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					 on = 1;
					 level_up = 0;
					 player_2_inplay = 0;
					 power_possible = 0;
					 cont = 0;
					 
		      end
				play_level1hit1: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					 on = 1;
					 level_up = 0;
					 player_2_inplay = 0;
					 power_possible = 0;
					 cont = 0;
		      end
				play_level1hit2: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
					
		      end
				
				play_level1hit3: 
	         begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 1;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				collision: 
	         begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 20;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 2;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit1: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit2: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit3: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit4: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit13: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit131: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit132: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit133: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit134: 
	         begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 1;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level1_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					 on = 1;
					 level_up = 0;
					 player_2_inplay = 1;
					 power_possible = 0;
					 cont = 0;
		      end
				play_level1hit1_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					 on = 1;
					 level_up = 0;
					 player_2_inplay = 1;
					 power_possible = 0;
					 cont = 0;
		      end
				play_level1hit2_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level1hit3_2player: 
	         begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 20;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 1;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit1_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit2_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit3_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit4_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 0;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 0;
					cont = 0;
		      end
				
				play_level2hit13_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit131_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit132_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit133_2player: 
	         begin
					ball_1_inplay = 1;
					ball_2_inplay = 1;
					ball_3_inplay = 1;
					ball_4_inplay = 1;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 10;
					Ball_size_2 = 10;
					Ball_size_3 = 10;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 1;
					power_possible = 1;
					cont = 0;
		      end
				
				play_level2hit134_2player: 
	         begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 1;
					player_2_inplay = 1;
					power_possible = 1;
					cont = 0;
		      end
				level1lifelost:
				begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 0;
					cont = 1;
				end
				level2lifelost:
				begin
					ball_1_inplay = 0;
					ball_2_inplay = 0;
					ball_3_inplay = 0;
					ball_4_inplay = 0;
					ball_5_inplay = 0;
					ball_6_inplay = 0;
					Ball_size_1 = 20;
					Ball_size_2 = 10;
					Ball_size_3 = 20;
					Ball_size_4 = 10;
					Ball_size_5 = 20;
					Ball_size_6 = 20;
					on = 1;
					level_up = 0;
					player_2_inplay = 0;
					power_possible = 1;
					cont = 1;
				end
				
        endcase
    end

endmodule