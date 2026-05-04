
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
JACK_Y  EQU 1
JACK_X  EQU 1
ESTADO	EQU 1 













    ; No Loop Principal
Main_Loop:
		JSR Wait_Recal
		JSR Intensity_5F
		
		;DESENHAR PLATAFORMAS 
		;DESENHAR 3 LINHAS HORIZONTAIS FIXAS
		
		LDA #$20
		LDB #-$7F	;-127 ESQ
		JSR Moveto_d
		LDA #$00
		LDB #$7F		;127
		JSR Draw_Line_d
		
		JSR Reset0Ref
		
		LDA #$20
		LDB #$7F	;127 DIR
		JSR Moveto_d
		LDA #$00
		LDB #-$78		;78
		JSR Draw_Line_d
		
		JSR Reset0Ref
		
		LDA #$15
		LDB #-$7F  ;127
		JSR Moveto_d
		LDA #$00
		LDB #$78
		JSR Draw_Line_d
		
		JSR Reset0Ref
		
		LDA #$15
		LDB #$7F
		JSR Moveto_d
		LDA #$00
		LDB #-$7F
		JSR Draw_Line_d
		
		JSR Reset0Ref
		
		
		;DESENHAR O JACK
		
	
		LDA JACK_Y
		LDB	JACK_X
		JSR Moveto_d
		LDX #player_Jack
		JSR 0xF3DA
	
	
	
 
    
    BRA Main_Loop     ; Repete o ciclo


			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



player_Jack
		 FCB $02
    FCB $10, $10
    FCB -$20, $00
    FCB $10, -$10  ; Soma final: Y=0, X=0

	
	
