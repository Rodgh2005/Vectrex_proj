
;https://github.com/gauze/Turmoil/blob/master/include/vars.i
;{{{ Variable RAM SECTION}}}}

	org $C880



;POS_X   EQU $C880         ; Reserva 1 byte para a posição X starts 7 bytes
shipYpos 	rmb 	 1						;posicao Y
shipXpos    rmb 	 2					;posicao do x

Ship_Dead	rmb 	 1
Demo_Mode   rmb 	 1
shipspeed	rmb		 1
In_Alley	rmb		 1				;ship is in ( está num beco)
stallcnt	rmb		 1              ;generic slow down

shipdir     rmb         1                            ; left or right 

; frame counts for animations/speed
frm100cnt   rmb  1 
frm50cnt    rmb  1 
frm25cnt    rmb  1 
frm20cnt    rmb  1 
frm10cnt    rmb  1 
frm5cnt     rmb  1 
frm4cnt     rmb  1 
frm3cnt     rmb  1 
frm2cnt     rmb  1 
fmt1cnt     rmb  1 
fmt0cnt     rmb  1 


LEFT       equ      0 
RIGHT      equ      1 
PRIZE      equ      5 


alley0e             rmb       1                            ; is there a monster in the alley? (Exists?) 
alley1e             rmb       1 
alley2e             rmb       1 
alley3e             rmb       1 
alley4e             rmb       1 
alley5e             rmb       1 
alley6e             rmb       1 
alley0d             rmb       1                            ; which way is the monster moving? (Direction) 
alley1d             rmb       1 
alley2d             rmb       1 
alley3d             rmb       1 
alley4d             rmb       1 
alley5d             rmb       1 
alley6d             rmb       1 
alley0x             rmb       1                            ; where monster is on x axis 
alley1x             rmb       1 
alley2x             rmb       1 
alley3x             rmb       1 
alley4x             rmb       1 
alley5x             rmb       1 
alley6x             rmb       1 


;ram starts at $C880 til $CBEA