org $8000

BORDER_VBLANK: equ 1
BORDER_RENDER: equ 14

camera_x: defb 0

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

    ld de, $4000        ; screen address

    ld a, BORDER_RENDER
    out ($fe), a

    ld h, tile_map / 256
    ld a, (camera_x)
    ld l, a
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

    ld h, tile_map / 256
    ld a, (camera_x)
    add a, 1
    ld l, a
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

    jp main_loop

; data sections
tile_map:
    defb 1, 2, 3, 4
    defb 1, 1, 1, 1
    defb 1, 1, 1, 1
    defb 1, 1, 1, 1

charset:
    include "charset.asm"

end start
