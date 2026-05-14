

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
Random          EQU     0xF517   ;

Intensity_5F	EQU		0xF2A5
Print_Str_d		EQU		0xF37A
Wait_Recal		EQU		0xF192
musicd			EQU		0xFD0D
Vec_Text_Height EQU 	0xC82A
Vec_Text_Width	EQU		0xC82B
Draw_Line_d     equ     0xF3DF
Draw_VLp        equ     0xF410  
VIA_port_b      equ     0xD000 
VIA_port_a      equ     0xD001 
VIA_shift_reg   equ 	0xD00A
VIA_int_flags   equ     0xD00D
VIA_cntl        equ     0xD00C 
Reset0Ref       equ     0xF354
VIA_aux_cntl    EQU     0xD00B   ;VIA auxiliary control register

Vec_Joy_Mux_1_X equ     0xC81F   ;Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y equ     0xC820   ;Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X equ     0xC821   ;Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y equ     0xC822   ;Joystick 2 Y enable/mux flag (=7)




VIA_t1_cnt_hi   EQU     0xD005   ;VIA timer 1 count register hi

Vec_Music_Flag  equ     0xC856  
Clear_Score     equ     0xF84F 
Read_Btns       equ     0xF1BA 

Joy_Digital     equ     0xF1F8
Vec_Joy_1_Y     EQU     0xC81C   ;Joystick 1 up/down
Vec_Joy_1_X     equ     0xC81B   ;Joystick 1 left/right
Add_Score_a     equ     0xF85E

New_High_Score  equ     0xF8D8