;;----------------------------------------------------------------------------------------------------------------------
;; Memory management
;;
;; This will manage text buffer pages, and 8K arenas
;;----------------------------------------------------------------------------------------------------------------------

SECTION code_user

PUBLIC _arenaNew, _arenaDone, _arenaPageAlign, _arenaAlloc, _arenaPrepare
EXTERN _ZXN_WRITE_MMU6

IDE_BANK        equ     $01bd
M_P3DOS         equ     $94

; Arena meta-data formnat
ARENAHDR_PAGES          equ     $c000
ARENAHDR_NUMPAGES       equ     $c0e0
ARENAHDR_NEXTOFFSET     equ     $c0e1
ARENAHDR_NEXTPAGE       equ     $c0e3

;;----------------------------------------------------------------------------------------------------------------------
;; allocPage
;; Ask NextZXOS for a page and returns page in E (0 == fail)
;;
;; Output:
;;      A = page number (or 0 if failed)
;;
allocPage:
                ;#todo: Ensure layer 2 writes are disabled

                push    ix
                push    bc
                push    de
                push    hl

                ; Allocate a page
                ld      hl,$0001        ; Allocate a ZX memory 8K bank
                exx
                ld      de,IDE_BANK
                ld      c,7
                rst     8
                defb    M_P3DOS         ; E = new page #
                jr      c,allocPage_Success
                xor     a
                ld      e,a

allocPage_Success:
                ld      a,e
                pop     hl
                pop     de
                pop     bc
                pop     ix
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; freePage
;; Give a page back to NextZXOS.
;;
;; Input:
;;      A = page number
;;
freePage:
                push    af
                push    ix
                push    bc
                push    de
                push    hl

                ld      e,a                     ; E = page to free
                ld      hl,$0003                ; Free bank
                exx
                ld      de,IDE_BANK
                ld      c,7
                rst     8
                defb    M_P3DOS

                pop     hl
                pop     de
                pop     bc
                pop     ix
                pop     af
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaNew -> u8 (handle)
;;
;; Output:
;;      L = handle
;;

_arenaNew:
                push    af
                push    de
                push    hl
                call    allocPage               ; A = page #
                and     a
                jr      z,arenaNew_fail
                ld      e,a

                nextreg $56,a
                ld      a,1
                ld      (ARENAHDR_NUMPAGES),a           ; Store number of pages
                ld      hl,228
                ld      (ARENAHDR_NEXTOFFSET),hl        ; Store 2 LSB of big pointer
                ld      a,e
                ld      (ARENAHDR_PAGES),a              ; Store first page number in chain
                ld      (ARENAHDR_NEXTPAGE),a                       ; Store 1 MSB of big pointer

arenaNew_fail:
                ld      l,a
                pop     de
                ld      h,d                     ; Restore H
                pop     de
                pop     af
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaDone(u8 handle)
;;
;; Input:
;;      L = handle
;;

_arenaDone:
                push    af
                push    bc
                push    hl

                ; Page in the first page of the chain to get access to meta-data
                ld      a,l
                ld      c,l                     ; C = Page # of meta-data
                nextreg $56,a
                ld      a,(ARENAHDR_NUMPAGES)
                ld      b,a                     ; B = # of pages in chain
                ld      h,$c0
                ld      l,b
                dec     l                       ; HL points to last entry in page table

arenaDone_L1:
                ld      a,(hl)                  ; A = next page to free
                call    freePage
                dec     hl
                ld      a,c
                nextreg $56,a                   ; Ensure meta-data still exists
                djnz    arenaDone_L1            ; Repeat for all pages

                pop     hl
                pop     bc
                pop     af
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaPageAlign(u8 handle) -> page
;;
;; Input:
;;      L = handle
;; Output:
;;      L = page # of new page
;;

_arenaPageAlign:
                push    af
                push    de
                push    hl

                ld      a,l             ; A = page #
                nextreg $56,a           ; Switch to it so we can see the meta-data
                ld      h,$c0           ; HL = address in page table
                call    allocPage       ; A = new page # or 0
                and     a
                jr      z,allocPage_error

                ld      e,a             ; Store new page #
                ld      a,l
                nextreg $56,a           ; Ensure header page is in
                ld      a,(ARENAHDR_NUMPAGES)
                ld      l,a             ; HL = entry in page table
                ld      (hl),e          ; Add new page in page table
                inc     a               ; We have one more page!
                ld      (ARENAHDR_NUMPAGES),a
                ld      hl,ARENAHDR_NEXTOFFSET
                ld      (hl),0          ; Next free address in at beginning of page
                inc     hl
                ld      (hl),0
                ld      a,e             ; A = page #
                ld      (ARENAHDR_NEXTPAGE),a

                nextreg $56,a           ; Switch to that page (as a convenience)

allocPage_error:
                ld      l,a
                pop     de
                ld      h,d
                pop     de
                pop     af
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaAlloc(u8 handle, u16 size) -> address

_arenaAlloc:
                pop     bc                              ; BC = return address
                pop     de                              ; E = handle
                dec     sp
                pop     hl                              ; HL = size

                push    bc                              ; Restore return address
                push    af
                push    bc

                ; Fetch  parameters
                ; Check to see if the size is <= 8K
                ld      a,h
                and     $e0                             ; Top 3 bits should be 0
                jr      nz,arenaAlloc_error

                ; Obtain how much space on the current page
                ld      a,e
                nextreg $56,a                           ; Switch to first page
                ld      a,(ARENAHDR_NEXTOFFSET)
                ld      c,a
                ld      a,(ARENAHDR_NEXTOFFSET+1)
                ld      b,a                             ; BC = number of bytes used in latest page
                push    hl                              ; Store size
                add     hl,bc                           ; Number of bytes + size <= 8K?

                ; Make sure HL <= $2000 (8K), because if not, we need to allocate a new page and start
                ; the allocation there
                ld      a,h
                cp      $20
                jr      c,arenaAlloc_alloc              ; < 8K so continue allocating
                jr      nz,arenaAlloc_nospace           ; > 8K so require new page
                ld      a,l
                and     a
                jr      z,arenaAlloc_alloc              ; == 8K so continue allocating

arenaAlloc_nospace:
                ; Otherwise, we need to add a new page
                ld      l,e                             ; L = handle
                call    _arenaPageAlign                 ; L = handle of new page
                pop     hl                              ; HL = size (and also LSB of address)
                ld      bc,0
                jr      arenaAlloc_continue

arenaAlloc_alloc:
                pop     af                              ; Drop the value pushed on the stack

arenaAlloc_continue:
                ; At this point HL is the new offset in the latest page and BC is the beginning of the
                ; allocated memory.
                ld      a,e
                nextreg $56,a                           ; Go back to first page
                push    af                              ; Store handle

                ld      a,l
                ld      (ARENAHDR_NEXTOFFSET),a
                ld      a,h
                ld      (ARENAHDR_NEXTOFFSET+1),a       ; Store the new address
                ld      d,0
                ld      a,(ARENAHDR_NEXTPAGE)
                ld      e,a
                ld      h,b
                ld      l,c                             ; DEHL = address of memory

                ; Check to see if memory allocation exactly fills up the page, if so create new one
                ld      a,(ARENAHDR_NEXTOFFSET+1)
                and     $e0                             ; Filled up page?
                jr      z,arenaAlloc_end

                pop     af
                push    hl
                ld      l,a
                call    _arenaPageAlign
                pop     hl                              ; DEHL = still address of memory
                push    af

arenaAlloc_end:
                pop     af
                pop     bc
                pop     af
                ret

arenaAlloc_error:
                ld      hl,0
                ld      de,0
                ret

;;----------------------------------------------------------------------------------------------------------------------
;; arenaPrepare(u32 address) -> u8*
;;
;; Input:
;;      DEHL = address
;; Output:
;;      HL = real address

_arenaPrepare:
                ; At this point E contains the page number and HL the offset into range $c000-$bfff.
                push    af
                ld      a,e
                nextreg $56,a

                ld      a,h
                add     a,$c0
                ld      h,a             ; HL += $c000

                pop     af
                ret

