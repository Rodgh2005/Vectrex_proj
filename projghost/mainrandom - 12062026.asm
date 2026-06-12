
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;https://github.com/bahorn/AstonHack2017/tree/master
;https://www.chibiakumas.com/6809/multiplatform.php
;https://6502.org/forum/viewtopic.php?t=2325&start=15


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

XLIM 			EQU #80
YLIM             EQU #122;122
XMan            EQU $C880
YMan            EQU XMan +1
Xv				EQU  YMan +1
Yv                EQU  Xv +1
dl1                EQU  Yv +1
dl2                EQU  dl1 +1
temp_string   EQU  dl2 +1
tempX           EQU temp_string +1
Objects          EQU tempX + 12
Objectspoints  EQU Objects +12
User              EQU  $CAB9


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

;**************** ROUTINES

m_3 macro     ;Ville Krumlinde's routine to convert a binary number into decimal, must be less than 100
	  cmpb #\1 -1
	  bls tpd\1
	  subb #\1
	  addb #'0'
	  lda #\2
	  std ,U
	  bra tlsExit2
tpd\1:
  endm
  
  
;m_3 macro max,digit    ;Ville Krumlinde's routine to convert a binary number into decimal, must be less than 100
;  cmpb #max-1
;  bls tpd\1
;  subb #max
;  addb #'0'
;  lda #'digit'
;  std ,U
;  bra tlsExit2
;  tpd\1:
;  endm

;NOTE BIOS routines : Print_str_d trashes X REg, Wait_recal does too, intensity trashes D only


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


main
			;	JSR Wait_Recal
		;	JSR	Intensity_5F
		;	LDU #hello_world_string
		;	LDA #$10
		;	LDB #-$50
		;	JSR Print_Str_d
		;	JMP main
		
         LDA #0
		 STA XMan
		 STA YMan
		 STA Yv			;Yv=0
		 LDA #1
		 STA Xv			;Xv=1
		 
		; LDA #1			
		; STA dl1			;dl1 =1
		; LDA #2
		; STA dl40			;dl2 = 40
		 ;move dot list to RAM (can´t changed while in ROM)
		 LDB #79 ;79														;carrega o registo B com 79 como inicio .O ciclo vai correr 80 vezes
         LDX #Objects														;Carrega registo de indice X com o endereço de memoria do destino (Objects)
         LDY #ObjectList													;Carrega o registo de indice Y com o endereço de memoria  base  da origem (ObjectList)
		 
memloop
		LDA B,Y  																;Carrega o Registo A com o dado contido no endereço indexado (Origem Y + Desvio B)
		STA B,X																;Guarda o valor do registo A no endereço indexado (destino X + desvio B)
		DECB																	;decrementa o registo B em 1 unidade
		BPL memloop														;(Branch if Plus) desvia o programa de volta para memloop se o resultado for positivo ou 0 
																					;o ciclo termina assim que B passa de 0 para -1 ($FF)
																					
																					
;----------------------------------começa aqui o loop (ciclo)----------------------------------------------------------------------------------------------------------------------------
loop:

		JSR Wait_Recal														;chama rotina da Bios limpa os integradores do vetor e reseta o feixe de eletroes para o centro (0,0)
		LDX #Objects														;carrega o registo X com o endereço base da tabela de objectos na RAM ;base address of dotlist in RAM, each entry is a byte
		LDY ,X++																;esta é uma instruçao pos-incrementada. Ela lê 2 bytes (uma word) do endereço apontado por X e coloca-os no registo Y. Depois, avança o registo X em 2 Bytes.
																					;Number of Objects into Y, Base address of Object list in RAM into X also increment X by a word so on next item
																					;O registo Y tem 16 bits. lse a lista começa com o numero objectos (1 byte ) o LDY vai ler o numero de objectos E o primeiro byte de dados juntos. Se o numero de objectos for apenas 1 byte, deve usar LDA ,X+ .
		STX tempX															; Guarda o endereço atualizado de X  na variavel temporaria tempX.
																					;Store X in temporary variable because a lot of BIOS routines use X register
		
ListLoop:
;-------------------move objects
;-------------------X Limits
		LDX  tempX															;Recupera o ponteiro atual da lista de objectos que foi guardada na rotina anterior
		LDA ,X 		;xposition of object to A							;Carrega a posiçao X actual do objecto para o registo A
		ADDA 2,X  ;add x-vector to A									;Soma a velocidade /vector X (guardado 2 bytes a frente na memoria) a posicao atual
		CMPA #XLIM  ;check if hits right  side of screen		;compara a nova posiçao com o limite direito do ecra (XLIM)
		BLE chk2																;se a posicao for menor ou igual (Branch if Less or Equal)ao limite, o objecto esta dentro do ecran a direita. Salta para verificar o lado esquerdo (chk2)
		LDA #XLIM															;se passou o limite, força a posicao a fixar-se exatamente na borda da direita (XLIM ) e salta para inverter o vetor
		BRA SetX
chk2:
		CMPA #-XLIM ;check if hits left side of screen           ;Compara nova posicao com o limite esquerdo do ecran (-XLIM)
		BGE fin																	 ;Se for maior ou igual (Branch if Greater or Equal), o objecto esta dentro dos limites. Salta para o fim para guardar posicao.
		LDA #-XLIM															 ; se ultrapassou o limite esquerdo , força a posicao  a fixar na borda esquerda(-XLIM)
SetX:
		NEG 2,X	;two's complement X-vector (negate it)	 ;Inverte sinal do vetor de movimento (no byte 2,X) usando o complemento para dois. Isto faz o objeto mudar de direçao (ex : de +2 para -2 )	
fin:
		STA ,X ;store new X position									 :Guarda a posiçao X final actualizada de volta na memoria do objeto.			
		
;--------Y limits-------------------------------------------------------------

		LDA 1,X   ; y position of object in A							 ;Carrega a posiçao Y atual do objeto (guardada no desvio 1)	
		ADDA 3,X ;add yv to y position								 ;Soma a velocidade/vetor Y (Guardado no desvio 3) a posicao atual.		
		CMPA  #YLIM ;check if hits top of screen					 ;Verifica se o objeto ultrapassou o limite superior do ecran. senao salta para testar o limite inferior
		BLE chk2y
		LDA #YLIM																
		BRA SetY
chk2y:
		CMPA #-YLIM		;check if hits bottom of screen     ;verifica se objeto ultrapassou o limite inferior. se tiver dentro dos limites, salta para o fim
		BGE finy
		LDA #-YLIM
SetY:
		NEG 3,X	;two 's complement Xv                            ;inverte o sinal do vetor Y (no desvio 3) caso tenha batido em cima ou em baixo, criando o efeito de ricochete vertical
finy:
		STA 1,X																;guarda nova posicao Y na memoria	
		
		LDX tempX															;recarrega o ponteiro do objeto para o registo X
		LDA #$7F  ;Set scale factor to $7F							;define o valor da escala global no maximo	
		STA <VIA_t1_cnt_lo

;----------------Draw Dots

		JSR Intensity_5F	;brightest intensity for dots
		;LDA     #$F4                   ;Init dot dwell (brightness)
        ;STA     <Vec_Dot_Dwell
		LDX 	tempX
		JSR Reset0Ref   ;reset pen to origin
		LDA  1,X		;relative Y position
		LDB ,X           ;relative X position
		NEGA				;Dot positions are positioned at the inverted positions of the squares
		NEGB
         JSR     Moveto_d 		;move to position specified in 
						; d register
         JSR     Dot_here                ; Plot a dot at this position
		 
		 

;---------------DRAW SQUARES 

		;LDA     #$05            ;Init dot dwell (brightness)
                ;STA     <Vec_Dot_Dwell 

		JSR	Reset0Ref
		LDX	tempX
		
                LDA     1,X                      ; set y
                LDB     ,X                      ; set x
		
                JSR     Moveto_d                ; move the vector beam the
                                                ; relative position
	        	LDA     #$10                    ; scaling factor of $10 to A
                STA     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling
	
			    JSR Intensity_5F
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                LDX    #square_line_list ;#Ghost_UpDow      ; load the address of the to be //#square_line_list
                                                ; drawn vector list to X
                JSR     Draw_VLc                ; draw the shape 
			; JSR    Draw_VLp
                 
;------------
		LDX	tempX			;Retrieve X
		LEAX 	4,X			;move to next item in list
		STX	tempX
		

		LEAY 	-1,Y			;Dec Y (number of items)
		BNE	ListLoop


;		LDY	#1			;Delay routine, uncomment to slow program down
;delay2:		
;		LDX	#25			
;delay:		LEAX	-1,X
;		BNE	delay
;		LEAY	-1,Y
;		BNE	delay2
		
              JMP loop			; and repeat forever

Print_Text:					;Print text A=Text position relative Y  B=Text position relative X
		JSR     Text_ConvertX2		;Convert binary number to decimal
		JSR	Reset0Ref		
                JSR     Print_Str_d             ; Vectrex BIOS print routine
		RTS

Text_ConvertX2:           ;x holds value to be converted (max 99), u = destination buffer-2 (2 bytes needed)

tlsBelow100:

  m_3 90,9
  m_3 80,8
  m_3 70,7
  m_3 60,6
  m_3 50,5
  m_3 40,4
  m_3 30,3
  m_3 20,2
  m_3 10,1

  LDA #'0'
  ADDB #'0'
  STD ,U

tlsExit2:

	LDB	#$80             ;add end byte
	STB	2,U
	
  RTS










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








		
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;DATA SECTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




ObjectList:
                
		 ;FCB 0,20                           ; number of objects (word, 2 bytes)  3objectos
		 FCB 0,1  
         FCB  2,2,2,2		;  FCB  20,-20,-2,2
		; FCB  -20,-10,1,-2
		; FCB 10,10,-1,1
		; FCB -20,20,2,-1
		; FCB -40,30,3,1
		; FCB 40,-30,-2,-3
		 ;FCB 30,40,2,2
		 ;FCB 60,-20,1,3
		 ;FCB 35,-15,4,2
		 ;FCB -35,15,2,3
		 ;FCB 10,70,-1,-1
		 ;FCB -10,-70,2,1
		 ;FCB -5,16,1,3
		 ;FCB	5,19,4,1
		 ;FCB 12,-12,-3,-2
;		 FCB 35,-14,-1,1
;		 FCB 12,20,2,3
;		 FCB -10,-10,2,-2
;		 FCB 30,30,-3,-1
;		 FCB -28,-26,-2,-2

;ghost_scale EQU  2;35		 
		 
;Ghost_UpDow:

;    FCB $FF, 5*ghost_scale, 0       ; Desenha lateral altera movimento
;    FCB $FF, 2*ghost_scale, 1*ghost_scale    ; Curva topo 1
;    FCB $FF, 1*ghost_scale, 2*ghost_scale    ; Curva topo 2
;    FCB $FF, -1*ghost_scale, 2*ghost_scale   ; Curva topo 3
;    FCB $FF, -2*ghost_scale, 1*ghost_scale   ; Curva topo 4
;    FCB $FF, -5*ghost_scale, -0      ; Lateral oposta  3 altera movimento
    ; --- Base Ziguezague ---
;    FCB $FF, 1*ghost_scale, -1*ghost_scale   
;    FCB $FF, -1*ghost_scale, -1*ghost_scale
;    FCB $FF, 1*ghost_scale, -1*ghost_scale
;    FCB $FF, -1*ghost_scale, -1*ghost_scale
;    FCB $FF, 1*ghost_scale, -1*ghost_scale
;    FCB $FF, -1*ghost_scale, -1*ghost_scale  ; Fecha corpo na origem (0,0)

    ; --- Salto para os Olhos (Sem linha!) ---
 ;   FCB $00, 6*ghost_scale, 2*ghost_scale    ; $00 = Move sem desenhar
 ;   FCB $FF, 1, 0                            ; Desenha olho 1
    
 ;   FCB $00, 0, 2*ghost_scale                ; Move para o olho 2
 ;   FCB $FF, 1, 0                            ; Desenha olho 2
    
 ;   FCB $01                                  ; Fim da lista para a BIOS		 
		 

;sprite quadrado para teste		 
SPRITE_BLOW_UP EQU 35                    
square_line_list:
                FCB 3                           ; number of vectors - 1
                FCB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
     	        FCB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
		        FCB  -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
		        FCB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP
  



hello_world_string
			 FCB "TESTE RODRIGO",0x80



;;;;;;;;
;misc
any_key_string1
		FCB "DEBUG 1",0x80
;misc
any_key_string2
		FCB "DEBUG 2",0x80


		
		
