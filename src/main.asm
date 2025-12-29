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
 
    ld a, BORDER_RENDER ; visualize render tile map phase
    out ($fe), a

;input:
    ; check 'A' (left) and 'D' (right)
    ld bc, $fdfe        ; row A, S, D, F, G
    in a, (c)           ; read port

;.check_a:
    bit 0, a            ; bit 0 is 'A'
    jr nz, .check_d     ; if not pressed, check d
    ld hl, camera_x
    dec (hl)            ; move camera left

.check_d:
    bit 2, a            ; bit 2 is 'D'
    jr nz, .done        ; if not pressed, check w row
    ld hl, camera_x
    inc (hl)            ; move camera right

.done:

;render:
    ld a, (camera_x)
    ld ixl, a
    ld a, 0             ; current loop column (0-31)
.loop:
    ld ixh, a           ; save A
    include "render_rows.asm"
    ld a, ixh           ; restore A
    inc a
    cp 32
    jp nz, .loop

    jp main_loop

org ($ + 2047) & $ff00
charset:
    include "charset.asm"

org ($ + 255) & $ff00
tile_map:
    include "tile_map.asm"

end start
