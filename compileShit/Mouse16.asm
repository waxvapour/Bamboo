
;dedndave 16-bit mouse example

        .MODEL  Small
        .STACK  4096
        .DOSSEG
    ;    .386                 ;not used in this program
        OPTION  CaseMap:None

;####################################################################################

        .DATA

PosBuf    db '00000 00000',24h
s$Initial db 'Press Any Key to Exit',0Dh,0Ah,'Mouse Status: ',24h

;************************************************************************************

        .DATA?

PosX    dw ?
PosY    dw ?

;####################################################################################

        .CODE

;************************************************************************************

_main   PROC    FAR

;----------------------------------

;DS = DGROUP

        mov     ax,@data
        mov     ds,ax

;----------------------------------

;clear the screen

        mov     ax,500h                     ;set display page 0
        int     10h
        mov     ah,0Fh                      ;get video mode
        int     10h                         ;AL = video mode
        mov     ah,0                        ;set video mode
        int     10h

;----------------------------------

;display the initial message

        mov     dx,offset s$Initial
        mov     ah,9
        int     21h

;----------------------------------

;any key stroke will exit the program
;so we empty the keyboard buffer first

        call    KBEmpty

;----------------------------------

;initialize the mouse driver and display the status word in hex

        xor     ax,ax
        int     33h
        or      ax,ax
        jnz     ShowStatus

        jmp     ProgExit

ShowStatus:
        mov     di,offset PosBuf+10
        call    B2Hex
        inc     di
        mov     ah,9
        mov     dx,di
        int     21h

;----------------------------------

;first read of mouse position to get initial PosX and PosY values

        mov     ax,3
        int     33h
        jmp short UpdDisp

;----------------------------------

;mouse position loop

TopOfLoop:
        cmp     cx,PosX
        jnz     UpdDisp

        cmp     dx,PosY
        jz      NextPass

;initial loop entry

UpdDisp:
        mov     PosY,dx
        mov     PosX,cx
        xchg    ax,dx                       ;AX = Y position
        push    cx                          ;X position on stack
        mov     di,offset PosBuf+10
        call    B2Asc                       ;convert to decimal ASCII
        pop     ax                          ;AX = X position
        dec     di
        call    B2Asc                       ;convert to decimal ASCII
        inc     di
        push    di                          ;string offset on stack
        mov     bh,0                        ;page 0
        mov     dx,200h                     ;X = 0, Y = 2
        mov     ah,2                        ;set cursor position
        int     10h
        pop     dx                          ;DX = string offset
        mov     ah,9
        int     21h

;exit if any key is pressed

NextPass:
        mov     ah,1
        int     16h
        jnz     ProgExit

;get current position and button status

        mov     ax,3
        int     33h
        shr     bx,1                        ;carry flag if left button pressed
        jnc     TopOfLoop

;exit if they press left button and position is row 0, column 0

        mov     ax,cx
        or      ax,dx
        and     ax,0FFF8h                   ;ignore lower 3 position bits
        jnz     TopOfLoop

;----------------------------------

;terminate

ProgExit:
        mov     dl,0Dh                      ;carriage return
        mov     ah,2
        int     21h
        mov     dl,0Ah                      ;line feed
        mov     ah,2
        int     21h
        call    KBEmpty                     ;empty keyboard buffer
        mov     ax,4C00h                    ;terminate program
        int     21h

_main   ENDP

;************************************************************************************

KBEmpty PROC    NEAR

;Empty the Keyboard Buffer

        jmp short Empty1

Empty0: mov     ah,0
        int     16h

Empty1: mov     ah,1
        int     16h
        jnz     Empty0

        ret

KBEmpty ENDP

;************************************************************************************

B2Asc   PROC    NEAR

;Binary Word to ASCII decimal string, simple version

;Call With: AX = binary value to convert
;           DI = pointer to end of buffer space
;
;  Returns: Buffer filled with 5 ASCII numeric digits, no leading-zero suppression
;           DI = pointer to beginning of buffer space -1
;
;Also Uses: Math flags are altered, all other registers are preserved

        push    bx
        push    cx
        push    dx
        push    ax
        mov     bx,10
        mov     cx,5

B2Asc0: xor     dx,dx
        div     bx
        or      dl,30h
        mov     [di],dl
        dec     di
        loop    B2Asc0

        pop     ax
        pop     dx
        pop     cx
        pop     bx
        ret

B2Asc   ENDP

;************************************************************************************

B2Hex   PROC    NEAR

;Binary Word to ASCII hexadecimal string, simple version

;Call With: AX = binary value to convert
;           DI = pointer to end of buffer space
;
;  Returns: Buffer filled with 4 ASCII hexadecimal digits
;           DI = pointer to beginning of buffer space -1
;
;Also Uses: Math flags are altered, all other registers are preserved

        push    dx
        push    cx
        push    ax
        mov     dx,ax
        mov     cx,4

B2Hex0: mov     ax,dx
        and     ax,0Fh
        shr     dx,1
        shr     dx,1
        shr     dx,1
        shr     dx,1
        cmp     al,0Ah
        sbb     al,69h
        das
        mov     [di],al
        dec     di
        loop    B2Hex0

        pop     ax
        pop     cx
        pop     dx
        ret

B2Hex   ENDP

;####################################################################################

        END     _main
