org $8000
;-------------------------------------------------------------------------------
; constants
;-------------------------------------------------------------------------------
BORDER_VBLANK: equ 1
BORDER_RENDER_TILE_MAP: equ 14
BORDER_RENDER_SPRITES: equ 4
BORDER_INPUT: equ 9
HERO_SPRITE_BIT: equ 1

;-------------------------------------------------------------------------------
; variables
;-------------------------------------------------------------------------------
sprites_collision_bit: db 0   ; 8 bits for sprite collisions

camera_x: db 0
hero_x: db 100
hero_y: db 100

; used by `render_sprite`
render_sprite_collision: db 0 ; if non-zero sprite collided with drawn content
render_sprite_shift_amt: db 0 ; temporary

;-------------------------------------------------------------------------------
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
 
    ld a, BORDER_RENDER_TILE_MAP
    out ($fe), a

render_tile_map:
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

render_sprites:
    ld a, BORDER_RENDER_SPRITES
    out ($fe), a

    xor a
    ld (sprites_collision_bit), a

    ; render hero
    ld a, (hero_x)
    ld b, a
    ld a, (hero_y)
    ld c, a
    ld ix, sprites_data_8
    call render_sprite
    ld a, (render_sprite_collision)
    or a
    jr z, .no_collision
    ld a, (sprites_collision_bit)
    or HERO_SPRITE_BIT
    ld (sprites_collision_bit), a
.no_collision:
    ; done render hero


    ld a, (sprites_collision_bit)
    ld hl, $401f
    ld (hl), a

input:
    ld a, BORDER_INPUT
    out ($fe), a

    ; check 'A' (left) and 'D' (right)
    ld bc, $fdfe        ; row A, S, D, F, G
    in a, (c)           ; read port

.check_a:
    bit 0, a            ; bit 0 is 'A'
    jr nz, .check_d     ; if not pressed, check d
    ld hl, camera_x
    dec (hl)            ; move camera left

.check_d:
    bit 2, a            ; bit 2 is 'D'
    jr nz, .check_camera_done     ; if not pressed, check w row
    ld hl, camera_x
    inc (hl)            ; move camera right

.check_camera_done:
    ; read keyboard row for Z, X, C, V (port $BFFD)
    ld bc, $fefe        ; row select
    in a, (c)           ; read row (0 = pressed)

.check_z:
    ; left = Z (bit 0)
    bit 1, a
    jr nz, .check_x
    ld hl, hero_x
    dec (hl)

.check_x:
    ; right = X (bit 1)
    bit 2, a
    jr nz, .check_c
    ld hl, hero_x
    inc (hl)

.check_c:
    ; up = C (bit 2)
    bit 3, a
    jr nz, .check_v
    ld hl, hero_y
    dec (hl)

.check_v:
    ; down = V (bit 3)
    bit 4, a
    jr nz, .done
    ld hl, hero_y
    inc (hl)

.done:

    jp main_loop

; ------------------------------------------------------------------------------
; renders a sprite
; inputs:  b = x coordinate (0-255 pixels)
;          c = y coordinate (0-191 pixels)
;          ix = pointer to sprite data
; ouputs:  render_sprite_collision = non-zero if rendered over content
; clobbers: 
; ------------------------------------------------------------------------------
render_sprite:
    xor a
    ld (render_sprite_collision), a

    ; calculate screen address
    ld a, c                     ; y to A
    and $07                     ; mask 00000111 (y bits 0-2)
    or $40                      ; add base address
    ld h, a                     ; store in H

    ld a, c
    rra                         ; rotate y bits to position
    rra
    rra
    and $18                     ; isolate y bits 3-4 (sector offset)
    or h
    ld h, a                     ; H is now correct

    ld a, c
    rla                         ; rotate y bits 5-7 to position
    rla
    and $e0                     ; isolate them
    ld l, a                     ; start L

    ld a, b                     ; x to A
    rra
    rra
    rra
    and $1f                     ; x / 8 (column 0-31)
    or l                        ; combine with L
    ld l, a                     ; HL now points to screen byte

    ; prepare shift counter
    ld a, b
    and $07                     ; x % 8 (shift amount)
    ld (render_sprite_shift_amt), a ; save for later loop
 
    ld b, 16                    ; loop counter (16 lines)

draw_loop:
    push bc                     ; save loop counter
    push hl                     ; save screen address start of line

    ; fetch sprite bytes
    ld d, (ix+0)                ; load left sprite byte
    ld e, (ix+1)                ; load right sprite byte

    ; shift 16-bit row right by (render_sprite_shift_amt)
    ; we need to shift DE into a 3rd byte (C)
    ld c, 0                     ; C will hold the "spillover" bits

    ld a, (render_sprite_shift_amt)
    or a                        ; check if shift is 0
    jr z, shift_done            ; skip if no shift needed (fast path)
 
    ld b, a                     ; B = shift counter
shift_bits:
    srl d                       ; shift left byte, bit 0 goes to carry
    rr e                        ; rotate right byte, carry goes into bit 7
    rr c                        ; rotate spill byte, carry goes into bit 7
    djnz shift_bits

shift_done:
    ; we now have 3 bytes to draw: D, E, C
    ; D = left, E = middle, C = right (spill)

    ; draw to screen and detect collision 
    ; byte 1
    ld a, (hl)                  ; load current screen pixels
    ld b, a                     ; save screen pixels
    and d                       ; check collision
    jr z, .no_collision_1       ; skip if no collision
    ld (render_sprite_collision), a  ; store any non-zero = collision
.no_collision_1:
    ld a, b                     ; reload screen pixels
    or d                        ; or with sprite left
    ld (hl), a                  ; write back
    inc hl

    ; byte 2
    ld a, (hl)
    ld b, a
    and e
    jr z, .no_collision_2
    ld (render_sprite_collision), a
.no_collision_2:
    ld a, b
    or e
    ld (hl), a
    inc hl

    ; byte 3 (spillover)
    ld a, (hl)
    ld b, a
    and c
    jr z, .no_collision_3
    ld (render_sprite_collision), a
.no_collision_3:
    ld a, b
    or c
    ld (hl), a

    ; advance pointers
    pop hl                      ; restore start of line address

    ; move down scanline
    inc h                       ; increment high byte (pixel row)
    ld a, h
    and $07                     ; check if we crossed 8-line char boundary
    jr nz, .move_down_scanline_done ; if not 0 then return 

    ; if wrapped 0-7 then fix the address
    ld a, l
    add a, 32                   ; move to next character row
    ld l, a
    ; if carry then moved to next third, standard handling is ok
    jr c, .move_down_scanline_done
    ; otherwise, subtract 8 from H to stay in correct third
    ld a, h
    sub 8
    ld h, a
.move_down_scanline_done:

    inc ix                      ; move sprite pointer +2
    inc ix
 
    pop bc                      ; restore loop counter
    djnz draw_loop
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
