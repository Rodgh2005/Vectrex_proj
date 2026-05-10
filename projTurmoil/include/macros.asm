





INTRO_BOOT		macro
introSplash
				lda #1
				sta Demo_Mode
			
				

				endm

RESTART			macro
				;lda #$20
				;sta shipXpos
				lda #$0
				sta shipYpos
				sta shipXpos
				sta In_Alley
				sta Ship_Dead
				ldb #LEFT
				stb shipdir
				

				endm



;{{{ DRAW_LINE_WALLS
ALLEYWALL_Y         EQU        60 
ALLEYHEIGHT         EQU        17 

DRAW_LINE_WALLS     macro    

					
                    lda      #$3F 
                    jsr 	 Intensity_5F  
                    clr      Vec_Misc_Count 
                    rol      Line_Pat                     ; 1->2->4->8->16-> etc 
                    bne      _topline                     ; check for 0 
                    inc      Line_Pat                     ; if it's zero set to 1 ie reset it 
                    jsr      Reset0Ref  
_topline 
                    lda      #(ALLEYWALL_Y) 
                    ldb      #-128 
                    jsr      Moveto_d                                 ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$007F                       ; start far left, end middle 
                    jsr      Draw_Line_d   
                    LDD      #$007F                       ; start middle, end far right 
                    jsr      Draw_Line_d   
_toplineEnd 
                    jsr      Reset0Ref 
_line1 
				
                    lda      #(ALLEYWALL_Y - (ALLEYHEIGHT*1) ) 
                    ldb     #-127 
                    jsr      Moveto_d                                   ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074  
                    jsr      Draw_Line_d                          ; dotted line 
                    LDD      #$0016 
                    jsr      Moveto_d                                   ; alley gap 
                    ldd      #$007F 
                    jsr      Draw_Line_d                          ; dotted line 
					
					
					
					


					
_line1End 
                   jsr      Reset0Ref   
_line2 
                    lda      #(ALLEYWALL_Y - (ALLEYHEIGHT*2) ) 
                    ldb      #-127 
                     jsr      Moveto_d                                  ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    jsr      Draw_Line_d    
                    LDD      #$0016 
                    jsr      Moveto_d                                  ; alley gap 
                    ldd      #$0074 
                    jsr      Draw_Line_d    
_line2End 
                    jsr      Reset0Ref   
_line3 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*3)) 
                    ldb      #-127 
                    jsr      Moveto_d                                  ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    jsr      Draw_Line_d    
                    LDD      #$0016 
                    jsr      Moveto_d                                   ; alley gap 
                    ldd      #$007F 
                    jsr      Draw_Line_d   
_line3End 
                    jsr      Reset0Ref   
_line4 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*4)) 
                    ldb      #-127 
                    jsr      Moveto_d                                   ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    jsr      Draw_Line_d    
                    LDD      #$0016 
                    jsr      Moveto_d                                  ; alley gap 
                    ldd      #$007F 
                    jsr      Draw_Line_d    
_line4End 
                    jsr      Reset0Ref   
_line5 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*5)) 
                    ldb      #-127 
                     jsr      Moveto_d                                  ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    jsr      Draw_Line_d    
                    LDD      #$0016 
                    jsr      Moveto_d                                   ; alley gap 
                    ldd      #$007F 
                    jsr      Draw_Line_d  
_line5End 
                    jsr      Reset0Ref   
_line6 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*6)) 
                    ldb      #-127 
                    jsr      Moveto_d                                  ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                     jsr      Draw_Line_d    
                    LDD      #$0016 
                     jsr      Moveto_d                                  ; alley gap 
                    ldd      #$007F 
                    jsr      Draw_Line_d  
_line6End 
                    jsr      Reset0Ref   
_bottomLine 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*7)) 
                    ldb      #-127 
                    jsr      Moveto_d                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$007F 
                    jsr      Draw_Line_d   
                    ldd      #$007F                       ; start far left end far right 
                    jsr      Draw_Line_d  
					
					
                    endm   
					
					
					
					
Line_Pat            EQU       #01                            ; this is for LINE_DRAW_D stuff , 00000000 is nothing 11111111 is line 10101010 is dotted line 

clrd                macro    
                    ldd      #$0000 
                    endm  					
					
					
DRAW_SHIP			macro
				;draw ship
					jsr Reset0Ref
					lda #127
					sta VIA_t1_cnt_lo ;controls 'scale'
			
					lda shipYpos
					
					ldx #bulletYpos_t
					lda a,x
					ldb shipXpos
					
					jsr Moveto_d
					
					;test if we are dead
					lda #127
					sta VIA_t1_cnt_lo
					lda Ship_Dead
					bne _is_dead
					bra scale_done
					
_is_dead
					ldb Ship_Dead_Anim
					bne ship_shrink
					lda Ship_Dead_Cnt
					inc Ship_Dead_Cnt
					inc Ship_Dead_Cnt
					bra ship_grow
ship_shrink
					lda Ship_Dead_Cnt
					dec Ship_Dead_Cnt
					dec Ship_Dead_Cnt
ship_grow
					
					sta VIA_t1_cnt_lo
scale_done			
					lda Ship_Dead_Cnt
					bmi change_dir
					cmpa #126
					bne shitballs
					clr Ship_Dead
					clr Ship_Dead_Cnt
					clr shipXpos
					clr In_Alley
change_dir
					lda Ship_Dead_Cnt
					cmpa #0
					beq dontplaysound
					;jsr SFX_Undead
dontplaysound      
					clr shipXpos
					clr Ship_Dead_Anim
					clr Ship_Dead_Cnt
					;CHECK_GAMEOVER
shitballs
					ldx #ShipL_nomode
					ldb shipdir
					beq _donuthin1
					ldx #ShipR_nomode
_donuthin1
					jsr Draw_VLc
					
					endm
					
					
READ_JOYSTICK		macro
					lda 	Ship_Dead
					lbne  	jsdone
					;not demo mode
not_demo_rjs
					lda 	shipspeed
					lsla
					ldx 	#speed_t
					lda 	[a,x]
					bne 	jsdoneY		;slowing down Y movement by half for more control
					jsr     Joy_Digital
					lda 	In_Alley     ;inside an alley?
					bne     jsdoneY		;disble Y position poll
					lda		Vec_Joy_1_Y
					beq     jsdoneY
					bmi		going_down
					lda 	shipYpos
					cmpa	#6
					beq     jsdoneY
;going_up
					;jsr		SFX_VertMove
					inc     shipYpos
					clr     stallcnt
					bra     jsdoneY
					
going_down
					lda     shipYpos
					beq     jsdoneY
					;jsr     SFX_VertMove
					dec     shipYpos
					clr     stallcnt
					
jsdoneY
					lda 	In_Alley
					bne 	already_in
					lda 	shipYpos
					lsla    
					ldx     #alleye_t
					ldb     [a,x]
					cmpa    #PRIZE		;is there a prize in alley?
					bne     nope_prize
					lda		Vec_Joy_1_X
					beq     jsdoneX
					inc     In_Alley
					bmi     going_left1
going_right1
					lda     #RIGHT
					sta     shipdir
					lda     #8
					adda    shipXpos
					bra     jsdoneX
going_left1
					lda    #LEFT
					sta    shipdir
					suba   #8
					sta    shipXpos
					bra    jsdoneX
nope_prize
already_in       
					lda    Vec_Joy_1_X
					beq    jsdoneX
					bmi    going_left
going_right        
                    lda    #RIGHT
					sta    shipdir
					lda    In_Alley
					beq    setRightDone
					lda    #4
					adda   shipXpos
					bvs    setMaxRight
		;centering code
					tsta
					bpl     setRightDone
					cmpa   #-7
					blt    setRightDone
					clr    In_Alley
					clra
					
		;end center
					bra    setRightDone
setMaxRight 
                    lda      #110 
setRightDone 
                    sta      shipXpos 
                    bra      jsdoneX 

going_left 
                    lda      #LEFT 
                    sta      shipdir 
                    lda      In_Alley 
                    beq      setLeftDone 
                    lda      shipXpos 
                    suba     #4 
                    bvs      setMaxLeft                   ; branch on overflow set 
; centering code here 
                    tsta     
                    bmi      setLeftDone 
                    cmpa     #7                           ; if ship is closer than 5 
                    bgt      setLeftDone                  ; center it on screen 
                    clr      In_Alley                     ; and remove from In_Alley 
                    clra                                  ; saved to shipXpos later 
; center done 
                    bra      setLeftDone 

setMaxLeft 
                    lda      #-110 
setLeftDone 
                    sta      shipXpos 
jsdoneX 
					
					
					
					
					
					
jsdone
					endm