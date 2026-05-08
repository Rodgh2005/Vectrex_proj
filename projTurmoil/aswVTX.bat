@echo on
cd %2
asm6809 -B -o mainteste.bin mainteste.asm
if not "%errorlevel%"=="0" goto Abandon



:Abandon
if "%3"=="nopause" exit
pause