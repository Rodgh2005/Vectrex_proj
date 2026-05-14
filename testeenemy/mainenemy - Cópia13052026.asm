
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;https://github.com/bahorn/AstonHack2017/tree/master

;	INCLUDE "include/macros.asm"
	INCLUDE "include/VECLib.asm"
;	INCLUDE "include/vars.asm"
	;INCLUDE "include/functions.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ENEMY TABLE 
GHOST               equ        8                            ; various values for quick testing. positions are 
TANK                equ        6                            ; from Enemy_t table 
EXPLOSION           equ        9 
ARROW               equ        1 
PRIZE               equ        5 
CANNONBALL          equ        7 

MEMO equ $C880
alley0e equ MEMO + 1
alley0d equ alley0e + 1
alley0x equ alley0d + 1
; variables to hold which frame for each shape enemy some might not have an animation...
Arrow_f             equ   alley0x + 1 
Bow_f               equ   Arrow_f + 1 
Dash_f              equ   Bow_f  +  1 
Wedge_f             equ   Dash_f +  1 
Ghost_f             equ   Wedge_f + 1 
Prize_f             equ   Ghost_f + 1 
Cannonball_f        equ   Prize_f +  1 
Tank_f              equ   Cannonball_f  +  1 
None_f              equ   Tank_f  + 1 
Explode_f           equ   None_f +  1   








DRAW_ENEMYS 		macro
; *_D -> index 0|1 (0=Left, 1=Right)
                    jsr      Reset0Ref  
                    lda      alley0e 
                    lbeq     skip0a 
break1 
					
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley0d 				   	  ;direction
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t                ; also enemy Y table 
                    lda      ,x                           ; Y enemy 
                    ldb      alley0x                      ; X enemy 
                    jsr      Moveto_d                           ; PLACE EXTRA CODE VERSION HERE 
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley0e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla                                  ; sets enemy type X and which frame a 
                    puls     x                            ; pull X back 
                    ldx      a,x 
break2 
                    jsr    Draw_VLp   
skip0a

					endm
					
					
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
			 FCC "ASTON HACK"
			 FCB 0x80
			 FCB 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
		
		
setup
			lda      #8
			sta      alley0e
			lda      #0
			
			sta      Arrow_f 
            sta      Bow_f 
            sta      Dash_f 
            sta      Explode_f 
            sta      Wedge_f 
            sta      Ghost_f 
            sta      None_f 
            sta      Prize_f 
            sta      Cannonball_f 
            sta      Tank_f 
			sta      alley0d
			sta      alley0x
		

main
			jsr Wait_Recal
			JSR	Intensity_5F
			LDA	#80
			STA VIA_t1_cnt_lo
			DRAW_ENEMYS 
		
		
			

			jmp main
			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enemy_t             fdb      None_D, Arrow_D, Bow_D, Dash_D, Wedge_D, Prize_D, Tank_D, Cannonball_D, Ghost_D, Explode_D 
;                                0,       1,     2,     3,        4,       5,      6,             7,       8,         9
enemyframe_t        fdb      None_f, Arrow_f, Bow_f, Dash_f, Wedge_f, Prize_f, Tank_f, Cannonball_f, Ghost_f, Explode_f 
; Enemy direction table, dupe entry means same graphics both ways;  _D = direction
; Arrow -> Tank
; Prize -> Cannonball
; Ghost only spawns when player captures prize OR lingers in alley too long (??)
None_D              fdb      None_t, None_t               ; No enemy 
Arrow_D             fdb      Arrow_L_t, Arrow_R_t 
Bow_D               fdb      Bow_t, Bow_t 
Cannonball_D        fdb      Cannonball_t, Cannonball_t 
Dash_D              fdb      Dash_t, Dash_t 
Explode_D           fdb      Explode_t, Explode_t 
Ghost_D             fdb      Ghost_t, Ghost_t 
Prize_D             fdb      Prize_t, Prize_t 
Tank_D              fdb      Tank_L_t, Tank_R_t 
Wedge_D             fdb      Wedge_L_t, Wedge_R_t 
; Animation tables counts must be mod 100 == 0 ie 1,2,4,5,10,20,25,50,100 see FRAME_CNTS macro
Arrow_L_t           fdb      Arrow_L_1, Arrow_L_2 
Arrow_R_t           fdb      Arrow_R_1, Arrow_R_2 
Bow_t               fdb      Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2 ; 
                    fdb      Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2 ; flippy 90 degree animation (100/2 frames each) 
Cannonball_t        fdb      Cannonball, Cannonball 
Dash_t              fdb      Dash_1, Dash_2               ; same, no animation (100 frames) 
Explode_t           fdb      Explode_0 ,Explode_2 ,Explode_3 ,Explode_4 ,Explode_5 ; (100/20 frames each) 
                    fdb      Explode_6 ,Explode_7 ,Explode_8 ,Explode_9 ,Explode_9 
                    fdb      Explode_0 ,Explode_2 ,Explode_3 ,Explode_4 ,Explode_5 
                    fdb      Explode_6 ,Explode_7 ,Explode_8 ,Explode_9 ,Explode_9 
Ghost_t             fdb      Ghost                        ; same, no animation (100 frames) 
None_t              fdb      None 
Tank_L_t            fdb      Tank_L_1,Tank_L_2 
Tank_R_t            fdb      Tank_R_1,Tank_R_2 
Prize_t             fdb      Prize_1,Prize_2,Prize_1,Prize_2 ; big/small animation 
Wedge_L_t           fdb      Wedge_L_1, Wedge_L_2, Wedge_L_3, Wedge_L_2 
Wedge_R_t           fdb      Wedge_R_1, Wedge_R_2, Wedge_R_3, Wedge_R_2 


ALLEYHEIGHT         equ        17 
BULLETYPOS          equ        60                          ;; trail and error for top alley 
bulletYpos_t        fcb      BULLETYPOS-(ALLEYHEIGHT*6*2), BULLETYPOS-(ALLEYHEIGHT*5*2), BULLETYPOS-(ALLEYHEIGHT*4*2), BULLETYPOS-(ALLEYHEIGHT*3*2), BULLETYPOS-(ALLEYHEIGHT*2*2),BULLETYPOS-(ALLEYHEIGHT*1*2), BULLETYPOS-(ALLEYHEIGHT*0*2)



;misc
any_key_string1
		FCB "PRESS ANY KEY1",0x80
;misc
any_key_string2
		FCB "PRESS ANY KEY2",0x80



;{{{ Enemy lists
Arrow_R_1: 
                    fcb      0, -5, 0 
                    fcb      2, +5, +5 
                    fcb      2, +0, -17 
                    fcb      2, +0, +17 
                    fcb      2, +5, -5 
                    fcb      1 
Arrow_R_2: 
                    fcb      0, -5, 0 
                    fcb      2, +3, +5 
                    fcb      2, +0, -17 
                    fcb      2, +0, +17 
                    fcb      2, +3, -5 
                    fcb      1 
Arrow_L_1: 
                    fcb      0, -5, 0 
                    fcb      2, +5, -5 
                    fcb      2, +0, +17 
                    fcb      2, +0, -17 
                    fcb      2, +5, +5 
                    fcb      1 
Arrow_L_2: 
                    fcb      0, -5, 0 
                    fcb      2, +3, -5 
                    fcb      2, +0, +17 
                    fcb      2, +0, -17 
                    fcb      2, +3, +5 
                    fcb      1 
Bow_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, +17 
                    fcb      2, -13, -17 
                    fcb      2, +0, +17 
                    fcb      2, +13, -17 
                    fcb      1 
Bow_2: 
                    fcb      0, +8, -10 
                    fcb      2, -13, +0 
                    fcb      2, +13, +17 
                    fcb      2, -13, +0 
                    fcb      2, +13, -17 
                    fcb      1 
Dash_1: 
                    fcb      0, +2, -5 
                    fcb      2, +0, +20 
                    fcb      2, -1, +0 
                    fcb      2, +0, -20 
                    fcb      2, -1, +0 
                    fcb      2, +0, +20 
                    fcb      2, -1, +0 
                    fcb      2, +0, -20 
                    fcb      2, +3, +0 
                    fcb      1 
Dash_2: 
                    fcb      0, +2, -5 
                    fcb      2, +0, +16 
                    fcb      2, -1, +0 
                    fcb      2, +0, -16 
                    fcb      2, -1, +0 
                    fcb      2, +0, +16 
                    fcb      2, -1, +0 
                    fcb      2, +0, -16 
                    fcb      2, +3, +0 
                    fcb      1 
Wedge_R: 
                    fcb      0, +5, -7 
                    fcb      $FF, -5, +17 
                    fcb      $FF, -5, -17 
                    fcb      $FF, +10, +0 
                    fcb      1 
Wedge_R_1: 
                    fcb      0, +5, -7 
                    fcb      $FF, -5, +17 
                    fcb      $FF, -5, -17 
                    fcb      $FF, +10, +0 
                    fcb      1 
Wedge_R_2: 
                    fcb      0, +3, -7 
                    fcb      $FF, -3, +17 
                    fcb      $FF, -3, -17 
                    fcb      $FF, +6, +0 
                    fcb      1 
Wedge_R_3: 
                    fcb      0, +1, -7 
                    fcb      $FF, -1, +17 
                    fcb      $FF, -1, -17 
                    fcb      $FF, +2, +0 
                    fcb      1 
Wedge_L: 
                    fcb      0, +5, -7 
                    fcb      2, -5, -17 
                    fcb      2, -5, +17 
                    fcb      2, +10, +0 
                    fcb      1 
Wedge_L_1: 
                    fcb      0, +5, -7 
                    fcb      2, -5, -17 
                    fcb      2, -5, +17 
                    fcb      2, +10, +0 
                    fcb      1 
Wedge_L_2: 
                    fcb      0, +3, -7 
                    fcb      2, -3, -17 
                    fcb      2, -3, +17 
                    fcb      2, +6, +0 
                    fcb      1 
Wedge_L_3: 
                    fcb      0, +1, -7 
                    fcb      2, -1, -17 
                    fcb      2, -1, +17 
                    fcb      2, +2, +0 
                    fcb      1 
;Ghost: 
;                    fcb      0, +1, -11 
;                    fcb      2, +0, +22                   ; TOP 
;                    fcb      2, +6, -11 
;                    fcb      2, -6, -11 
;                    fcb      0, -3, 0                     ; GAP 
;                    fcb      2, +0, +22                   ; Bottom 
;                    fcb      2, -6, -11 
;                    fcb      2, +6, -11 
;                    fcb      1 





Tank_R_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, -17 
                    fcb      2, -10, +2 
                    fcb      2, -10, -2 
                    fcb      2, +0, +17 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      1 
Tank_R_2: 
                    fcb      0, +8, -8 
                    fcb      2, +0, -17 
                    fcb      2, -10, +2 
                    fcb      2, -10, -2 
                    fcb      2, +0, +17 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      1                            ; endmarker 
Tank_L_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, +17 
                    fcb      2, -10, -2 
                    fcb      2, -10, +2 
                    fcb      2, +0, -17 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      1 
Tank_L_2: 
                    fcb      0, +8, -8 
                    fcb      2, +0, +17 
                    fcb      2, -10, -2 
                    fcb      2, -10, +2 
                    fcb      2, +0, -17 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      1 
Prize_1:            fcb      0, +5, 0 
                    fcb      2, -5, +7 
                    fcb      2, -5, -7 
                    fcb      2, +5, -7 
                    fcb      2, +5, +7 
                    fcb      1 
Prize_2:            fcb      0, +3, 0 
                    fcb      2, -3, +5 
                    fcb      2, -3, -5 
                    fcb      2, +3, -5 
                    fcb      2, +3, +5 
                    fcb      1 
Cannonball          fcb      0, +3, 0 
                    fcb      2, -3, +5 
                    fcb      2, -3, -5 
                    fcb      2, +3, -5 
                    fcb      2, +3, +5 
                    fcb      1 
;}}}
; {{{ Explode animation
Explode_0: 
                    fcb      0, -8, -5 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +10, -13 
                    fcb      2, +0, +15 
                    fcb      2, -11, -12 
                    fcb      1 
Explode_1: 
                    fcb      0, -9, +1 
                    fcb      2, +15, -6 
                    fcb      2, -9, +13 
                    fcb      2, +1, -16 
                    fcb      2, +9, +12 
                    fcb      2, -16, -3 
                    fcb      1 
Explode_2: 
                    fcb      0, -7, +6 
                    fcb      2, +9, -14 
                    fcb      2, +1, +16 
                    fcb      2, -10, -13 
                    fcb      2, +15, +4 
                    fcb      2, -15, +7 
                    fcb      1 
Explode_3: 
                    fcb      0, -2, +9 
                    fcb      2, +0, -17 
                    fcb      2, +9, +13 
                    fcb      2, -16, -5 
                    fcb      2, +15, -5 
                    fcb      2, -8, +14 
                    fcb      1 
Explode_4: 
                    fcb      0, +4, +9 
                    fcb      2, -10, -14 
                    fcb      2, +15, +5 
                    fcb      2, -16, +5 
                    fcb      2, +9, -12 
                    fcb      2, +2, +16 
                    fcb      1 
Explode_5: 
                    fcb      0, +8, +5 
                    fcb      2, -16, -5 
                    fcb      2, +15, -5 
                    fcb      2, -10, +13 
                    fcb      2, +0, -15 
                    fcb      2, +11, +12 
                    fcb      1 
Explode_6: 
                    fcb      0, +9, -1 
                    fcb      2, -15, +6 
                    fcb      2, +9, -13 
                    fcb      2, -1, +16 
                    fcb      2, -9, -12 
                    fcb      2, +16, +3 
                    fcb      1 
Explode_7: 
                    fcb      0, +7, -6 
                    fcb      2, -9, +14 
                    fcb      2, -1, -16 
                    fcb      2, +10, +13 
                    fcb      2, -15, -4 
                    fcb      2, +15, -7 
                    fcb      1 
Explode_8: 
                    fcb      0, +2, -9 
                    fcb      2, +0, +17 
                    fcb      2, -9, -13 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +8, -14 
                    fcb      1 
Explode_9: 
                    fcb      0, -4, -9 
                    fcb      2, +10, +14 
                    fcb      2, -15, -5 
                    fcb      2, +16, -5 
                    fcb      2, -9, +12 
                    fcb      2, -2, -16 
                    fcb      1 
Explode_10: 
                    fcb      0, -8, -5 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +10, -13 
                    fcb      2, +0, +15 
                    fcb      2, -11, -12 
                    fcb      1 
;}}}
None:               fcb      1 	


;diamond_scale EQU 4

;Ghost:
   ; FCB 4                ; 4 segmentos para fechar o losango
   ; FCB 0, 0             ; Ponto de origem
   ; FCB 1*diamond_scale, 1*diamond_scale   ; Sobe e vai para a direita (Nordeste)
   ; FCB 1*diamond_scale, -1*diamond_scale  ; Desce e vai para a direita (Sudeste)
   ; FCB -1*diamond_scale, -1*diamond_scale ; Desce e vai para a esquerda (Sudoeste)
   ; FCB -1*diamond_scale, 1*diamond_scale  ; Sobe e vai para a esquerda (Noroeste - regressa à origem)	
   
;   fcb 10
;   fcb 0,0
;   fcb 1*diamond_scale,0
;   fcb 1*diamond_scale,1*diamond_scale
;   fcb -1*diamond_scale,1*diamond_scale
;   fcb 1*diamond_scale,1*diamond_scale
;   fcb -1*diamond_scale,1*diamond_scale
;   fcb -1*diamond_scale,0
;   fcb 1*diamond_scale,-1*diamond_scale
;   fcb -1*diamond_scale,-1*diamond_scale
;   fcb 1*diamond_scale,-1*diamond_scale
;   fcb -1*diamond_scale,-1*diamond_scale
   
;ghost_scale EQU 2
;Ghost:
;    FCB 14               ; 14 segmentos
;    FCB 0, 0             ; Início (canto inferior esquerdo)
	
;    FCB 5*ghost_scale, 1      ; Move para a direita (corpo longo)
;    FCB 2*ghost_scale, 1*ghost_scale   ; Curva do topo 1
;    FCB 1*ghost_scale, 2*ghost_scale   ; Curva do topo 2
;    FCB -1*ghost_scale, 2*ghost_scale  ; Curva do topo 3
;    FCB -2*ghost_scale, 1*ghost_scale  ; Curva do topo 4
;    FCB -5*ghost_scale, -1     ; Lateral esquerda (regressa ao longo do corpo)
    ; --- Base em Ziguezague (agora na vertical) ---
;    FCB 1*ghost_scale, -1*ghost_scale  ; Ziguezague 1
;    FCB -1*ghost_scale, -1*ghost_scale ; Ziguezague 1
;    FCB 1*ghost_scale, -1*ghost_scale  ; Ziguezague 2
;    FCB -1*ghost_scale, -1*ghost_scale ; Ziguezague 2
;    FCB 1*ghost_scale, -1*ghost_scale  ; Ziguezague 3
;    FCB -1*ghost_scale, -1*ghost_scale ; Fecha na origem
	
	
	
	
ghost_scale EQU 3

; Formato: Modo (0=Mover, $FF=Desenhar, 1=Fim), Y, X
Ghost:

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

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;INCLUDE "include/data.asm"
		;INCLUDE "include/functions.asm"
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
