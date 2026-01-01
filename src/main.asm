org $8000
;-------------------------------------------------------------------------------
; constants
;-------------------------------------------------------------------------------
BORDER_VBLANK           equ 1
BORDER_RENDER_TILE_MAP  equ 14
BORDER_RENDER_SPRITES   equ 4
BORDER_INPUT            equ 9

; tunable constants
SUBPIXELS  equ 4

GRAVITY           equ 3
GRAVITY_INTERVAL  equ %1111

HERO_SPRITE_BIT       equ 1
HERO_MOVE_DX          equ 8
HERO_JUMP_VELOCITY    equ 33
HERO_SKIP_VELOCITY    equ 20
HERO_SKIP_INTERVAL    equ %1111

; hard constants
HERO_FLAG_RESTARTING  equ 1
HERO_FLAG_MOVING      equ 2
HERO_FLAG_JUMPING     equ 4

;-------------------------------------------------------------------------------
; variables
;-------------------------------------------------------------------------------
sprites_collision_bits: db 0   ; 8 bits for sprite collisions

camera_x      db -16
camera_x_prv  db $ff

hero_frame_counter  db 0

hero_x      dw 132 << SUBPIXELS 
hero_y      dw 0
hero_dx     dw 0 ; horizontal velocity
hero_dy     dw 0 ; vertical velocity
hero_x_prv  dw 132 << SUBPIXELS ; previous frame state
hero_y_prv  dw 0                ; previous framet state
hero_x_drw  db 132 ; previous x for render sprite
hero_y_drw  db 0   ; previous y render sprite
hero_flags  db 0


; used by `render_sprite`
render_sprite_collision  db 0 ; if non-zero sprite collided with drawn content

;-------------------------------------------------------------------------------
start:
;-------------------------------------------------------------------------------
    ld hl, $5800        ; attribute start
    ld (hl), 7          ; white on black
    ld de, $5801        ; destination is one byte ahead
    ld bc, 767          ; remaining bytes to fill
    ldir                ; fastest hardware copy loop

;-------------------------------------------------------------------------------
main_loop:
;-------------------------------------------------------------------------------
    ld a, BORDER_VBLANK
    out ($fe), a

    halt                ; sleep until the start of the next frame
 
    ; check if camera position changed triggering a re-draw of tile map
    ld hl, camera_x_prv
    ld a, (camera_x)
    cp (hl)
    jp z, render_sprites
    ld (hl), a

;-------------------------------------------------------------------------------
render_tile_map:
;-------------------------------------------------------------------------------
    ld a, BORDER_RENDER_TILE_MAP
    out ($fe), a

    ld a, (camera_x)
    ld ixl, a
    ld a, 0             ; current loop column (0-31)
_loop:
    ld ixh, a           ; save A
    include "render_rows.asm"
    ld a, ixh           ; restore A
    inc a
    cp 32
    jp nz, _loop

;-------------------------------------------------------------------------------
render_sprites:
;-------------------------------------------------------------------------------
    ld a, BORDER_RENDER_SPRITES
    out ($fe), a

    xor a
    ld (sprites_collision_bits), a

    ; render hero

    ; restore dirty tiles

    ; call restore_sprite_background
    ; B = hero_x_prv >> SUBPIXELS
    ld a, (hero_x_drw)
    ld b, a
    ; C = hero_y_prv >> SUBPIXELS
    ld a, (hero_y_drw)
    ld c, a
    call restore_sprite_background

    ; call render_sprite
    ld hl, (hero_x)
    rept SUBPIXELS
        srl h
        rr  l
    endm
    ld b, l
    ld a, b
    ld (hero_x_drw), a
    ; C = hero_y_prv >> SUBPIXELS
    ld hl, (hero_y)
    rept SUBPIXELS
        srl h
        rr  l
    endm
    ld c, l
    ld a, c
    ld (hero_y_drw), a
    ld ix, sprites_data_8
    call render_sprite

    ; update sprites collision bits
    ld a, (render_sprite_collision)
    or a
    jr z, _no_collision
    ld a, (sprites_collision_bits)
    or HERO_SPRITE_BIT
    ld (sprites_collision_bits), a
_no_collision:

    ; done render hero
    ; debugging on screen
    ld a, (sprites_collision_bits)
    ld hl, $401f
    ld (hl), a

;-------------------------------------------------------------------------------
collisions:
;-------------------------------------------------------------------------------
    ; check collision
    ld a, (sprites_collision_bits)
    and HERO_SPRITE_BIT
    jr z, _done

    ; restore previous position and set dx, dy to 0
    ld hl, (hero_x_prv)
    ld (hero_x), hl
    ld hl, (hero_y_prv)
    ld (hero_y), hl
    ld hl, 0
    ld (hero_dx), hl
    ld (hero_dy), hl

    ; clear flags
    ld a, (hero_flags)
    and ~HERO_FLAG_JUMPING & ~HERO_FLAG_RESTARTING
    ld (hero_flags), a

_done:

;-------------------------------------------------------------------------------
state:
;-------------------------------------------------------------------------------
    ; save state to prv
    ld hl, (hero_x)
    ld (hero_x_prv), hl
    ld hl, (hero_y)
    ld (hero_y_prv), hl

;-------------------------------------------------------------------------------
input:
;-------------------------------------------------------------------------------
    ld a, BORDER_INPUT
    out ($fe), a

    ; set horizontal velocity to 0
    ld hl, 0
    ld (hero_dx), hl

_check_camera:
    ld bc, $bffe        ; row: enter, l, k, j, h
    in a, (c)           ; read row (0 = pressed)

_check_camera_left:
    bit 3, a
    jr nz, _check_camera_left_done

    ; adjust camera x
    ld hl, camera_x
    dec (hl)

    ; adjust hero x
    ld hl, (hero_x)
    ld de, 8 << SUBPIXELS
    add hl, de
    ld (hero_x), hl
    ld (hero_x_prv), hl

_check_camera_left_done:

_check_camera_right:
    bit 1, a
    jr nz, _check_camera_right_done

    ; adjust camera x
    ld hl, camera_x
    inc (hl)

    ; adjust hero x
    ld hl, (hero_x)
    ld de, -(8 << SUBPIXELS)
    add hl, de
    ld (hero_x), hl
    ld (hero_x_prv), hl

_check_camera_right_done:

_check_hero:
    ld bc, $fdfe        ; row for a, s, d, f, g
    in b, (c)           ; read row (0 = pressed)

_check_hero_left:
    bit 0, b
    jr nz, _check_hero_left_done

    ; flag hero is moving
    ld a, (hero_flags)
    or HERO_FLAG_MOVING
    ld (hero_flags), a

    ; set dx
    ld hl, -HERO_MOVE_DX
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame_counter)
    and HERO_SKIP_INTERVAL
    jr nz, _check_hero_left_done

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_left_done

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_VELOCITY 
    ld (hero_dy), hl

_check_hero_left_done:

_check_hero_right:
    bit 2, b
    jr nz, _check_hero_right_done

    ; flag hero moving
    ld a, (hero_flags)
    or HERO_FLAG_MOVING
    ld (hero_flags), a

    ; set dx
    ld hl, HERO_MOVE_DX
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame_counter)
    and HERO_SKIP_INTERVAL
    jr nz, _check_hero_right_done

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_right_done

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_VELOCITY 
    ld (hero_dy), hl
    ld hl, HERO_MOVE_DX
    ld (hero_dx), hl

_check_hero_right_done:

_check_hero_jump:
    bit 4, b
    jr nz, _check_hero_jump_done

    ; if hero is jumping jump to don
    ld a, (hero_flags)
    and HERO_FLAG_JUMPING
    jr nz, _check_hero_jump_done

    ; set jump velocity
    ld hl, -HERO_JUMP_VELOCITY
    ld (hero_dy), hl

    ; flag hero with moving and jumping
    ld a, HERO_FLAG_MOVING | HERO_FLAG_JUMPING
    ld (hero_flags), a

_check_hero_jump_done:

;-------------------------------------------------------------------------------
physics:
;-------------------------------------------------------------------------------
    ; add velocity to position
    ld hl, (hero_x)
    ld de, (hero_dx)
    add hl, de
    ld (hero_x), hl
    ld hl, (hero_y)
    ld de, (hero_dy)
    add hl, de
    ld (hero_y), hl

    ; if hero is jumping then jump to gravity
    ld a, (hero_flags)
    and HERO_FLAG_JUMPING
    jr nz, _gravity

    ; apply gravity in intervals
    ld a, (hero_frame_counter)
    inc a
    ld (hero_frame_counter), a
    and GRAVITY_INTERVAL
    jr z, _gravity

    ; if no vertical movement jump over gravity
    ld hl, (hero_dy)
    ld a, h
    or l
    jr z, _gravity_done

_gravity:
    ; apply gravity on velocity
    ld hl, (hero_dy)
    ld de, GRAVITY
    add hl, de
    ld (hero_dy), hl

_gravity_done:

;-------------------------------------------------------------------------------
    jp main_loop
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; renders a sprite
;
; inputs:   B = x coordinate (0-255 pixels)
;           C = y coordinate (0-191 pixels)
;           IX = pointer to sprite data
; outputs:  render_sprite_collision = non-zero if rendered over content
; clobbers: AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
render_sprite:
    ; clear collision byte (0 = no collision)
    xor a
    ld (render_sprite_collision), a

    ; calculate screen address

    ; H:   0  1  0 y7 y6 y2 y1 y0
    ; L:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                     ; y to A
    and $07                     ; mask 00000111 (y bits 0-2)
    or $40                      ; add base address
    ld h, a                     ; store in H

    ld a, c                     ; y to A
    rra                         ; rotate y bits to position
    rra
    rra
    and %00011000               ; isolate y bits 3-4 (sector offset)
    or h
    ld h, a                     ; H is now correct

    ld a, c                     ; y to A
    rla                         ; rotate y bits 5-7 to position
    rla
    and $e0                     ; isolate them
    ld l, a                     ; start L

    ld a, b                     ; x to A
    rra                         ; shift out the pixel fractions in a character
    rra
    rra
    and %00011111               ; isolate the column bits (0-31)
    or l                        ; combine with L
    ld l, a                     ; HL now points to screen byte

    ; render the characters that enclose the sprite

    ; prepare shift counter
    ld a, b
    and %111                    ; x % 8 (shift amount)
    ld (_shift_amt), a          ; save for later loop
 
    ld b, 16                    ; loop counter (16 lines)

_draw_loop:
    push bc                     ; save loop counter
    push hl                     ; save screen address start of line

    ; fetch sprite bytes
    ld d, (ix + 0)               ; load left sprite byte
    ld e, (ix + 1)               ; load right sprite byte

    ; shift 16-bit row right by (.shift_amt)
    ; we need to shift DE into a 3rd byte (C)
    ld c, 0                     ; C will hold the "spillover" bits

    ld a, (_shift_amt)
    or a                        ; check if shift is 0
    jr z, _shift_done           ; skip if no shift needed (fast path)
 
    ld b, a                     ; B = shift counter
_shift_bits:
    srl d                       ; shift left byte, bit 0 goes to carry
    rr e                        ; rotate right byte, carry goes into bit 7
    rr c                        ; rotate spill byte, carry goes into bit 7
    djnz _shift_bits

_shift_done:
    ; 3 bytes to draw: D, E, C
    ; D = left, E = middle, C = right (spill)

    ; draw to screen and detect collision 

    ; byte 1
    ld a, (hl)                  ; load current screen pixels
    ld b, a                     ; save screen pixels
    and d                       ; check collision
    jr z, _no_collision_1       ; skip if no collision
    ld (render_sprite_collision), a  ; store any non-zero = collision
_no_collision_1:
    ld a, b                     ; reload screen pixels
    or d                        ; or with sprite left
    ld (hl), a                  ; write back
    inc hl

    ; byte 2
    ld a, (hl)
    ld b, a
    and e
    jr z, _no_collision_2
    ld (render_sprite_collision), a
_no_collision_2:
    ld a, b
    or e
    ld (hl), a
    inc hl

    ; byte 3 (spillover)
    ld a, (hl)
    ld b, a
    and c
    jr z, _no_collision_3
    ld (render_sprite_collision), a
_no_collision_3:
    ld a, b
    or c
    ld (hl), a

    ; advance pointers
    pop hl                      ; restore start of line address

    ; move down scanline
    inc h                       ; increment high byte (pixel row)
    ld a, h
    and $07                     ; check if we crossed 8-line char boundary
    jr nz, _move_down_scanline_done ; if not 0 then continue

    ; if wrapped 0-7 then fix the lower byte of the address
    ld a, l
    add a, 32                   ; move to next character row
    ld l, a
    ; if carry then 256 and moved to next third, continue
    jr c, _move_down_scanline_done
    ; otherwise, subtract 8 from H to stay in correct third and continue
    ld a, h
    sub 8
    ld h, a
_move_down_scanline_done:

    inc ix                      ; move sprite pointer +2
    inc ix
 
    pop bc                      ; restore loop counter
    djnz _draw_loop
    ret

    ; temporaries for this subroutine
    _shift_amt: db 0

;-------------------------------------------------------------------------------
; restores tiles from tile_map for a 16 x 16 sprite area
;
; inputs:   B = x pixel
;           C = y pixel
; outputs:  -
; clobbers: AF, BC, DE, IX
;-------------------------------------------------------------------------------
restore_sprite_background
    ; calculate starting tile column x / 8
    ld a, b
    rrca
    rrca
    rrca
    and %00011111
    ld d, a             ; D is screen column 0 to 31

    ; calculate starting tile row y / 8
    ld a, c
    rrca
    rrca
    rrca
    and %00011111
    ld e, a             ; E is screen row 0 to 23

    ld b, 3             ; loop 3 columns
_col_loop
    push bc
    push de             ; save current screen D and E

    ld a, d             ; screen column to A
    cp 32               ; check screen boundary
    jr nc, _next_col    ; if A >= 32

    ld b, 3             ; loop 3 rows
_row_loop
    push bc
    push de

    ld a, e             ; screen row to A
    cp 24               ; check vertical boundary
    jr nc, _next_row    ; if A >= 24

    ; call `draw_single_tile`
    ; note: handles `camera_x` offset
    ld ixh, d           ; IXH is screen column
    ld a, e             ; A is screen row
    call draw_single_tile

_next_row
    pop de
    inc e               ; next row down in E
    pop bc
    djnz _row_loop

_next_col
    pop de
    inc d               ; next column right in D
    pop bc
    djnz _col_loop
    ret

;-------------------------------------------------------------------------------
; draws a 8 x 8 tile to the screen
;
; inputs:   IXH = screen_x
;           A = screen_y
; outputs:  -
; clobbers: AF, B, DE, HL
;-------------------------------------------------------------------------------
draw_single_tile
    push af                     ; save screen row in A
 
    ; get tile id from map
    ld h, high tile_map         ; tile_map base in H
    add a, h                    ; A is base high byte plus row
    ld h, a                     ; H is now the correct high byte
 
    ld a, (camera_x)            ; get current camera offset in A
    add a, ixh                  ; add screen x in IXH
    ld l, a                     ; L is final map column
    ld a, (hl)                  ; A is tile id from HL
 
    ; get charset address
    ld l, a
    ld h, 0
    add hl, hl                  ; shift HL left 3 for id * 8
    add hl, hl
    add hl, hl
    ld de, charset
    add hl, de                  ; HL is bitmap source
    ex de, hl                   ; DE is source

    ; calculate screen address
    pop af                      ; A is screen row
    ld b, a                     ; save row in B
    and %00011000               ; isolate row bits 3 4
    or $40                      ; screen base 4000
    ld h, a                     ; screen high byte in H

    ld a, b                     ; screen row to A
    and %00000111               ; isolate row bits 0 to 2
    rrca                        ; rotate lower bits to high bits
    rrca
    rrca                        ; move bits to 5 6 7
    or ixh                      ; add screen column IXH
    ld l, a                     ; screen low byte in L

    ; copy 8 bytes

    ; scanline 0
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 1
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 2
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 3
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 4
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 5
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 6
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H

    ; scanline 7
    ld a, (de)                  ; fetch byte from DE
    ld (hl), a                  ; write to HL screen
    inc de                      ; next source in DE
    inc h                       ; next screen line in H
 
    ret

;-------------------------------------------------------------------------------
; charset: 256 * 8 = 2048 B
;-------------------------------------------------------------------------------
org ($ + 2047) & $ff00
charset:
    include "charset.asm"

;-------------------------------------------------------------------------------
; tile map: 24 x 256 = 6144 B
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
tile_map:
    include "tile_map.asm"

;-------------------------------------------------------------------------------
; sprites data: 48 x 2 x 16 = 1536 B
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
sprites_data:
    include "sprites.asm"

;-------------------------------------------------------------------------------

end start
