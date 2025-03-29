 //-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [7:0]  Red, Green, Blue,
							  input logic ball_inplay,
							 output logic ball_on );
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 logic ball_edge;
	  
    always_comb
    begin:Ball_on_proc
		  if(ball_inplay == 0)
		  begin
				ball_on = 0;
				ball_edge = 0;
		  end
		  
        else if ( ( DistX*DistX + DistY*DistY) < (Size * Size) && Size >= 10)
		  begin
            ball_on = 1'b1;
				ball_edge = 0;
		  end
		  
		  else if ( ( DistX*DistX + DistY*DistY) < ((Size + 2) * (Size + 2)) && Size >= 10)
		  begin
            ball_edge = 1'b1;
				ball_on = 1'b1;
		  end
		  
        else 
			begin
				ball_edge = 1'b0;
            ball_on = 1'b0;
		  end
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1) && ball_edge == 0) 
        begin 
            Red = 8'hff;
            Green = 8'h28;
            Blue = 8'h28;
        end
		  else if(ball_edge == 1)
        begin 
            Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
        end  
		  
        else 
        begin 
            Red = 8'hff;
            Green = 8'h28;
            Blue = 8'h28;
        end      
    end 
    
endmodule

module  ball ( input Reset, frame_clk,
					input [7:0] keycode,keycode2,keycode3,keycode4,
					input [1:0] game_on,
					input [9:0] level,
					input [9:0] Ball_X_Max,Ball_X_Min,
					input ball_inplay,
					input [9:0] Ballxpos1, Ballypos1,Ball_x_motion1,Ball_y_motion1,Ball_size_init,
					input bullet_hit,
               output [9:0]  BallX, BallY, BallS , BallXMotion,BallYMotion );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
//	 logic [4:0] timer;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=180;  // 240  - original Center position on the Y axis
    parameter [9:0] Ball_x_min_wall=170;       // Leftmost point on the X axis
	 parameter [9:0] Ball_x_min=50;       // Leftmost point on the X axis
    parameter [9:0] Ball_x_max=590;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=250;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=398;     // Bottommost point on the Y axis
    logic     [1:0] Ball_X_Step;      // Step size on the X axis
    logic     [1:0] Ball_Y_Step;      // Step size on the Y axis
	 
//	 logic [9:0] Ball_x_max,Ball_x_min;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_X_Pos <= Ballxpos1; // Ball_X_Center;
				Ball_Y_Pos <= Ballypos1; //Ball_Y_Center;
//				timer <= 4'b0000;
        end
           
		  else if(game_on == 0 || ball_inplay == 0)
		  begin
					Ball_X_Motion <= Ball_x_motion1;
					Ball_Y_Motion <= Ball_y_motion1;
					Ball_X_Pos <= Ballxpos1; //Ball_X_Center;
					Ball_Y_Pos <= Ballypos1; //Ball_Y_Center;
					Ball_Size <= Ball_size_init;
					Ball_X_Step <= 1;
					Ball_Y_Step <= 2;
//					Ball_x_max <= Ball_X_Max;
//					Ball_x_min <= Ball_X_Min;
		  end
			  
		  else if(bullet_hit)
					Ball_Size <= Ball_Size/2;
			  
        else 
        begin
//				 if (Ball_Y_Pos <= (Ball_Y_Center - 20))
//						Ball_Y_Step <= 2'b01;
//				 else if (Ball_Y_Pos <= (Ball_Y_Center + 40))
//						Ball_Y_Step <=2'b10;
//				 else 
//						Ball_Y_Step <=2'b11;
//						
						
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion <= ((~Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
					  
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_x_max )  // Ball is at the Right edge, BOUNCE!
					  Ball_X_Motion <= ((~Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_x_min_wall && (level == 4 || level == 5 || level == 6))  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_x_min )  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;
					  
				 else 
				 begin
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  Ball_X_Motion <= Ball_X_Motion;
				 end
				 
				 if(level == 3 || level >= 5)
				 begin
					Ball_X_Step <= 3;
					Ball_Y_Step <= 3;
				 end
				 else
				 begin
					Ball_X_Step <= 1;
					Ball_Y_Step <= 2;
				 end
				 
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion) ;
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				 	
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
	 
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 assign BallXMotion = Ball_X_Motion;
	 
	 assign BallYMotion = Ball_Y_Motion;
    

endmodule

