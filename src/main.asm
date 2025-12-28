org $8000
BORDER_VBLANK: equ 1
BORDER_RENDER: equ 14

camera_x: defb 2

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

    ; increment camera_x for scrolling
    ld a, (camera_x)
    inc a
    ld (camera_x), a

    ld c, 0             ; c = current loop column (0-31)
column_loop:
    include "render_rows.asm"
    inc c
    ld a, c
    cp 32
    jp nz, column_loop

    jp main_loop

org ($ + 255) & $ff00
tile_map:
    include "tile_map.asm"

charset:
    include "charset.asm"

end start
