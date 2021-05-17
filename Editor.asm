[BITS 16]

call Func_clearscreen
jmp CODE

;##################################################

Func_clearscreen:

        push bp
        mov bp, sp
        pusha

        mov ah, 0x07        ; Tell BIOS to scroll down window
        mov al, 0x00        ; Clear entire window
        mov bh, 0x07        ; White on black
        mov cx, 0x00        ; Set screen to 0,0
        mov dh, 0x18        ; 18h = 24 rows of chars
        mov dl, 0x4f        ; 4fh = 79 cols of chars
        int 0x10            ; Call video interrupt

        popa
        mov sp, bp
        pop bp
        ret

Func_movecursor:

        push bp
        mov bp, sp
        pusha

        mov dx, [bp+4]      ; Get the argument from the stack. |bp| = 2, |arg| = 2
        mov ah, 0x02        ; Set cursor position
        mov bh, 0x00        ; Page 0
        int 0x10            ; Call video interrupt

        popa
        mov sp, bp
        pop bp
        ret

;##################################################

CODE:
    
    mov ah, 00h    ; Function code 00h for INT 16h
    int 16h        ; Pause and read the next key press

    cmp al, 08h    ; Checks for ASCII value of Backspace using 
    je KBD_BS      ; Instruction CMP [If (reg)-(value)=0 Then Goto Func]

    cmp ah, 48h  
    je KBD_up        ; Checks for ASCII value of ArrowKey Up

    cmp ah, 50h  
    je KBD_down      ; Checks for ASCII value of ArrowKey Down

    cmp ah, 4Dh  
    je KBD_right     ; Checks for ASCII value of ArrowKey Right

    cmp ah, 4Bh
    je KBD_left      ; Checks for ASCII value of ArrowKey Left

    jmp KBD_unknown  ; If key doesn't get tested before, try ASCII print

;##################################################

K_backspace:

    mov ah, 0Eh    
    mov bh, 0      ;Page 0
    mov bl, 4      ;COLOR
    mov al, 08h    ;ASCII
    int 10h
    ret

K_space:
    mov ah, 0Eh 
    mov bh, 0      ;PAGE 0
    mov bl, 4      ;COLOR
    mov al, 20h    ;ASCII
    int 10h
    ret

;##################################################

KBD_BS:
    
    call K_backspace
    call K_space
    call K_backspace
    jmp CODE

KBD_up:

    mov ah, 03h    ; Function Code 03h Get Cusor Position
    int 10h        

    mov ah, 02h    ; Function Code 02h Set Cursor Position
    sub dh, 1      ; DH = Y - 1
    mov bh, 0x00   ; PAGE 0
    int 10h

    jmp CODE       

KBD_down:

    mov ah, 03h    ; Function Code 03h Get Cusor Position
    int 10h        

    mov ah, 02h    ; Function Code 02h Set Cursor Position
    add dh, 1      ; DH = Y + 1
    mov bh, 0x00   ; PAGE 0
    int 10h

    jmp CODE

KBD_right:

    mov ah, 03h    ; Function Code 03h Get Cusor Position
    int 10h        

    mov ah, 02h    ; Function Code 02h Set Cursor Position
    add dl, 1      ; DH = X + 1
    mov bh, 0x00   ; PAGE 0
    int 10h

    jmp CODE

KBD_left:

    mov ah, 03h    ; Function Code 03h Get Cusor Position
    int 10h        

    mov ah, 02h    ; Function Code 02h Set Cursor Position
    sub dl, 1      ; DH = X - 1
    mov bh, 0x00   ; PAGE 0
    int 10h

    jmp CODE

KBD_unknown:

    mov dl, al  ; Store ASCII value from AL in DL
    mov ah, 0Eh ; Function code 0x0e for INT 10h (Teletype)
    mov bh, 0   ; Page 0
    mov bl, 4   ; Text and background colors (16 w/o blink attribute)
    mov al, dl  ; Moves back ASCII value from DL to AL

    int 10h     ; Apply Text Input and Exit
    jmp CODE

;##################################################

times 512-($-$$) db 0  ; Pad remainder of boot sector with 0s