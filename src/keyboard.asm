;;----------------------------------------------------------------------------------------------------------------------
;; Keyboard routines
;; Lifted and adapated from:
;;
;; https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/input/zx/z80/asm_in_inkey.asm
;; https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/input/zx/z80/in_key_translation_table.asm
;;
;;----------------------------------------------------------------------------------------------------------------------

SECTION interrupt_vector

                defs    257,$81         ; Interrupt vector table

BUFFERPAGE      equ     $83

SECTION code_user
PUBLIC _initKeys, _doneKeys

_initKeys:
                di
                ld      a,$80
                ld      i,a
                im      2
                ei
                ret

_doneKeys:       di
                im      1
                ei
                ret

; Scans the keyboard and returns button code - runs in IM 2
;
; Rows are:
;   Bits:   0       1       2       3       4
;   ----------------------------------------------
;   $FE     Caps    Z       X       C       V
;   $FD     A       S       D       F       G
;   $FB     Q       W       E       R       T
;   $F7     1       2       3       4       5
;   $EF     0       9       8       7       6
;   $DF     P       O       I       U       Y
;   $BF     Enter   L       K       J       H
;   $7F     Space   Sym     M       N       B
;
; Keyboard ASCII codes (00-1F)
;
;   00                      10  Sym+W
;   01  Edit                11  Sym+E
;   02  Capslock            12  Sym+I
;   03  True Video          13  
;   04  Inv Video           14  
;   05  Left                15  
;   06  Down                16  
;   07  Up                  17  
;   08  Right               18  
;   09  Graph/TAB           19  
;   0A  Delete              1A  
;   0B                      1B  Break (Caps & Space)
;   0C                      1C  (Sym & Space)
;   0D  Enter               1D  Shift+Enter
;   0E                      1E  Sym+Enter
;   0F                      1F           
;
; Keyboard ASCII codes (80-FF)
;
;   80 - Extended Mode
;   8D - Ext+Enter
;   A0 - Ext+Space
;   B0-B9 - Ext+Number
;   E1-FA - Ext+Letter

SECTION ISR
                org     $8181

ImRoutine:
                di
                push    af
                push    bc
                push    de
                push    hl
                push    ix
                call    KeyScan         ; HL = Keyboard table

                ; Update shift statuses
                push    hl
                pop     ix
                xor     a
                bit     0,(ix+14)       ; Test for Caps (row 7 * 2 bytes)
                jr      z,no_caps
                or      40
no_caps:        bit     1,(ix+12)       ; Test for symbol shift (row 6 * 2 bytes)
                jr      z,no_sym
                or      80
no_sym:         ex      de,hl           ; DE = keyboard snapshot
                ld      hl,KeyTrans
                add     hl,a            ; HL = Key translation table

                ld      ix,KBufferState ; Required for buffer routines
                ; Now we scan our keyboard snapshot, and any keys that are detected to be pressed are added to
                ; the circular buffer
                ld      b,8
row:            ld      a,(de)          ; A = keyboard state for current row
                inc     de
                ld      c,a             ; C = keyboard state for current row
                ld      a,(de)          ; A = last keyboard state
                inc     de
                xor     $ff
                and     c               ; A = edge detected key state (!A + C)
                push    hl              ; Store the current key translation table position

col:            and     a               ; Any keys pressed on entire row?
                jr      z,end_row

                srl     a               ; Key pressed?
                jr      nc,ignore

                ld      c,(hl)          ; C = ASCII character
                inc     c               ; C == $ff?
                jr      z,ignore
                dec     c
                push    bc
                ld      b,BUFFERPAGE
                call    BufferInsert    ; Insert into circular buffer
                pop     bc
ignore:         inc     hl              ; Next entry into table
                jr      col

end_row:        ld      a,5
                pop     hl
                add     hl,a            ; Next row of table
                djnz    row

                ; Fetch a character
                ld      hl,KFlags
                bit     0,(hl)
                jr      nz,finish      ; Still haven't processed last key yet

                ld      b,BUFFERPAGE
                call    BufferRead
                jr      z,no_chars
                ld      (Key),a         ; Next key available
                set     0,(hl)          ; Key ready!
                jr      finish

no_chars:       xor     a
                ld      (Key),a

finish:
                ; Advance counter
                ld      hl,(Counter)
                inc     hl
                ld      (Counter),hl
                pop     ix
                pop     hl
                pop     de
                pop     bc
                pop     af
                ei
                reti

KBufferState:   defw    $0100
Keys:           defs    16      ; Double-buffered interleaved space to store the key presses
                                ; NEW OLD NEW OLD NEW OLD...
                                ; Thought about having a dynamic pointer to switch buffers but it turns out
                                ; that having fixed buffers makes things easier later on

KeyScan:
                ; Output:
                ;   HL = pointer to keyscan
                ; Destroys
                ;   BC, DE, A

                ld      hl,Keys

                ; Scan the keyboard
                ld      bc,$fdfe        ; Keyboard ports (start here to make sure shift rows are last)
                push    hl
                ld      e,8             ; There are 8 ports to read

l1:             ld      d,(hl)          ; Get old state
                in      a,(c)
                cpl
                and     $1f
                ld      (hl),a          ; Store new state
                inc     hl
                ld      (hl),d          ; Store old state
                inc     hl
                rlc     b
                dec     e
                jr      nz,l1
                pop     hl          ; Restore pointer to buffer
                ret

;;----------------------------------------------------------------------------------------------------------------------

Key:            defb    0               ; Latest ASCII character
KFlags:         defb    0               ; Bit 0 = character available, reset when test
Counter:        defw    0               ; 50/60Hz counter

;;----------------------------------------------------------------------------------------------------------------------

KeyTrans:
        ; Unshifted
        defb    'a','s','d','f','g'                             ; A-G
        defb    'q','w','e','r','t'                             ; Q-T
        defb    '1','2','3','4','5'                             ; 1-5
        defb    '0','9','8','7','6'                             ; 0-6
        defb    'p','o','i','u','y'                             ; P-Y
        defb    $0d,'l','k','j','h'                             ; Enter-H
        defb    ' ',$ff,'m','n','b'                             ; Space-B
        defb    $ff,'z','x','c','v'                             ; Caps-V

        ; CAPS shifted
        defb    'A','S','D','F','G'                             ; A-G
        defb    'Q','W','E','R','T'                             ; Q-T
        defb    $01,$02,$03,$04,$05                             ; 1-5
        defb    $0a,$09,$08,$07,$06                             ; 0-6
        defb    'P','O','I','U','Y'                             ; P-Y
        defb    $1d,'L','K','J','H'                             ; Enter-H
        defb    $1b,$ff,'M','N','B'                             ; Space-B
        defb    $ff,'Z','X','C','V'                             ; Caps-V

        ; SYM shifted
        defb    '~','|','\'','{','}'                            ; A-G
        defb    $7f,'w','e','<','>'                             ; Q-T
        defb    '!','@','#','$','%'                             ; 1-5
        defb    '_',')','(',$27,'&'                             ; 0-6
        defb    $22,';','i',']','['                             ; P-Y
        defb    $1e,'=','+','-','^'                             ; Enter-H
        defb    $1c,$ff,'.',',','*'                             ; Space-B
        defb    $ff,':','`','?','/'                             ; Caps-V

        ; EXT shifted
        defb    'a'+$80,'s'+$80,'d'+$80,'f'+$80,'g'+$80         ; A-G
        defb    'q'+$80,'w'+$80,'e'+$80,'r'+$80,'t'+$80         ; Q-T
        defb    '1'+$80,'2'+$80,'3'+$80,'4'+$80,'5'+$80         ; 1-5
        defb    '0'+$80,'9'+$80,'8'+$80,'7'+$80,'6'+$80         ; 0-6
        defb    'p'+$80,'o'+$80,'i'+$80,'u'+$80,'y'+$80         ; P-Y
        defb    $8d,    'l'+$80,'k'+$80,'j'+$80,'h'+$80         ; Enter-H
        defb    $a0,    $ff,    'm'+$80,'n'+$80,'b'+$80         ; Space-B
        defb    $ff,    'z'+$80,'x'+$80,'c'+$80,'v'+$80         ; Caps-V

;;----------------------------------------------------------------------------------------------------------------------
;; Circular buffer

; Empty buffer:
;
;       +-------------------------------------------+
;                       ^^
;                       RW
;
;       R points to just before read point
;       W points at new place to write
;       R should never meet W while reading
;
; Full buffer
;       +XXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXX+
;                       ^
;                       R
;                       W

BufferInsert:
                ; Input:
                ;       B = Buffer page
                ;       C = Value to insert
                ;       IX = Pointer to read/write pointers
                ; Note:
                ;       The value that IX points to must be a 16-bit value initialised to BUFFER_START
                ;
                push    hl
                push    af

                ld      a,(ix+0)
                cp      (ix+1)          ; Has PWrite reached PRead yet?
                ret     z               ; Return without error (buffer is full)

                ld      l,(ix+1)
                ld      h,b             ; HL = write address
                ld      (hl),c          ; write value in buffer
                inc     (ix+1)
                pop     af
                pop     hl
                ret

BufferRead:     ; Input:
                ;       B = Buffer page
                ;       IX = Pointer to read/write pointers
                ; Output
                ;       A = Value
                ;       B = Buffer page
                ;       ZF = 1 if nothing to read
                ; Note:
                ;       The value that IX points to must be a 16-bit value initialised to BUFFER_START
                ;
                push    hl
                ld      a,(ix+1)
                dec     a
                cp      (ix+0)            ; Buffer is empty?
                jr      z,EmptyBuffer

                inc     (ix+0)            ; Advance read pointer
                ld      l,(ix+0)
                ld      h,b             ; HL = buffer pointer
                ld      a,(hl)          ; Read data
                and     a               ; Clear ZF
EmptyBuffer:    pop     hl
                ret

