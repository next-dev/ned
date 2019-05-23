
SECTION code_user
PUBLIC  _test

_test:
                push    hl
                ld      a,$ff
                ld      hl,0x4000
                ld      (hl),a
                pop     hl
                ret
