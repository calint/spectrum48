org $8000

BORDER_VBLANK: equ 1
BORDER_RENDER: equ 14

camera_x: defb 1

start:
    ld hl, $5800        ; attribute start
    ld (hl), 7          ; white on black
    ld de, $5801        ; destination is one byte ahead
    ld bc, 767          ; remaining bytes to fill
    ldir                ; fastest hardware copy loop


main_loop:
    ld a, BORDER_VBLANK
    out ($fe), a        ; set border
    halt                ; sleep until the start of the next frame
    ld a, BORDER_RENDER ; visualize render tile map phase
    out ($fe), a

    ld de, $4000        ; screen address

    ; get tile index from map[0][camera_x]
    ld h, tile_map / 256
    ld a, (camera_x)
    ld l, a
    ld a, (hl)

    ; calculate charset address (a * 8)
    ld l, a
    ld h, 0              ; hl = index (0-255)
    add hl, hl           ; x2
    add hl, hl           ; x4
    add hl, hl           ; x8

    ld bc, charset
    add hl, bc           ; hl = pointer to tile pixels

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

    ; second row
    ld de, $4020        
    ld h, tile_map / 256
    inc h
    ld a, (camera_x)
    ld l, a
    ld a, (hl)

    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
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
    jp main_loop

org ($ + 255) & $ff00
tile_map:
    include "tile_map.asm"

charset:
    include "charset.asm"

end start
