[BITS 16]                                         ; Real Mode CPU Bootloader (512 bytes) RS:67bytes+2
[ORG 0x007C00]                                    ; Memory Location [[0x007C00(31744)//0x007DFF(32255)]]

Main_Boot_Init: 
    CLC                                           ;1; Clear The Carry Flag
    CLI	                                          ;1; Disable Interrupts 	
    mov ax,0x7C00                                 ;3; Memory Location Of Currently Executed Code
    mov ds,ax                                     ;2; Set Data Segment To Correct Memory Location
    mov ax,0x07E0                                 ;3; Set The Stack [SS:SP] With [0x07E0:0xFFFF]
    mov ss,ax                                     ;2; 64K Growing Downwards [0x007E00//0x017DFF]
    mov sp,0xFFFF                                 ;3; Lowest Address Right After This BootLoader	
    STI                                           ;1; Enable Interrupts 	
	PUSHF                                     ;1; Save FLAGS To Stack	
    JMP Disk_Reset                                ;2; JMP Move Instruction Pointer [CS:IP] 	
    CLI                                           ;1; Disable Interrupts
    HLT                                           ;1; Stop CPU Execution	
	
Main_Boot_Success:
	POPF	                                  ;1; Restore FLAGS From Stack
	JMP 0x50:0x0                              ;5; JMP Move Instruction Pointer [CS:IP] 		
	CLI                                       ;1; Disable Interrupts
	HLT                                       ;1; Stop CPU Execution	
	
Disk_Reset:		
    mov ah,00h                                    ;2; INT 13h AH=00h (Reset Disk) DL=> Disk To Reset
    INT 13h                                       ;2; AH=> Return Code CF=> Set On Error
	JNC Disk_ReadSector                       ;2; JMP IF NO ERROR (Carry Flag = 0)	
	
Disk_Reset_Fail:	
    CLC                                           ;1; Clear The Carry Flag
	JMP Disk_Reset                            ;2; JMP Move Instruction Pointer [CS:IP] 
    CLI                                           ;1; Disable Interrupts
    HLT                                           ;1; Stop CPU Execution	
	
Disk_ReadSector:
    mov ax, 0x50                                  ;3; Set Starting Address To Read Sectors Into [ES:BX] 
    mov es, ax                                    ;2; Set At The Beggining Of Usable Memory [0x000500]
    mov bx, 0x0                                   ;3; Using Segment:Offset Addressing [0x0050:0x0000]
 
    mov al, 01                                    ;2; Amount Of Sectors To Read
    mov ch, 00                                    ;2; Cylinder #
    mov cl, 02                                    ;2; Sector Location On Disk  
    mov dh, 00                                    ;2; Head #

    mov ah, 02                                    ;2; INT 13h AH=02h (Read Disk Sector) DL=> Disk To Read
    INT 13h                                       ;2; AH=> Return Code AL=> Sectors Read CF=> Set On Error
	JNC Main_Boot_Success                     ;2; JMP IF NO ERROR (Carry Flag = 0)	
	
Disk_ReadSector_Fail:
    CLC                                           ;1; Clear The Carry Flag
	JMP Disk_ReadSector                       ;2; JMP Move Instruction Pointer [CS:IP] 
    CLI                                           ;1; Disable Interrupts
    HLT                                           ;1; Stops CPU Execution

TIMES 510-($-$$) DB 0                             ; Zero Padding Until End Of Sector (-2)
DW 0xAA55                                         ; Boot Signature Bytes
