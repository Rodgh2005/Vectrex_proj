
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;https://github.com/bahorn/AstonHack2017/tree/master



Dot_d			EQU			0xF2C3
Dot_here		EQU			0xF2C5
Dot_ix_b		EQU			0xF2BE
Dot_ix			EQU			0xF2C1
Dot_List		EQU			0xF2D5
Dot_List_Reset	EQU		0xF2DE

Vec_Dot_Dwell	EQU		0xC828
Vec_Misc_Count	EQU		0xC823
Delay3			EQU		    0xF56D
VIA_t1_cnt_lo	EQU		0xD006

Draw_VLc        			equ     0xF3CE
Moveto_d  			    equ     0xF312


Reset0Int         			equ     0xF36B

Random_3        			equ     0xF511

Intensity_5F	  		  	EQU		0xF2A5
Print_Str_d				EQU		0xF37A
Wait_Recal				EQU		0xF192
musicd						EQU		0xFD0D
Vec_Text_Height		EQU   	0xC82A
Vec_Text_Width	 		EQU		0xC82B
Draw_Line_d      		equ       0xF3DF

VIA_port_b      			equ     0xD000 
VIA_port_a      			equ     0xD001 
VIA_shift_reg   			equ     0xD00A
VIA_int_flags   			equ     0xD00D
VIA_cntl        			equ     0xD00C 
Reset0Ref       			equ     0xF354

Vec_Joy_Mux_1_X 	equ     0xC81F   ;Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y 		equ     0xC820   ;Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X 	equ     0xC821   ;Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y 		equ     0xC822   ;Joystick 2 Y enable/mux flag (=7)

Vec_Music_Flag  		equ     0xC856  
Clear_Score     			equ     0xF84F 
Read_Btns       			equ     0xF1BA 

Joy_Digital     			equ     0xF1F8
Vec_Joy_1_X     		equ     0xC81B   ;Joystick 1 left/right
Add_Score_a     		equ     0xF85E

New_High_Score  		equ     0xF8D8
Draw_VLp                  equ     0xF410   ;pattern y x pattern y x ... 0x01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ram starts at $C880 til $CBEA
high_score				EQU $CBEB	;7 bytes at system memory
player_score				EQU $C880 ;7 bytes for player score

player_x					EQU player_score+7
player_y					EQU player_x+1
bullet_active				EQU player_y+1
bullet_x						EQU bullet_active+1
bullet_y						EQU bullet_x+1
count						EQU bullet_y+1
speed						EQU count+1
player_speed				EQU speed+1
temp							EQU player_speed+1
killed						EQU temp+1
enemy_x					EQU killed+1
enemy_y					EQU enemy_x+1
enemy_x_2				EQU enemy_y+1
enemy_y_2				EQU	enemy_x_2+1
alley0e						EQU  enemy_y_2+1   ;;stack inimigo
alley0d                      EQU  alley0e+1        ;;direcao inimigo
Arrow_f                     equ   alley0d + 1
None_f						equ  Arrow_f + 1
enemy0d					equ  None_f + 1
enemy0x					equ  enemy0d + 1


DEBUG1			macro
				    LDU #any_key_string1
					LDA #-$60
					LDB #-$50
					JSR Print_Str_d
			    endm
DEBUG2			macro
				    LDU #any_key_string2
					LDA #-$60
					LDB #-$50
					JSR Print_Str_d
			    endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			ORG 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			 ; ORG 0xC880
			 FCC "g GCE 2017"
			 FCB 0x80
			 FDB musicd
			 FCB 0xF8, 0x50, 0x20, -0x45
			 FCC "GHOST ATTACK"
			 FCB 0x80
			 FCB 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




init
			;set up joystick
			LDA #1
			STA Vec_Joy_Mux_1_X
			LDA #3
			STA Vec_Joy_Mux_1_Y
			LDA #0
			STA	Vec_Joy_Mux_2_X
			STA	Vec_Joy_Mux_2_Y
			;set up the high score table
			LDX #player_score
			JSR Clear_Score
			LDX #high_score
			JSR Clear_Score
			LDA #1
			STA Vec_Music_Flag
			JMP title_screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





init_game

			LDA #1
			STA alley0e                 ;escolhe o inimigo
			sta   enemy0d	         ;direcao inimigo
			LDA #1
			sta  alley0d               ;direcao inimigo
			STA count
			LDA #0
			STA player_x
			LDA #-$60
			STA player_y
			LDA #0
			sta enemy0x      ;posicaqo x inimigo
			sta      Arrow_f
			sta      None_f 
			STA	bullet_active
			STA	bullet_x
			STA bullet_y
			;set some enemies on the stack
			;JSR new_enemy
			
			LDA #1
			STA speed
			;clear score
			LDX #player_score
			LDA #0
			STA killed
			
			LDA #2
			STA player_speed

    ; No Loop Principal
Main_Loop:
			;; check status
				
			LDB #0
			CMPB bullet_active
			BEQ no_bullet
			LDB #$75  ;75 altura da onde vai a bala
			CMPB bullet_y
			BGT in_frame
			LDA #0
			STA bullet_active
			BRA no_bullet
in_frame	
			LDA bullet_y
			ADDA #10 			;velocidade da bala
			STA bullet_y
no_bullet	
			;now update enemy position
		;	LDA enemy_y 
		;	SUBA speed       			; o inimigo esta a cair (baixo)
		;	STA enemy_y
		;	LDB #-$7A					;distancia onde chega o inimigo
		;	CMPB enemy_y
		;	BGT bottom					;verdade entao vai para bottom
		;	BRA collisions

		
		
		
		
		
		
		

		
		
		
		
		lda enemy0d
		CMPA #1
		BEQ  moveleft_
		
       
	    CMPA #0
		BEQ moveright_
		BRA collisions
		
		
		
		
		
	;	ADDA speed   
			;STA enemy0x
			;LDB #$78					;distancia onde chega o inimigo
			;CMPB enemy0x
			;BGT teste2					;verdade entao vai para bottom
	;	BRA collisions
moveleft_
			
		     
		    lda enemy0x			
			SUBA speed       			; o inimigo esta a cair (baixo)
			;ADDA speed
			STA enemy0x
			JSr Random_3
			
			LDB #-60					;distancia onde chega o inimigo
			CMPB enemy0x
	;	lda enemy0x
	;	cmpa #-78
			BGT dir_0
			BRA collisions			
dir_0
			lda #0
			sta enemy0d
			
			
			bra fim
moveright_
            lda enemy0x
			ADDA speed   
			STA enemy0x
			jsr Random_3
			cmpa enemy0x
			bgt dir1
			lda enemy0x
			cmpa #40
			bgt dir1
			
			
			
			;lbeq teste2
			;LDB #-$7A					;distancia onde chega o inimigo
			;CMPB enemy0x
		;	BGT teste2				
			BRA collisions
			
			
dir1           

         lda #1
		 sta enemy0d
		
fim

			
;bottom
			
;			JSR Random_3				;cria aleatoriamente a posicao do novo inimigo	
;			STA enemy_x
;			LDB #$75					;volta a posicionar o no topo
;			STB enemy_y
		;	JMP game_over				;acaba o jogo
		
		
		
collisions
			LDA bullet_active
			CMPA #00
			BEQ input
					
			LDA enemy_x
			ADDA #10
			SUBA bullet_x
			BVS input
			LSRA
			CMPA #10
			BGT input
						
			LDA enemy_y
			LDB bullet_y
			SUBB #12
			STB temp
			CMPA temp
			BGT input
			
bad
			INC killed
			LDA killed
			CMPA #5
			BEQ killed_5
			CMPA #15
			BEQ killed_15
			BRA after
killed_5
			LDA #2
			STA speed
			BRA after
killed_15   
			LDA #3
			STA speed
			LDA #3
			STA player_speed
after
			LDA #100
			LDX #player_score
			JSR Add_Score_a
			LDA #0
			STA bullet_active
			LDA #-$7f
			STA bullet_y
			;JSR new_enemy
input 
			;;read input left/right move
			JSR Joy_Digital
			LDA Vec_Joy_1_X
			BEQ no_movement
			BMI left_movement
right_movement
			LDA player_x
			ADDA player_speed
			STA player_x
			BRA movement_done
left_movement
			LDA player_x
			SUBA player_speed
			STA player_x
			BRA movement_done
no_movement
			; do nothing
movement_done
			;used to check if we are firing a bullet
			JSR Read_Btns
			;check if we are firing
			BITA #$01
			BEQ no_button
			; preform creating on object here
			LDA #01
			CMPA bullet_active
			BEQ no_button
			LDA player_x
			;ADDA #5
			STA bullet_x
			LDA player_y
			STA bullet_y
			LDA #1
			STA bullet_active
no_button
          
			;;display everything
			JSR Wait_Recal
		
			LDA #10
			LDA VIA_t1_cnt_lo
			JSR Intensity_5F
			;Draw score first
			LDU #player_score
			LDA #$7f
			LDB #-$80
			JSR Print_Str_d
			;Draw the player
			;first, move to the pointer to player_x, player_y
			;display the enemies
			LDA player_y
			LDB player_x
			JSR Moveto_d
			LDX #player_sprite
			JSR Draw_VLc
			;now lets cycle through the list of enemies on the screen and displhay them.
			;draw our bullet if we have one.
			LDB #0
			CMPB bullet_active
			BEQ done
			JSR Reset0Int
			LDA bullet_y
			LDB bullet_x
			JSR Moveto_d
			LDX #bullet_sprite
			JSR Draw_VLc
			 
done		
		   
		
			
			JSR Reset0Int
			lda  alley0e									;qual o inimigo neste caso Ghost
			ldx  #enemy_t                             ;_D escolhe qual o inimigo - Ghost_D
			lsla
			ldx      a,x 
			lda     enemy0d	                       ;qual a direcao direito ou esquerdo 0 ou 1
			lsla
			ldx      a,x 								   ; gets *_lleft or right   Ghost_Left = 0 Ghost_Right=1
			pshs     x									  ;guarda spool x
			ldx      #bulletYpos_t                 ; also enemy Y table 
            lda      ,x                           		; Y enemy  vertical posicao
            ldb     enemy0x                            ; X enemy   horizontal posicao
            jsr      Moveto_d                           ; PLACE EXTRA CODE VERSION HERE 
; *_f  frame count -> index list of frames, see definition in data.i 
            lda      alley0e
            lsla     
            ldx      #enemyframe_t 
            lda      [a,x]                        ; A = *_f var 
            lsla                                  ; sets enemy type X and which frame a 
            puls     x                            ; pull X back 
            ldx      a,x 
	        JSR Draw_VLp
			
			
			
			
			
			
	;	    JSR  Reset0Int
	;		LDA #0
	;		LDB #0
	;		JSR Moveto_d
	;		LDX #Ghost_Lt
	;		JSR Draw_VLp
			
			
skip0a 		
	;		JSR  Reset0Int
	;		LDA enemy_y
	;		LDB enemy_x
	;		JSR Moveto_d
	;		LDX #raptor_sprite
	;		JSR Draw_VLc
			JMP Main_Loop     ; Repete o ciclo


			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

new_enemy
			JSR  Random_3
			CMPA #-$60
			BGT  gen_continued
			ADDA #$30
gen_continued
			CMPA #$60
			BLE  gen_final
			SUBA #$30
gen_final
			STA enemy_x
			LDB #$75
			STB enemy_y
			RTS
			
			
			
resetpen
		JSR Reset0Int
		JSR Moveto_d
		RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_over
    ; check if any keys were pressed
    
			JSR Read_Btns
			CMPA    #$00
			BEQ draw_game_over
			; check if we got a high score and save it now.
			LDU #high_score
			LDX #player_score
			JSR New_High_Score
			JMP title_screen
			; draw the game over screen
draw_game_over
			JSR Wait_Recal      ; recalibrate
			JSR Intensity_5F    ; set intensity
			LDU #game_over_string
			LDA #$30
			LDB #-$40
			JSR Print_Str_d
			LDU #game_over_score
			LDA #0
			LDB #-$45
			JSR Print_Str_d
			LDU #player_score
			LDA #-$20
			LDB #-$40
			JSR Print_Str_d
			LDU #any_key_string
			LDA #-$60
			LDB #-$55
			JSR Print_Str_d
			BRA game_over

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
title_screen
			;check button
			JSR	Read_Btns
			CMPA #$00
			BEQ draw_title_screen
			JMP init_game
draw_title_screen
			JSR Wait_Recal
			JSR Intensity_5F
			LDU #high_score
			LDA #$7f
			LDB #-$80
			JSR Print_Str_d
			
			LDU #title_screen_string
			LDA #-$30
			LDB #-$60
			JSR Print_Str_d
			LDU #any_key_string
			LDA #-$60
			LDB #-$50
			JSR Print_Str_d
			BRA title_screen			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; String.asm

;title screens
title_screen_string
		FCB "GOOSE V RAPTORS",0x80

	
;game over screens
game_over_string
		FCB "GAME OVER",0x80
game_over_score
        FCB "YOU SCORED",0x80

;misc
any_key_string
		FCB "PRESS ANY KEY",0x80


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enemy_t             fdb      None_D, Ghost_D

Ghost_D              fdb      Ghost_Left,Ghost_Right
None_D               fdb      None_t, None_t

Ghost_Right         fdb      Ghost_Rt
Ghost_Down        fdb      Ghost_UpDow
Ghost_Up			  fdb      Ghost_UpDow
Ghost_Left           fdb      Ghost_Lt	

enemyframe_t        fdb      None_f, Arrow_f,

None_t                fdb      None 

ALLEYHEIGHT         equ        17 
BULLETYPOS          equ        60                          ;; trail and error for top alley 
bulletYpos_t        fcb      BULLETYPOS-(ALLEYHEIGHT*2*2), BULLETYPOS-(ALLEYHEIGHT*5*2), BULLETYPOS-(ALLEYHEIGHT*4*2), BULLETYPOS-(ALLEYHEIGHT*3*2), BULLETYPOS-(ALLEYHEIGHT*2*2),BULLETYPOS-(ALLEYHEIGHT*1*2), BULLETYPOS-(ALLEYHEIGHT*0*2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;dinosaur.asm
dinosaur_scale EQU 3
;goose!
player_sprite
			FCB 11
			FCB 0,0
			FCB -1*dinosaur_scale,1*dinosaur_scale
			FCB	-1*dinosaur_scale,0
			FCB	0,4*dinosaur_scale
			FCB -2*dinosaur_scale,-4*dinosaur_scale
			FCB -2*dinosaur_scale,0
			FCB 0,-2*dinosaur_scale
			FCB 2*dinosaur_scale,0
			FCB 2*dinosaur_scale,-4*dinosaur_scale
			FCB 0,4*dinosaur_scale
			FCB 1*dinosaur_scale,0
			FCB 1*dinosaur_scale,1*dinosaur_scale
	
	
bullet_scale EQU 2
bullet_sprite
			FCB 3	
			FCB	0,1*bullet_scale
			FCB	1*bullet_scale,0
			FCB	0,-1*bullet_scale
			FCB -1*bullet_scale,0

	
	
raptor_scale EQU 4
raptor_sprite
			FCB 10
			FCB 0,0
			FCB -1*raptor_scale,1*raptor_scale
			FCB	1*raptor_scale,1*raptor_scale
			FCB	raptor_scale,0
			FCB	0,raptor_scale
			FCB	raptor_scale,0
			FCB 3*raptor_scale,-2*raptor_scale
			FCB -3*raptor_scale,-2*raptor_scale
			FCB -1*raptor_scale,0
			FCB 0,raptor_scale
			FCB -1*raptor_scale,0
	
title_screen_scale EQU 10
title_screen_sprite
			FCB 4
			FCB 0,0
			FCB 2*title_screen_scale,0
			FCB 1*title_screen_scale,-1*title_screen_scale
			FCB 1*title_screen_scale,-2*title_screen_scale
			FCB -2*title_screen_scale,-1*title_screen_scale
			
			
			
ghost_scale EQU 2

; Formato: Modo (0=Mover, $FF=Desenhar, 1=Fim), Y, X
Ghost_Lt:

    FCB $FF, 5*ghost_scale, 2       ; Desenha lateral altera movimento
    FCB $FF, 2*ghost_scale, 1*ghost_scale    ; Curva topo 1
    FCB $FF, 1*ghost_scale, 2*ghost_scale    ; Curva topo 2
    FCB $FF, -1*ghost_scale, 2*ghost_scale   ; Curva topo 3
    FCB $FF, -2*ghost_scale, 1*ghost_scale   ; Curva topo 4
    FCB $FF, -5*ghost_scale, -2      ; Lateral oposta  3 altera movimento
    ; --- Base Ziguezague ---
    FCB $FF, 1*ghost_scale, -1*ghost_scale   
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale  ; Fecha corpo na origem (0,0)

    ; --- Salto para os Olhos (Sem linha!) ---
    FCB $00, 6*ghost_scale, 2*ghost_scale    ; $00 = Move sem desenhar
    FCB $FF, 1, 0                            ; Desenha olho 1
    
    FCB $00, 0, 2*ghost_scale                ; Move para o olho 2
    FCB $FF, 1, 0                            ; Desenha olho 2
    
    FCB $01                                  ; Fim da lista para a BIOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Ghost_Rt:

    FCB $FF, 5*ghost_scale, -2       ; Desenha lateral altera movimento
    FCB $FF, 2*ghost_scale, 1*ghost_scale    ; Curva topo 1
    FCB $FF, 1*ghost_scale, 2*ghost_scale    ; Curva topo 2
    FCB $FF, -1*ghost_scale, 2*ghost_scale   ; Curva topo 3
    FCB $FF, -2*ghost_scale, 1*ghost_scale   ; Curva topo 4
    FCB $FF, -5*ghost_scale, 2      ; Lateral oposta  3 altera movimento
    ; --- Base Ziguezague ---
    FCB $FF, 1*ghost_scale, -1*ghost_scale   
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale  ; Fecha corpo na origem (0,0)

    ; --- Salto para os Olhos (Sem linha!) ---
    FCB $00, 6*ghost_scale, 2*ghost_scale    ; $00 = Move sem desenhar
    FCB $FF, 1, 0                            ; Desenha olho 1
    
    FCB $00, -2, 2*ghost_scale                ; Move para o olho 2
    FCB $FF, 1, 0                            ; Desenha olho 2
    
    FCB $01                                  ; Fim da lista para a BIOS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Ghost_UpDow:

    FCB $FF, 5*ghost_scale, 0       ; Desenha lateral altera movimento
    FCB $FF, 2*ghost_scale, 1*ghost_scale    ; Curva topo 1
    FCB $FF, 1*ghost_scale, 2*ghost_scale    ; Curva topo 2
    FCB $FF, -1*ghost_scale, 2*ghost_scale   ; Curva topo 3
    FCB $FF, -2*ghost_scale, 1*ghost_scale   ; Curva topo 4
    FCB $FF, -5*ghost_scale, -0      ; Lateral oposta  3 altera movimento
    ; --- Base Ziguezague ---
    FCB $FF, 1*ghost_scale, -1*ghost_scale   
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale
    FCB $FF, 1*ghost_scale, -1*ghost_scale
    FCB $FF, -1*ghost_scale, -1*ghost_scale  ; Fecha corpo na origem (0,0)

    ; --- Salto para os Olhos (Sem linha!) ---
    FCB $00, 6*ghost_scale, 2*ghost_scale    ; $00 = Move sem desenhar
    FCB $FF, 1, 0                            ; Desenha olho 1
    
    FCB $00, 0, 2*ghost_scale                ; Move para o olho 2
    FCB $FF, 1, 0                            ; Desenha olho 2
    
    FCB $01                                  ; Fim da lista para a BIOS

None:               fcb      1 	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	


	
;		    JSR Intensity_5F    ; set intensity
;			LDU #debug
;			LDA #-$60
;			LDB #-$50
;			JSR Print_Str_d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;misc
any_key_string1
		FCB "DEBUG 1",0x80
;misc
any_key_string2
		FCB "DEBUG 2",0x80

	
