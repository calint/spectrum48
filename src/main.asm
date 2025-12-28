org $8000

border: equ 5

camera_x: defb 3

start:
    ld a, border
    out ($fe), a        ; set border

    ld de, $4000        ; screen address

    ld hl, tile_map
    ld a, (hl)
    add a, a
    add a, a
    add a, a

    ld l, a
    ld h, 0
    ld bc, charset
    add hl, bc

    ; first row
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

    ; second row
    ld a, d
    sub 8
    ld d, a

    ld a, e
    add a, 32
    ld e, a

    ld hl, tile_map
    inc l
    ld a, (hl)
    add a, a
    add a, a
    add a, a

    ld l, a
    ld h, 0
    ld bc, charset
    add hl, bc

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

    ret

; data sections
tile_map:
    defb 1, 0, 1, 1
    defb 1, 1, 1, 1
    defb 1, 1, 1, 1
    defb 1, 1, 1, 1

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
