;;----------------------------------------------------------------------------------------------------------------------
;; Memory management
;;
;; This will manage text buffer pages, and 8K arenas
;;----------------------------------------------------------------------------------------------------------------------

SECTION code_user

PUBLIC _arenaNew

IDE_BANK        equ     $01bd
M_P3DOS         equ     $94

;;----------------------------------------------------------------------------------------------------------------------
;; allocPage
;; Ask NextZXOS for a page and returns page in E (0 == fail)
;;
;; Output:
;;      E = page number (or 0 if failed)
;; Uses:
;;      D

allocPage:
                ;#todo: Ensure layer 2 writes are disabled

                push    ix
                push    bc
                push    hl

                ; Allocate a page
                ld      hl,$0100        ; Allocate a ZX memory 8K bank
                exx
                ld      de,IDE_BANK
                ld      c,7
                rst     8
                defb    M_P3DOS
                jr      c,allocPage_Success
                xor     a
                ld      e,a

allocPage_Success:
                pop     hl
                pop     bc
                pop     ix
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaNew -> u8 (handle)
;;

_arenaNew:
                jp      allocPage
