org $8000

border: equ 5
camera_x: equ 0

start:
    ld a, border
    out ($fe), a        ; set border

    ld de, $4000        ; top-left of screen
    ld bc, tile_map

    ; 1. get tile index from map
    ld hl, tile_map     ; point hl to map
    ld bc, camera_x
    add hl, bc
    ld a, (hl)          ; a = 0 (the first byte)

    ; 2. calculate charset address (a * 8)
    ; we use 'add a, a' three times to multiply by 8
    add a, a            ; a = index * 2
    add a, a            ; a = index * 4
    add a, a            ; a = index * 8

    ; add the base address of charset to our offset
    ld l, a             ; put offset in l
    ld h, 0             ; clear h
    ld bc, charset      ; get base address
    add hl, bc          ; hl now points to the first pixel byte

    ; 4. unrolled blit (8 scanlines)
    ; we load a byte, write it, move pointers, and repeat
    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc d
    ; we don't need to inc hl/d on the last one

    ; second row
    ld a, d
    sub 8
    ld d, a

    ld a, e
    add a, 32           ; move down one character row (32 bytes)
    ld e, a             ; de now points to $4020 (row 1, col 0)

    ; 1. get tile index from map
    ld hl, tile_map     ; point hl to map
    ld bc, 1
    add hl, bc
    ld a, (hl)          ; a = 0 (the first byte)

    ; 2. calculate charset address (a * 8)
    ; we use 'add a, a' three times to multiply by 8
    add a, a            ; a = index * 2
    add a, a            ; a = index * 4
    add a, a            ; a = index * 8

    ; add the base address of charset to our offset
    ld l, a             ; put offset in l
    ld h, 0             ; clear h
    ld bc, charset      ; get base address
    add hl, bc          ; hl now points to the first pixel byte

    ; 4. unrolled blit (8 scanlines)
    ; we load a byte, write it, move pointers, and repeat
    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    inc hl
    inc d

    ld a, (hl)
    ld (de), a
    ; we don't need to inc hl/d on the last one

    ret

; data sections
tile_map:
    defb 0, 1, 0, 1
    defb 1, 0, 1, 0
    defb 0, 1, 0, 1
    defb 1, 0, 1, 0

charset:
; tile 0
    defb %10000001      ; x      x
    defb %11000010      ; xx     x
    defb %01100100      ;  xx   x
    defb %00110000      ;   xx
    defb %00011000      ;    xx
    defb %00101100      ;   x xx
    defb %01000110      ;  x   xx
    defb %10000011      ; x      xx

; tile 1
    defb %00111100      ;   xxxx
    defb %01111110      ;  xxxxxx
    defb %11011011      ; xx xx xx
    defb %11111111      ; xxxxxxxx
    defb %11111111      ; xxxxxxxx
    defb %11011011      ; xx xx xx
    defb %01111110      ;  xxxxxx
    defb %00111100      ;   xxxx

end start
