
;https://github.com/gauze/Turmoil/blob/master/include/vars.i
;{{{ Variable RAM SECTION}}}}

	;org $C880

LEFT       equ      0 
RIGHT      equ      1 
PRIZE      equ      5 

POS_X   EQU $C880         ; Reserva 1 byte para a posição X starts 7 bytes
shipYpos  equ POS_X + 1						;posicao Y
shipXpos  equ shipYpos + 2					;posicao do x

Ship_Dead equ	shipXpos +  1
Demo_Mode equ   Ship_Dead + 1
shipspeed equ	Demo_Mode +	1
In_Alley  equ	shipspeed +	1				;ship is in ( está num beco)
stallcnt  equ	In_Alley + 1              ;generic slow down

shipdir  equ   stallcnt + 1                            ; left or right 

Ship_Dead_Cnt equ  shipdir + 1                            ; used for scale control 
; frame counts for animations/speed
frm100cnt   equ Ship_Dead_Cnt +  1 
frm50cnt    equ frm100cnt +  1 
frm25cnt    equ frm50cnt +  1 
frm20cnt    equ frm25cnt +  1 
frm10cnt    equ frm20cnt +  1 
frm5cnt     equ frm10cnt +  1 
frm4cnt     equ frm5cnt +  1 
frm3cnt     equ frm4cnt +  1 
frm2cnt     equ frm3cnt +  1 
fmt1cnt     equ frm2cnt +  1 
fmt0cnt     equ fmt1cnt +  1 

Ship_Dead_Anim  equ fmt0cnt + 1 




alley0e             equ Ship_Dead_Anim + 1                            ; is there a monster in the alley? (Exists?) 
alley1e             equ alley0e + 1 
alley2e             equ alley1e + 1        
alley3e             equ alley2e + 1        
alley4e             equ alley3e + 1       
alley5e             equ alley4e + 1
alley6e             equ alley5e + 1        
alley0d             equ alley6e + 1                            ; which way is the monster moving? (Direction) 
alley1d             equ alley0d + 1 
alley2d             equ alley1d + 1 
alley3d             equ alley2d + 1 
alley4d             equ alley3d + 1 
alley5d             equ alley4d + 1 
alley6d             equ alley5d + 1 
alley0x             equ alley6d + 1                            ; where monster is on x axis 
alley1x             equ alley0x + 1 
alley2x             equ alley1x + 1 
alley3x             equ alley2x + 1 
alley4x             equ alley3x + 1 
alley5x             equ alley4x + 1 
alley6x             equ alley5x + 1 


select_level_flag   equ alley6x + 1
level               equ select_level_flag + 1
score				equ level + 7







;ram starts at $C880 til $CBEA