
;https://github.com/gauze/Turmoil/blob/master/include/vars.i
;{{{ Funcoes de inicio}}}}

;{{{   setting up hardware, reseting scores, once per boot}}}

setup:
		;	lda 	select_level_flag
	;		bne 	no_level_set
	;		lda 	#1
	;		sta 	level

no_level_set
			lda		#1					;enable
			sta 	Vec_Joy_Mux_1_X
			lda     #3
			sta     Vec_Joy_Mux_1_Y
			lda     #0
			sta     Vec_Joy_Mux_2_X		;disable for Joy Mux's
			sta     Vec_Joy_Mux_2_Y
		;	ldx     #score
		;   jsr     Clear_score
		;   ldx      #running_score 
        ;   jsr      Clear_Score 
			rts