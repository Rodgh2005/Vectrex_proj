
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Dot_d			EQU		0xF2C3
Dot_here		EQU		0xF2C5
Dot_ix_b		EQU		0xF2BE
Dot_ix			EQU		0xF2C1
Dot_List		EQU		0xF2D5
Dot_List_Reset	EQU		0xF2DE

Vec_Dot_Dwell	EQU		0xC828
Vec_Misc_Count	EQU		0xC823
Delay3			EQU		0xF56D
VIA_t1_cnt_lo	EQU		0xD006

Draw_VLc        equ     0xF3CE
Moveto_d        equ     0xF312


Reset0Int       equ     0xF36B

Random_3        equ     0xF511

Intensity_5F	EQU		0xF2A5
Print_Str_d		EQU		0xF37A
Wait_Recal		EQU		0xF192
musicd			EQU		0xFD0D
Vec_Text_Height EQU 	0xC82A
Vec_Text_Width	EQU		0xC82B
Draw_Line_d     equ     0xF3DF

VIA_port_b      equ     0xD000 
VIA_port_a      equ     0xD001 
VIA_shift_reg   equ 	0xD00A
VIA_int_flags   equ     0xD00D
VIA_cntl        equ     0xD00C 
Reset0Ref       equ     0xF354

Vec_Joy_Mux_1_X equ     0xC81F   ;Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y equ     0xC820   ;Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X equ     0xC821   ;Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y equ     0xC822   ;Joystick 2 Y enable/mux flag (=7)

Vec_Music_Flag  equ     0xC856  
Clear_Score     equ     0xF84F 
Read_Btns       equ     0xF1BA 

Joy_Digital     equ     0xF1F8
Vec_Joy_1_X     equ     0xC81B   ;Joystick 1 left/right
Add_Score_a     equ     0xF85E

New_High_Score  equ     0xF8D8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ram starts at $C880 til $CBEA
high_score		EQU $CBEB	;7 bytes at system memory
player_score	EQU $C880 ;7 bytes for player score

player_x		EQU player_score+7
player_y		EQU player_x+1
bullet_active	EQU player_y+1
bullet_x		EQU bullet_active+1
bullet_y		EQU bullet_x+1
count			EQU bullet_y+1
speed			EQU count+1
player_speed	EQU speed+1
temp			EQU player_speed+1
killed			EQU temp+1
enemy_x			EQU killed+1
enemy_y			EQU enemy_x+1
enemy_x_2		EQU enemy_y+1
enemy_y_2		EQU	enemy_x_2+1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			ORG 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			 ; ORG 0xC880
			 FCC "g GCE 2017"
			 FCB 0x80
			 FDB musicd
			 FCB 0xF8, 0x50, 0x20, -0x45
			 FCC "ASTON HACK"
			 FCB 0x80
			 FCB 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
main:
			JSR Wait_Recal
			LDA #$30
			STA VIA_t1_cnt_lo
			
			LDA	#0
			LDB	#0
			JSR Moveto_d
			JSR	Intensity_5F
			
			LDX #Nave_Dados
			
			JSR	Draw_VLc
			
			
			
			
			BRA main
			
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
raptor_scale EQU 10
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
					
SHIP_SCALE EQU 30
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
	
;Nave_Dados:
				;	FCB  3              ; 4 linhas para fechar o triângulo (4-1 = 3)
				;	FCB  40,  0         ; Ponto 1: Topo (Bico da nave)
				;	FCB  -80, 40        ; Ponto 2: Canto inferior direito
					;FCB  0,  -80        ; Ponto 3: Canto inferior esquerdo
					;FCB  80,  40        ; Ponto 4: Fecha no topo
Nave_Dados:
					FCB  8              ; 4 linhas para fechar o triângulo (4-1 = 3)
					FCB  40,  0         ; Ponto 1: Topo (Bico da nave)
					FCB  -80, 40        ; Ponto 2: Canto inferior direito
					FCB  20,0
					FCB  0,10
					FCB  -40,0
					FCB  0,-10
					FCB   20,0
					FCB  0,  -80        ; Ponto 3: Canto inferior esquerdo
					FCB  80,  40        ; Ponto 4: Fecha no topo
