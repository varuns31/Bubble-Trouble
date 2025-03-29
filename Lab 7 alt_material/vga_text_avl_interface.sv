/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	input logic [7:0] keycode,keycode2,keycode3,keycode4,
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [3:0][7:0] LOCAL_REG; // Registers
logic [3:0][7:0] control_reg;
logic [31:0] output_logic;
logic [20:0] half_vga_clk;

logic [9:0] DrawX,DrawY;
logic pixel_clk;
logic blank , player_2_inplay;
logic sync;
logic [7:0] curr_char;
logic [0:7] font_val;
logic [10:0] font_addr;
logic [3:0] for_red , for_green , for_blue , bkg_red, bkg_green, bkg_blue;
logic curr_bit;
logic addr_logic,level_up;
logic [31:0] temp_output;
logic [9:0] cur_pos;
logic player1hit,player2hit;
logic collision2;
logic cont;
//put other local variables here

vga_controller our_vga(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));
//font_rom fontcurr(.addr(glyph_addr), .data(glyph_data));

bubble_example pic ( // the generated example. in this case, the image was called "pic"
	.vga_clk (pixel_clk),
	.DrawX   (DrawX), 
	.DrawY   (DrawY),
	.blank   (blank),
	.red     (Red_bubble),
	.green   (Green_bubble),
	.blue    (Blue_bubble)
);

logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, ballxsig2, ballysig2, ballsizesig2, ballxsig3, ballysig3, ballsizesig3, ballxsig4, ballysig4, ballsizesig4;
logic ball_on,ball_on2,ball_on3,ball_on4,ball_on5,ball_on6;
logic [7:0] Red_ball,Green_ball , Blue_ball,Red_ball_2,Green_ball_2 , Blue_ball_2, Red_ball_3,Green_ball_3 , Blue_ball_3, Red_ball_4,Green_ball_4 , Blue_ball_4;
logic [3:0]  Red_bubble, Green_bubble , Blue_bubble;
logic [3:0]  Red_player, Green_player , Blue_player,Red_player2, Green_player2 , Blue_player2;
logic [3:0]  Red_num, Green_num , Blue_num, Red_pow, Green_pow , Blue_pow;
logic [3:0] Red_back, Green_back , Blue_back;
logic [3:0] Red_over, Green_over , Blue_over;
logic [9:0]  PlayerX, PlayerY, PlayerS, PlayerX2, PlayerY2, PlayerS2;
logic [9:0]  BulletX, BulletY, BulletS , level , score ,score2,score_tens ,score2_tens,score_hundreds ,score2_hundreds,BulletX2, BulletY2, BulletS2 ;
logic bullet_on , number_on , bullet_on2;
logic player_on ,player2_on;
logic ball_1_inplay,ball_2_inplay,ball_3_inplay,ball_4_inplay,ball_5_inplay,ball_6_inplay;
logic [9:0] BallXMotion1,BallYMotion1,BallXMotion2,BallYMotion2,BallXMotion3,BallYMotion3,BallXMotion4,BallYMotion4,Ball_size_1,Ball_size_2,Ball_size_3,Ball_size_4,Ball_size_5,Ball_size_6;
logic [1:0] game_on;
logic [3:0] Red_level_colour,Green_level_colour,Blue_level_colour, red_fire, blue_fire, green_fire;
logic [11:0] level_colour;
logic collision,bullet_hit_1,bullet_hit_2,bullet_hit_3,bullet_hit_4,bullet_hit_5,bullet_hit_6, power_possible, power_on;
logic [9:0] Ball_X_Max,Ball_X_Min;
logic play1_powerup, play2_powerup, collected_player1 , collected_player2;
logic [2:0] life;

ball ball_port(.Reset(Reset_h), .frame_clk(vs), .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig),.game_on(game_on),.bullet_hit(bullet_hit_1), .Ballxpos1(400), .Ballypos1(240) , .Ball_x_motion1(1) , .BallXMotion(BallXMotion1) , .BallYMotion(BallYMotion1),.ball_inplay(ball_1_inplay),.Ball_size_init(Ball_size_1),.level(level), .Ball_X_Max(Ball_X_Max) ,.Ball_X_Min(Ball_X_Min));
color_mapper cma_port(.BallX(ballxsig), .BallY(ballysig), .DrawX(DrawX), .DrawY(DrawY) , .Ball_size(ballsizesig), .Red(Red_ball), .Green(Green_ball), .Blue(Blue_ball) , .ball_on(ball_on) , .ball_inplay(ball_1_inplay));

ball ball_port_2(.Reset(Reset_h), .frame_clk(vs),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .BallX(ballxsig2), .BallY(ballysig2), .BallS(ballsizesig2),.game_on(game_on),.bullet_hit(bullet_hit_2), .Ballxpos1(ballxsig), .Ballypos1(ballysig) , .Ball_x_motion1(~BallXMotion1 + 1), .Ball_y_motion1(BallYMotion1), .BallXMotion(BallXMotion2) , .BallYMotion(BallYMotion2),.ball_inplay(ball_2_inplay),.Ball_size_init(Ball_size_2) , .level(level), .Ball_X_Max(Ball_X_Max) ,.Ball_X_Min(Ball_X_Min));
color_mapper cma_port_2(.BallX(ballxsig2), .BallY(ballysig2), .DrawX(DrawX), .DrawY(DrawY) , .Ball_size(ballsizesig2), .Red(Red_ball_2), .Green(Green_ball_2), .Blue(Blue_ball_2) , .ball_on(ball_on2) , .ball_inplay(ball_2_inplay));

ball ball_port_3(.Reset(Reset_h), .frame_clk(vs), .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .BallX(ballxsig3), .BallY(ballysig3), .BallS(ballsizesig3),.game_on(game_on),.bullet_hit(bullet_hit_3), .Ballxpos1(520), .Ballypos1(240) , .Ball_x_motion1(-1), .BallXMotion(BallXMotion3) , .BallYMotion(BallYMotion3),.ball_inplay(ball_3_inplay),.Ball_size_init(Ball_size_3) , .level(level), .Ball_X_Max(Ball_X_Max) ,.Ball_X_Min(Ball_X_Min));
color_mapper cma_port_3(.BallX(ballxsig3), .BallY(ballysig3), .DrawX(DrawX), .DrawY(DrawY) , .Ball_size(ballsizesig3), .Red(Red_ball_3), .Green(Green_ball_3), .Blue(Blue_ball_3) , .ball_on(ball_on3) , .ball_inplay(ball_3_inplay));

ball ball_port_4(.Reset(Reset_h), .frame_clk(vs),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .BallX(ballxsig4), .BallY(ballysig4), .BallS(ballsizesig4),.game_on(game_on),.bullet_hit(bullet_hit_4), .Ballxpos1(ballxsig3), .Ballypos1(ballysig3) , .Ball_x_motion1(~BallXMotion3 + 1), .Ball_y_motion1(BallYMotion3), .BallXMotion(BallXMotion4) , .BallYMotion(BallYMotion4),.ball_inplay(ball_4_inplay),.Ball_size_init(Ball_size_4) , .level(level), .Ball_X_Max(Ball_X_Max) ,.Ball_X_Min(Ball_X_Min));
color_mapper cma_port_4(.BallX(ballxsig4), .BallY(ballysig4), .DrawX(DrawX), .DrawY(DrawY) , .Ball_size(ballsizesig4), .Red(Red_ball_4), .Green(Green_ball_4), .Blue(Blue_ball_4) , .ball_on(ball_on4) , .ball_inplay(ball_4_inplay));

player_1 player(.vga_clk (pixel_clk),.Reset(Reset_h), .frame_clk(vs),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .PlayerX(PlayerX), .PlayerY(PlayerY), .PlayerS(PlayerS), .DrawX(DrawX) , .DrawY(DrawY) , .player_on(player_on) ,.game_on(game_on) , .Red(Red_player), .Green(Green_player), .Blue(Blue_player) , .level(level),.collision(collision));
player_2 player2(.vga_clk (pixel_clk),.Reset(Reset_h), .frame_clk(vs),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4), .PlayerX(PlayerX2), .PlayerY(PlayerY2), .PlayerS(PlayerS2), .DrawX(DrawX) , .DrawY(DrawY) , .player_on(player2_on) ,.game_on(game_on) , .Red(Red_player2), .Green(Green_player2), .Blue(Blue_player2) , .level(level) , .player_2_inplay(player_2_inplay) , .right(7) , .left(4) ,.collision2(collision2));

control abc(.lives(life), .cont(cont),.Clk(vs),.Reset(Reset_h),.BallX(ballxsig), .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4),.Bally(ballysig) , .BallSize(ballsizesig),.PlayerX(PlayerX),.PlayerY(PlayerY) , .PlayerSize(PlayerS) , .on(game_on) , .ball_on(ball_on2),.player_on(player_on) , .collide(collision) , .DrawX(DrawX) , .DrawY(DrawY) , .bullet_hit_1(bullet_hit_1), .bullet_hit_2(bullet_hit_2), .bullet_hit_3(bullet_hit_3), .bullet_hit_4(bullet_hit_4), .bullet_hit_5(bullet_hit_5), .bullet_hit_6(bullet_hit_6), .ball_1_inplay(ball_1_inplay),.ball_2_inplay(ball_2_inplay),.ball_3_inplay(ball_3_inplay),.ball_4_inplay(ball_4_inplay),.ball_5_inplay(ball_5_inplay),.ball_6_inplay(ball_6_inplay),.Ball_size_1(Ball_size_1),.Ball_size_2(Ball_size_2),.Ball_size_3(Ball_size_3),.Ball_size_4(Ball_size_4),.Ball_size_5(Ball_size_5),.Ball_size_6(Ball_size_6) , .level_up(level_up),.score(score) , .level(level), .cur_pos(cur_pos), .player_2_inplay(player_2_inplay), .power_possible(power_possible) , .collide2(collision2));

powerup powerup1(.level(level),.Reset(Reset_h), .frame_clk(vs), .pixel_clk(pixel_clk), .power_possible(power_possible), .game_on(game_on), .DrawX(DrawX), .DrawY(DrawY), .power_on(power_on), .collected_player1(collected_player1) , .collected_player2(collected_player2) ,.red(Red_pow) , .blue(Blue_pow) , .green(Green_pow));

fire_example its_fire(.vga_clk(pixel_clk), .DrawX(DrawX), .DrawY(DrawY), .lives(life), .red(red_fire), .green(green_fire), .blue(blue_fire), .lives_on(lives_on));

background level1(	.vga_clk (pixel_clk),
								.DrawX   (DrawX), 
								.DrawY   (DrawY),
								.blank   (blank),
								.red     (Red_back),
								.green   (Green_back),
								.blue    (Blue_back),
								.hs(hs),
								.red_back(Red_level_colour),
								.green_back(Green_level_colour),
								.blue_back(Blue_level_colour),
								.level(level));

go_example game_over(	.vga_clk (pixel_clk),
								.DrawX   (DrawX), 
								.DrawY   (DrawY),
								.blank   (blank),
								.red     (Red_over),
								.green   (Green_over),
								.blue    (Blue_over));

levelscore levelprint(	.vga_clk (pixel_clk),
								.DrawX   (DrawX), 
								.DrawY   (DrawY),
								.blank   (blank),
								.red     (Red_num),
								.green   (Green_num),
								.blue    (Blue_num),
								.level(level),
								.score(score),
								.score2(score2),
								.score_tens(score_tens),
								.score2_tens(score2_tens),
								.score_hundreds(score_hundreds),
								.score2_hundreds(score2_hundreds),
								.number_on(number_on));
								
bullet player_1_bullet(.shoot(44),.Reset(Reset_h), .frame_clk(vs), .pixel_clk(pixel_clk),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4),.game_on(game_on),.PlayerX(PlayerX), .PlayerY(PlayerY), .PlayerS(PlayerS),.BulletX(BulletX), .BulletY(BulletY), .BulletS(BulletS),.bullet_on(bullet_on),.DrawX(DrawX) , .DrawY(DrawY) , .bullet_hit_1(bullet_hit_1), .bullet_hit_2(bullet_hit_2), .bullet_hit_3(bullet_hit_3), .bullet_hit_4(bullet_hit_4), .bullet_hit_5(bullet_hit_5), .bullet_hit_6(bullet_hit_6), .powerup(play1_powerup), .player(1) , .collected_player1(collected_player1),.collected_player2(collected_player2), .inplay(1) ,.collision(collision));
bullet player_2_bullet(.shoot(26),.Reset(Reset_h), .frame_clk(vs), .pixel_clk(pixel_clk),  .keycode(keycode), .keycode2(keycode2), .keycode3(keycode3), .keycode4(keycode4),.game_on(game_on),.PlayerX(PlayerX2), .PlayerY(PlayerY2), .PlayerS(PlayerS2),.BulletX(BulletX2), .BulletY(BulletY2), .BulletS(BulletS2),.bullet_on(bullet_on2),.DrawX(DrawX) , .DrawY(DrawY) , .bullet_hit_1(bullet_hit_1), .bullet_hit_2(bullet_hit_2), .bullet_hit_3(bullet_hit_3), .bullet_hit_4(bullet_hit_4), .bullet_hit_5(bullet_hit_5), .bullet_hit_6(bullet_hit_6), .powerup(play2_powerup), .player(2) , .collected_player1(collected_player1),.collected_player2(collected_player2),  .inplay(player_2_inplay) ,.collision(collision2));
always_ff@(posedge vs)
begin
	
	Ball_X_Max <= 50;
	Ball_X_Min <= 590;
	
	if(game_on == 0)
	begin
		level <= 1;
		score <= 0;
		score2 <= 0;
		score_tens <= 0;
		score2_tens <= 0;
		score_hundreds <= 0;
		score2_hundreds <= 0;
	end
	else if(level_up)
	begin
		Red_level_colour <= level_colour[11:8];
		Green_level_colour <= level_colour[7:4];
		Blue_level_colour <= level_colour[3:0];
		level <= level + 1;
	end
	else if(player1hit)
	begin
		if((score % 10) == 9)
			score_tens <= score_tens + 1;
		if(((score_tens % 10) == 9) && ((score % 10) == 9))
			score_hundreds <= score_hundreds + 1;
			
		score <= score + 1;
	end
	else if(player2hit)
	begin
		if((score2 % 10) == 9)
			score2_tens <= score2_tens + 1;
		if(((score2_tens % 10) == 9) && ((score2 % 10) == 9))
			score2_hundreds <= score2_hundreds + 1;
		score2 <= score2 + 1;
	end
end

always_ff@(posedge pixel_clk)
begin
	if (player_on && power_on)
	begin
		play1_powerup <= 1'b1;
		end
	else if (player2_on && power_on)
	begin
		play2_powerup <= 1'b1;
		end
	else
		begin
			play1_powerup <= 0;
			play2_powerup <= 0;
		end
end

always_ff@(posedge pixel_clk)
begin

	level_colour <= level_colour + 1;
	
	if (power_on && player_on && ~collected_player2)
		collected_player1 <= 1'b1;
		
	else if (power_on && player2_on && ~collected_player1)
		collected_player2 <= 1'b1;
	
	if((player_on & ball_on))
		collision <= 1;
	else if((player2_on & ball_on))
		collision2 <= 1;
	
	else if((player_on & ball_on2))
		collision <= 1;
	else if((player2_on & ball_on2))
		collision2 <= 1;
	
	else if((player_on & ball_on3))
		collision <= 1;
	else if((player2_on & ball_on3))
		collision2 <= 1;
	
	else if((player_on & ball_on4))
		collision <= 1;
	else if((player2_on & ball_on4))
		collision2 <=1;
	
	else if((ball_on & bullet_on))
	begin
		bullet_hit_1 <= 1;
		player1hit <= 1;
	end
		
	else if (ball_on & bullet_on2)
	begin
		bullet_hit_1 <= 1;
		player2hit <= 1;
	end
		
	else if(ball_on2 & bullet_on & ~bullet_hit_1)
	begin
		bullet_hit_2 <= 1;
		player1hit <= 1;
	end
	
	else if (ball_on2 & bullet_on2 & ~bullet_hit_1)
	begin
		bullet_hit_2 <= 1;
		player2hit <= 1;
	end
	
	else if(ball_on3 & bullet_on & ~bullet_hit_1 & ~bullet_hit_2)
	begin
		bullet_hit_3 <= 1;
		player1hit <= 1;
	end
	
	else if (ball_on3 & bullet_on2 & ~bullet_hit_1 & ~bullet_hit_2)
	begin
		bullet_hit_3 <= 1;
		player2hit <= 1;
	end
		
	else if(ball_on4 & bullet_on & ~bullet_hit_1 & ~bullet_hit_2 & ~bullet_hit_3)
	begin
		bullet_hit_4 <= 1;
		player1hit <= 1;
	end
		
	else if(ball_on4 & bullet_on2 & ~bullet_hit_1 & ~bullet_hit_2 & ~bullet_hit_3)
	begin
		bullet_hit_4 <= 1;
		player2hit <= 1;
	end
	
	else if(DrawX == 0 && DrawY == 0)
	begin
		bullet_hit_1 <= 0;
		bullet_hit_2 <= 0;
		bullet_hit_3 <= 0;
		bullet_hit_4 <= 0;
		player1hit <= 0;
		player2hit <= 0;
	end 
	else if(game_on == 0)
	begin
		   collision <=0;
			collision2 <=0;
			collected_player1<= 0;
			collected_player2 <= 0;
	end
	
	else if(level_up == 1)
	begin
			collected_player1<= 0;
			collected_player2 <= 0;
	end
	
	else if(cont)
		collision <=0;
			
end
logic up_flag;
logic down_flag;

always_ff@(posedge vs)
begin
	half_vga_clk <= half_vga_clk + 1;
	if(game_on)
		cur_pos <= 0;
	else if(~half_vga_clk[2] && ~half_vga_clk[1] && ~half_vga_clk[0] && (keycode == 81 || keycode2 == 81 || keycode3 == 81 || keycode4 == 81) && cur_pos < 46)
		cur_pos <= cur_pos + 46;
	else if(~half_vga_clk[2] && ~half_vga_clk[1] && ~half_vga_clk[0] && (keycode == 82 || keycode2 == 82 || keycode3 == 82 || keycode4 == 82) && cur_pos)
		cur_pos <= cur_pos - 46;
end
always_ff@(posedge pixel_clk)
begin
	if(~blank)
	begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end
	else
	begin
		if(game_on == 1)
		begin
			 if(number_on == 1'b1)
			 begin
				red <= Red_num;
				green <= Green_num;
				blue <= Blue_num;
			 end
			 else if(player_on == 1'b1)
			begin
				red <= Red_player;
				green <= Green_player;
				blue <= Blue_player;
			end
			
			else if(player2_on == 1'b1)
			begin
				red <= Red_player2;
				green <= Green_player2;
				blue <= Blue_player2;
			end
			
			else if(power_on == 1'b1)
			begin
				red <= Red_pow;
				green <= Green_pow;
				blue <= Blue_pow;
			end
			
			else if(bullet_on == 1'b1)
			begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end
			else if(bullet_on2 == 1'b1)
			begin
				red <= 4'h0;
				green <= 4'h0;
				blue <= 4'hf;
			end
			
			else if(ball_on == 1'b1)
			begin
				red <= Red_ball[7:4];
				green <= Green_ball[7:4];
				blue <= Blue_ball[7:4];
			end
			else if(ball_on2 == 1)
			begin
				red <= Red_ball_2[7:4];
				green <= Green_ball_2[7:4];
				blue <= Blue_ball_2[7:4];
			end
			else if(ball_on3 == 1)
			begin
				red <= Red_ball_3[7:4];
				green <= Green_ball_3[7:4];
				blue <= Blue_ball_3[7:4];
			end
			else if(ball_on4 == 1)
			begin
				red <= Red_ball_4[7:4];
				green <= Green_ball_4[7:4];
				blue <= Blue_ball_4[7:4];
			end
			else if (lives_on == 1'b1 && player_2_inplay == 0)
				begin
					red  <= red_fire;
					blue <= blue_fire;
					green <= green_fire;
				end
			else
			begin
				red <= Red_back;
				green <= Green_back;
				blue <= Blue_back;
			end
		end
		
		else if(game_on == 0)
		begin
			if(half_vga_clk[3])
			begin
				red <= Red_bubble;
				green <= Green_bubble;
				blue <= Blue_bubble;
			end
			else 
			begin
				if(DrawX > 80 && DrawX<230 && DrawY >= (220 + cur_pos) && DrawY <= (222 + cur_pos))
				begin
					red <= 4'hf;
					blue <= 4'h0;
					green <= 4'hf;
				end
				else if(DrawX > 80 && DrawX<230 && DrawY <= (270 + cur_pos) && DrawY >= (268 + cur_pos))
				begin
					red <= 4'hf;
					blue <= 4'h0;
					green <= 4'hf;
				end
				else if(DrawY > (220 + cur_pos) && DrawY< (270 + cur_pos) && DrawX <= 82 && DrawX >= 80)
				begin
					red <= 4'hf;
					blue <= 4'h0;
					green <= 4'hf;
				end
				else if(DrawY > (220 + cur_pos) && DrawY< (270 + cur_pos) && DrawX >= 228 && DrawX <= 230)
				begin
					red <= 4'hf;
					blue <= 4'h0;
					green <= 4'hf;
				end
				else
				begin
					red <= Red_bubble;
					green <= Green_bubble;
					blue <= Blue_bubble;
				end
			end
		end
		
		else
		begin
				red <= Red_over;
				green <= Green_over;
				blue <= Blue_over;
		end
	end
end

endmodule

