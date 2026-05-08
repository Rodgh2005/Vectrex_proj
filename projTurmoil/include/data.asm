

Tank_69 ;test CURVY shape(s)

				fcb -127, 1			; Y start ?, "on off" I think only 1 bit counts?
			
				fcb 127,-127,100,-100,60,-60,20,-20,127,0
				fcb -127, 1			; Y start ?, "on off" I think only 1 bit counts?
				fcb -127,-127,127,-127,127,-127,127, -127,127,0
				fcb -127, 1			; Y start ?, "on off" I think only 1 bit counts?
				fcb -127,-127,127,-127,127,-127,127, -127,127,0
				fcb -127, 1			; Y start ?, "on off" I think only 1 bit counts?
				fcb 127,-127,127,-127,127,-127,127,-127,127,0
				fcb 10, 33 , -10, 36 ,40, 1,60,70,1,90,100, -90,-1,-90,-95,-1,-20, -10, 127, 0 ; 0 = end
				fcb 0
				
Tank_70:
		         fcb 1, 1, 127,0
		         fcb 1, 1, -127,0
		         fcb 1, 1, 127,0
		         fcb 1, 1, -127,0
		         fcb 1, 1, 127,0

				 
SHIP_SCALE EQU 1
ShipR_nomode:       fcb      9 
                    fcb      +0, +21*SHIP_SCALE           ; was 10 
                                                          ; fcb +1*SHIP_SCALE, 0*SHIP_SCALE ; center Move this to end ? 
                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE ; tip 
                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE ; upper left corner 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE 
ShipL_nomode:       fcb      9 
                    fcb      +0, -21*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE ; tip 
                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE ; upper right corner 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE 
				 
			 
BULLETYPOS         EQU        103                          ;; trail and error for top alley 
bulletYpos_t        fcb      BULLETYPOS-(ALLEYHEIGHT*6*2), BULLETYPOS-(ALLEYHEIGHT*5*2), BULLETYPOS-(ALLEYHEIGHT*4*2), BULLETYPOS-(ALLEYHEIGHT*3*2), BULLETYPOS-(ALLEYHEIGHT*2*2),BULLETYPOS-(ALLEYHEIGHT*1*2), BULLETYPOS-(ALLEYHEIGHT*0*2) 




speed_t             fdb       fmt0cnt, fmt1cnt, frm2cnt, frm3cnt, frm4cnt, frm5cnt,0,0,0,0,frm10cnt ; which frame to do enemy moves on 
alleye_t            fdb      alley0e,alley1e,alley2e,alley3e,alley4e,alley5e,alley6e ; exists + type code 


