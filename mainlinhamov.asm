
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ORG 0xC880
	 FCC "g GCE 2017"
	 FCB 0x80
   	 FDB musicd
         FCB 0xF8, 0x50, 0x20, -0x45
         FCC "ASTON HACK"
	 FCB 0x80
         FCB 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
player_x EQU 0
player_y EQU 0 



line_x EQU 50
line_y EQU 0



VELOCIDADE EQU	3    ;Define a velocidade  ate 4
POS_X   RMB 1         ; Reserva 1 byte para a posição X
POS_X1   RMB 20         ; Reserva 1 byte para a posição X



Linha    MACRO 

	
		 LDA \1          ; Y fixo no centro
		 LDB POS_X1         ; X variável
		 JSR Moveto_d         ; Moveto_d
		 ;LDX #Linha_Gigante
		 ;JSR $F3DA         ; Desenha as 3 linhas coladas, parecendo uma só longa
	
	
		 ; 3. Desenhar a linha (relativa à posição anterior)
		 ; Nota: O valor máximo para coordenadas/comprimento é $7F (127) ou $80 (-128)
		 LDA #$00           ; Comprimento Y
		 LDB #$60	          ; Comprimento X
		 JSR Draw_Line_d         ; Draw_Line_d (Desenha uma linha vertical de 32 pixels)

		 ; 4. Atualizar a posição para o próximo frame
		  INC POS_X1         ; Incrementa X para a linha "andar"
   
		 
		
		 ENDM








    ; No Loop Principal
Main_Loop:
    JSR Wait_Recal         ; Wait_Recal (Reset ao centro 0,0 e brilho)
    
    ; 1. Definir Intensidade (Brilho)
    
    JSR Intensity_5F        ; Intensity_a

    ; 2. Mover para a posição da nossa "personagem"
    LDA #$0          ; Y fixo no centro
    LDB POS_X         ; X variável
    JSR Moveto_d         ; Moveto_d
	;LDX #Linha_Gigante
	;JSR $F3DA         ; Desenha as 3 linhas coladas, parecendo uma só longa
	
	
    ; 3. Desenhar a linha (relativa à posição anterior)
	; Nota: O valor máximo para coordenadas/comprimento é $7F (127) ou $80 (-128)
    LDA #$00           ; Comprimento Y
    LDB #$7F          ; Comprimento X
    JSR Draw_Line_d         ; Draw_Line_d (Desenha uma linha vertical de 32 pixels)
	

	JSR Reset0Ref     ; Volta a focar o feixe no centro (0,0) sem recalibrar tudo
    
    LDA #$10          ; Mais acima no ecrã
    LDB POS_X1        ; Mais à esquerda (-16 em decimal)
    JSR Moveto_d      
    LDA #$0          ; Linha vertical
    LDB #$60          
    JSR Draw_Line_d   


    ; 4. Atualizar a posição para o próximo frame
    INC POS_X         ; Incrementa X para a linha "andar"
    INC POS_X1
;	LDA POS_X
;	ADDA #VELOCIDADE
	
	
	
 
    
    BRA Main_Loop     ; Repete o ciclo


			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dinosaur_scale EQU 10
; goose!
player_sprite
    FCB 11
    FCB 0,0
    FCB -1*dinosaur_scale, 1*dinosaur_scale
    FCB -1*dinosaur_scale, 0
    FCB 0, 4*dinosaur_scale
    FCB -2*dinosaur_scale, -4*dinosaur_scale
    FCB -2*dinosaur_scale, 0
    FCB 0, -2*dinosaur_scale
    FCB 2*dinosaur_scale, 0
    FCB 2*dinosaur_scale, -4*dinosaur_scale
    FCB 0, 4*dinosaur_scale
    FCB 1*dinosaur_scale, 0
    FCB 1*dinosaur_scale, 1*dinosaur_scale		

line_scale EQU 100
line
	FCB 30
    FCB 0,0
    FCB 0*line_scale, 0*line_scale

			
			
Linha_Gigante:
     FCB  2*dinosaur_scale, -4*dinosaur_scale      ; Sobe 64 unidades

	
	
