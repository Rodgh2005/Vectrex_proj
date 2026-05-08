
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;https://github.com/bahorn/AstonHack2017/tree/master

	INCLUDE "include/macros.asm"
	INCLUDE "include/VECLib.asm"
	INCLUDE "include/vars.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					
;{{{ DRAW_LINE_D_PAT: from BIOS optimized slightly ;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_LINE_D_PAT     macro    
                    
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    CLR      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LDA      Line_Pat                     ;Shift reg 
 
                                ;Wait a moment more 
                    CLR      <VIA_shift_reg               ;Clear shift register (blank output) 
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


main
			jsr Wait_Recal
			
		;	lda #10
		;	sta VIA_t1_cnt_lo
		;	jsr Intensity_5F
		;	    clrd
		;	jsr Moveto_d
		;	jsr Dot_here
		;	ldu #Tank_69
		;	jsr CURVY
		;	    clrd
		;	jsr Moveto_d
		;	jsr Dot_here
		;	ldu #Tank_70
		;	jsr draw_curved_line
		;	jsr CURVY
		    READ_JOYSTICK
		    DRAW_LINE_WALLS
			DRAW_SHIP
			

			jmp main
			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CURVY:
					LDD 	 #$8118
					STA 	 VIA_port_b
					STB 	 VIA_aux_cntl
					BRA 	 RAINY
JELLO               STB      VIA_port_b                   ;FORMAT- Y,ON/OFF,X,X,X 
                    STA      VIA_shift_reg                ; 0 GOES TO NEXT Y, ADDIT. 0 ENDS 
JALLO               LDA      ,U+ 
                    BEQ      BRAINY                       ;UPDATING X-VALUES 
                    STA      VIA_port_a 
                    BRA      JALLO 

BRAINY              LDB      #$81                         ;RAMP OFF 
                    STB      VIA_port_b 
                    STA      VIA_shift_reg                ;VID OFF 
RAINY               LDA      ,U+                          ;NEXT Y 
                    BEQ      JFIN                         ;IF DONE 
                    STA      VIA_port_a                   ;IF GOOD Y VAL 
                    DECB     
                    STB      VIA_port_b                   ;BEGIN S/H 
                    LDD      ,U++                         ;A=VID ENBL, B=NEXT X 
                    INC      VIA_port_b                   ;Y S/H DONE 
                    STB      VIA_port_a 
                    LDB      #$01 
                    BRA      JELLO 

JFIN                LDA      #$98 
                    STA      VIA_aux_cntl                 ;PUT BACK 
                    RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_curved_line:
                 LDD     #$1881            ; load D with VIA pokes
                 STB     VIA_port_b        ; poke $81 to port B
                                           ; disable MUX
                                           ; disable ~RAMP
                 STA     VIA_aux_cntl      ; poke $18 to AUX
                                           ; shift mode 4
                                           ; PB7 not timer controlled
                                           ; PB7 is ~RAMP
                 BRA     next_update_round ; jump to entry of loop
x_update_loop_init:
                 STB     VIA_port_b        ; MUX disable, ~RAMP enable
                 STA     VIA_shift_reg     ; poke the enable byte (A) found to
                                           ; shift, that enables/disables ~BLANK
x_update_loop:
                 LDA     ,U+               ; load next X_update value
                 BEQ     finnish_x_update  ; if zero, we are done with this
                                           ; X_update
                 STA     VIA_port_a        ; otherwise put the found value to
                                           ; DAC and thus to X integration
                 BRA     x_update_loop     ; go on, look if another X_update
                                           ; value is there...
finnish_x_update:
                 LDB     #$81              ; load value for ramp off, MUX off
                 STB     VIA_port_b        ; poke $81, ramp off, MUX off

                 NOP                       ; these NOP's seem to be neccessary
                 NOP                       ; since the delay between VIA and
                 NOP                       ; integration hardware
                 NOP                       ; otherwise, there is a space
                                           ; between Y_updates...    Malban
                 STA     VIA_shift_reg     ; A == %00000000
next_update_round:
                 LDA     ,U+               ; load next Y_update
                 BEQ     done_curved_line  ; go to done if 0
                 STA     VIA_port_a        ; poke to DAC
                 DECB                      ; B now $80
                 STB     VIA_port_b        ; enable MUX, that means put
                                           ; DAC to Y integrator S/H
                 LDD     ,U++              ; A=VIDEO_enable, B=X_update
                 INC     VIA_port_b        ; MUX off, only X on DAC now
                 STB     VIA_port_a        ; store B (X_update) to DAC
                 LDB     #$01              ; load poke for MUX disable,
                                           ; ~RAMP enable
                 BRA     x_update_loop_init; goto x update loop
done_curved_line:
                 LDA     #$98              ; load AUX setting
                 STA     VIA_aux_cntl      ; restore usual AUX setting
                                           ; (enable PB7 timer, SHIFT mode 4)
                 RTS                       ; and out of here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		INCLUDE "include/data.asm"
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
