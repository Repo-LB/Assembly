@Echo Off
TITLE NASM - QUICKCOMPILE
CD "PATH-TO-DIRECTORY"

:Start
COLOR 09
CLS
ECHO(
ECHO Assembly Quick Compiler (Using NASM)
ECHO(
FOR /F "skip=4 tokens=*" %%i IN ('dir *.asm') DO (ECHO [97m%%i)
ECHO(
SET /P TargetImage="[94mDisk Image Name: [97m"
SET /P TargetFiles="[94mFiles To Compile (Without Extention): [97m"
ECHO(

SET Counter=0
FOR %%A IN (%TargetFiles%) DO (CALL :QCompile %%A)
IF %TargetImage%=="" (EXIT)
ECHO(
ECHO [94mFiles Compiled ... Creating Disc Image[97m
ECHO(
PING localhost -n 2 > NUL
COPY /Y/B %BootMaster%.bin + %BootSlave%.bin %TargetImage%.img
ECHO(
PAUSE > NUL
EXIT

:QCompile
SET FileName=%1
SET /A Counter+=1
IF %Counter% EQU 1 (SET BootMaster=%FileName%)
IF %Counter% EQU 2 (SET BootSlave=%FileName%)
nasm %FileName%.asm -f bin -o %FileName%.bin
IF %errorlevel% EQU 0 (CALL :Success %FileName%) ELSE (CALL :Failure %FileName%)
GOTO :eof

:Success
ECHO [92mSuccess - - - %1.asm[94m
PING localhost -n 1 > NUL
GOTO :eof

:Failure
ECHO [91mFailure - - - %1.asm[94m
PAUSE > NUL
GOTO :eof