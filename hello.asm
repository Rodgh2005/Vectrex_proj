
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Intensity_5F	EQU		0xF2A5
Print_Str_d		EQU		0xF37A
Wait_Reacal		EQU		0xF192
musicd			EQU		0xFD0D
Vec_Text_Height EQU 	0xC82A
Vec_Text_Width	EQU		0xC82B



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 org 0
	 FCC "g GCE 2017"
	 FCB 0x80
   	 FDB musicd
         FCB 0xF8, 0x50, 0x20, -0x45
         FCC "ASTON HACK"
	 FCB 0x80
         FCB 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;	LDA #$F1
		;	LDB #$60
		;	STA Vec_Text_Height
		;	STB Vec_Text_Width
main
			JSR Wait_Reacal
			JSR	Intensity_5F
			LDU #hello_world_string
			LDA #$10
			LDB #-$50
			JSR Print_Str_d
			JMP main
			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hello_world_string
			 FCB "PRESS ANY KEY",0x80
			
			
			

	
	
