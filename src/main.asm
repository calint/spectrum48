org $8000
;-------------------------------------------------------------------------------
; constants
;-------------------------------------------------------------------------------

; tunable constants

BORDER_VBLANK           equ 1
BORDER_RENDER_TILE_MAP  equ 1
BORDER_RENDER_SPRITES   equ 6
BORDER_INPUT            equ 9

GRAVITY               equ 3
GRAVITY_RATE          equ %1111

HERO_SPRITE_BIT       equ 1
HERO_MOVE_DX          equ 8
HERO_MOVE_BOOST_DX    equ 16
HERO_JUMP_DY          equ 33
HERO_SKIP_DY          equ 20
HERO_SKIP_RATE        equ %1111

HERO_ANIM_ID_IDLE     equ 1
HERO_ANIM_RATE_IDLE   equ %11111
HERO_ANIM_ID_LEFT     equ 2
HERO_ANIM_RATE_LEFT   equ %111
HERO_ANIM_ID_RIGHT    equ 3
HERO_ANIM_RATE_RIGHT  equ %111

HERO_CAMERA_LFT_EDGE  equ 5
HERO_CAMERA_RHT_EDGE  equ 26
HERO_CAMERA_MOVE      equ 20

TILE_ID_PICKABLE      equ 33
TILE_ID_PICKED        equ 32

SUBPIXELS             equ 4

; hard constants

HERO_FLAG_RESTARTING  equ 1
HERO_FLAG_MOVING      equ 2
HERO_FLAG_JUMPING     equ 4

CAMERA_STATE_IDLE     equ 0
CAMERA_STATE_LEFT     equ 1
CAMERA_STATE_RIGHT    equ 2

TILE_WIDTH            equ 8
TILE_SHIFT            equ 3

SCREEN_WIDTH          equ 32
SCREEN_HEIGHT         equ 24

;-------------------------------------------------------------------------------
; variables
;-------------------------------------------------------------------------------
sprites_collision_bits: db 0   ; 8 bits for sprite collisions

camera_x         db -16
camera_x_prv     db $ff
camera_state     db CAMERA_STATE_IDLE
camera_dest_x    db -16

hero_frame       db 0
hero_x           dw 132 << SUBPIXELS 
hero_y           dw 0
hero_dx          dw 0
hero_dy          dw 0
hero_x_prv       dw 132 << SUBPIXELS
hero_y_prv       dw 0
hero_x_screen    db 132
hero_y_screen    db 0
hero_flags       db 0
hero_sprite      dw sprites_data_8
hero_anim_id     db HERO_ANIM_ID_IDLE
hero_anim_frame  db 0
hero_anim_rate   db HERO_ANIM_RATE_IDLE
hero_anim_ptr    dw hero_animation_idle

; set in `render_sprite` when any sprite pixel wrote over curren screen content
sprite_collided  db 0   ; 0 = no collisions

;-------------------------------------------------------------------------------
; initiates animation if not same
;
; input:    ID = animation id constant
;           RATE = animation rate constant
;           table = address of animation table
;           id = address of animation id field
;           rate = address of animation rate field
;           ptr = address of current pointer field to the animation table
;           sprite = address of sprite field
; output:   initiates addresses with animation
; clobbers: A, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_SET MACRO ID, RATE, table, id, rate, frame, ptr, sprite
    ; check if same animation and if so then done
    ld a, (id)
    cp ID
    jr z, _done

    ld a, ID
    ld (id), a

    ld a, RATE
    ld (rate), a

    xor a
    ld (frame), a

    ld hl, table
    ld (ptr), hl

    ; load first frame from table
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld (sprite), de

_done:
ENDM

;-------------------------------------------------------------------------------
; advances a frame in animation if `hero_frame` bitwise and `(rate)` is zero
; if end is reached then restart at first frame
;
; input:    id = address of animation id field
;           rate = address of animation rate field
;           ptr = address of current pointer field into the animation table
;           sprite = address of sprite field
; output:   adjusts `(ptr)` and `(sprite)`
; clobbers: A, B, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_DO MACRO id, rate, frame, ptr, sprite
    ld a, (rate)
    ld b, a
    ld a, (hero_frame)
    and b
    jr nz, _done

    ; HL = base animation table
    ld hl, (ptr)

    ; DE = frame index * 2
    ld a, (frame)
    add a, a              ; *2
    ld e, a
    ld d, 0
    add hl, de            ; HL = entry address

    ; load word -> DE
    ld e, (hl)
    inc hl
    ld d, (hl)

    ; terminator?
    ld a, d
    or e
    jr nz, _use_frame

_restart:
    xor a
    ld (frame), a

    ; load first frame (table[0])
    ld hl, (ptr)
    ld e, (hl)
    inc hl
    ld d, (hl)

_use_frame:
    ; update current sprite
    ld (sprite), de

    ; advance frame index
    ld a, (frame)
    inc a
    ld (frame), a

_done:
ENDM
;-------------------------------------------------------------------------------
start:
;-------------------------------------------------------------------------------
    ld hl, $5800        ; color attribute start, 768 bytes
    ld (hl), 7          ; white on black
    ld de, $5801        ; destination one byte ahead to copy previous byte
    ld bc, 767          ; remaining bytes to fill
    ldir                ; fastest hardware copy loop

;-------------------------------------------------------------------------------
main_loop:
;-------------------------------------------------------------------------------
    ld a, BORDER_VBLANK
    out ($fe), a

    halt                ; sleep until the start of the next frame

_camera_reposition:
    ld a, (camera_state)
    cp CAMERA_STATE_IDLE
    jr z, _camera_reposition_done

    cp CAMERA_STATE_LEFT
    jr nz, _camera_reposition_right

    ; adjust hero x
    ld hl, (hero_x)
    ld de, 8 << SUBPIXELS
    add hl, de
    ld (hero_x), hl
    ld (hero_x_prv), hl

    ld a, (camera_x)
    dec a
    ld (camera_x), a
    ld hl, camera_dest_x
    cp (hl)
    jr nz, _camera_reposition_done

    ld a, CAMERA_STATE_IDLE
    ld (camera_state), a
    jr _camera_reposition_done

_camera_reposition_right:
    ; adjust hero x
    ld hl, (hero_x)
    ld de, -(8 << SUBPIXELS)
    add hl, de
    ld (hero_x), hl
    ld (hero_x_prv), hl

    ld a, (camera_x)
    inc a
    ld (camera_x), a
    ld hl, camera_dest_x
    cp (hl)
    jr nz, _camera_reposition_done

    ld a, CAMERA_STATE_IDLE
    ld (camera_state), a

_camera_reposition_done:

    ; check if camera position changed triggering tile map re-draw
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
    cp SCREEN_WIDTH
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
    ; B = previous render x 
    ld a, (hero_x_screen)
    ld b, a
    ; C = previous render y 
    ld a, (hero_y_screen)
    ld c, a
    call restore_sprite_background

    ; call render_sprite
    ld hl, (hero_x)
    rept SUBPIXELS
        srl h
        rr  l
    endm
    ld b, l
    ld a, b             ; save x where sprite was rendered
    ld (hero_x_screen), a
    ; C = hero_x >> SUBPIXELS
    ld hl, (hero_y)
    rept SUBPIXELS
        srl h
        rr  l
    endm
    ld c, l
    ld a, c             ; save y where sprite was rendered
    ld (hero_y_screen), a
    ld ix, (hero_sprite)
    call render_sprite

    ; update sprites collision bits
    ld a, (sprite_collided)
    or a
    jr z, _done
    ld a, (sprites_collision_bits)
    or HERO_SPRITE_BIT
    ld (sprites_collision_bits), a
_done:

    ; done render hero
    ; debugging on screen
    ld a, (sprites_collision_bits)
    ld hl, $401f
    ld (hl), a

;-------------------------------------------------------------------------------
camera_adjust_focus:
;-------------------------------------------------------------------------------
    ld a, (hero_x_screen)
    rept TILE_SHIFT
        srl a
    endm

    cp HERO_CAMERA_LFT_EDGE
    jr nc, _check_right_edge

    ld a, (camera_x)
    add a, -HERO_CAMERA_MOVE
    ld (camera_dest_x), a
    ld a, CAMERA_STATE_LEFT
    ld (camera_state), a
    jr _done

 _check_right_edge:
    cp HERO_CAMERA_RHT_EDGE
    jr c, _done

    ld a, (camera_x)
    add a, HERO_CAMERA_MOVE
    ld (camera_dest_x), a
    ld a, CAMERA_STATE_RIGHT
    ld (camera_state), a

_done:

;-------------------------------------------------------------------------------
collisions:
;-------------------------------------------------------------------------------
; note: after this phase x and y must be out of collision since next phase will
;       save current x and y into previous for next frame
_check_sprites:
    ld a, (sprites_collision_bits)
    and HERO_SPRITE_BIT
    jr z, _check_sprites_done

    ; restore previous position and set dx, dy to 0
    ld hl, (hero_x_prv)
    ld (hero_x), hl
    ld hl, (hero_y_prv)
    ld (hero_y), hl
    ld hl, 0
    ld (hero_dx), hl
    ld (hero_dy), hl

    ; clear hero flags
    ld a, (hero_flags)
    and ~(HERO_FLAG_JUMPING | HERO_FLAG_RESTARTING)
    ld (hero_flags), a

_check_sprites_done:

_check_tiles:
    ; calculate tile x
    ld a, (hero_x_screen)
    add a, TILE_WIDTH / 2   ; bias toward tile center (rounded tile coordinate)
    rept TILE_SHIFT
        srl a
    endm
    ld b, a
    ld a, (camera_x)
    add a, b
    ld b, a                 ; B = top left tile x

    ; calculate tile y
    ld a, (hero_y_screen)
    add a, TILE_WIDTH / 2   ; bias toward tile center (rounded tile coordinate)
    rept TILE_SHIFT
        srl a
    endm
    ld c, a                 ; C = top left tile y

    ; point HL to top left tile
    ld h, c
    ld l, b
    ld de, tile_map
    add hl, de

_check_top_left:
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_top_right

    ; overwrite the picked tile
    ld (hl), TILE_ID_PICKED

    ; call render_single_tile
    ld ixh, b
    ld a, c
    call render_single_tile

_check_top_right:
    inc l
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_bottom_right

    ld (hl), TILE_ID_PICKED

    ; call render_single_tile
    ld ixh, b
    ld a, c
    call render_single_tile

_check_bottom_right:
    inc h
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_bottom_left

    ld (hl), TILE_ID_PICKED

    ; call render_single_tile
    ld ixh, b
    ld a, c
    call render_single_tile

_check_bottom_left:
    dec l
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_tiles_done

    ld (hl), TILE_ID_PICKED

    ; call render_single_tile
    ld ixh, b
    ld a, c
    call render_single_tile

_check_tiles_done:

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

    ; clear hero is moving flag
    ld a, (hero_flags)
    and ~HERO_FLAG_MOVING
    ld (hero_flags), a

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

    ; initiate animation
    ANIMATION_SET HERO_ANIM_ID_LEFT, HERO_ANIM_RATE_LEFT, hero_animation_left, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

    ; note: hero can get stuck due to animation frames not allowing to exit
    ;       collision, thus if in collision give a boost to escape collision
    ;       when hanging on horizontal background
    ;       boost constant is tuned depending on the animation frames for
    ;       left and right where left, in this case, needs to move 2 pixels
    ;       to escape

    ; choose dx boost if in collision
    ld hl, -HERO_MOVE_DX
    ld a, (sprites_collision_bits)
    and HERO_SPRITE_BIT
    jr z, _set_left_dx
    ld hl, -HERO_MOVE_BOOST_DX
_set_left_dx:
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame)
    and HERO_SKIP_RATE
    jr nz, _check_hero_left_done

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_left_done
    ; note: this logic works with tuned constants, however, is hero is skipping
    ;       and frame coincides with skip rate and dy is 0 then hero skips again
    ;       giving the effect of hero floating upwards

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_DY 
    ld (hero_dy), hl

_check_hero_left_done:

_check_hero_right:
    bit 2, b
    jr nz, _check_hero_right_done

    ; flag hero moving
    ld a, (hero_flags)
    or HERO_FLAG_MOVING
    ld (hero_flags), a

    ANIMATION_SET HERO_ANIM_ID_RIGHT, HERO_ANIM_RATE_RIGHT, hero_animation_right, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

    ; choose dx boost if in collision
    ld hl, HERO_MOVE_DX
    ld a, (sprites_collision_bits)
    and HERO_SPRITE_BIT
    jr z, _set_right_dx
    ld hl, HERO_MOVE_BOOST_DX
_set_right_dx:
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame)
    and HERO_SKIP_RATE
    jr nz, _check_hero_right_done

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_right_done
    ; note: this logic works with tuned constants, however, is hero is skipping
    ;       and frame coincides with skip rate and dy is 0 then hero skips again
    ;       giving the effect of hero floating upwards

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_DY 
    ld (hero_dy), hl

_check_hero_right_done:

_check_hero_jump:
    bit 4, b
    jr nz, _check_hero_jump_done

    ; if hero is jumping then done
    ld a, (hero_flags)
    and HERO_FLAG_JUMPING
    jr nz, _check_hero_jump_done

    ; set jump velocity
    ld hl, -HERO_JUMP_DY
    ld (hero_dy), hl

    ; flag hero with moving and jumping
    ld a, HERO_FLAG_MOVING | HERO_FLAG_JUMPING
    ld (hero_flags), a

_check_hero_jump_done:
    ; if hero is moving continue
    ld a, (hero_flags)
    and HERO_FLAG_MOVING
    jr nz, _done

    ANIMATION_SET HERO_ANIM_ID_IDLE, HERO_ANIM_RATE_IDLE, hero_animation_idle, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

_done:

;-------------------------------------------------------------------------------
physics:
;-------------------------------------------------------------------------------
    ; if hero is jumping then apply gravity
    ld a, (hero_flags)
    and HERO_FLAG_JUMPING
    jr nz, _gravity

    ; apply gravity in intervals
    ld a, (hero_frame)
    inc a
    ; note: add 1 so that gravity is not applied same frame as "skip" for better
    ;       gameplay
    and GRAVITY_RATE
    jr z, _gravity

    ; if no vertical movement then done
    ld hl, (hero_dy)
    ld a, h
    or l
    jr z, _gravity_done
    ; note: if gravity and skip cancel each other so that dy is 0 then hero
    ;       floats, adjust constants to avoid that

_gravity:
    ; apply gravity on velocity
    ld hl, (hero_dy)
    ld de, GRAVITY
    add hl, de
    ld (hero_dy), hl

_gravity_done:

    ; add velocity to position
    ld hl, (hero_x)
    ld de, (hero_dx)
    add hl, de
    ld (hero_x), hl
    ld hl, (hero_y)
    ld de, (hero_dy)
    add hl, de
    ld (hero_y), hl

;-------------------------------------------------------------------------------
animation:
;-------------------------------------------------------------------------------
    ; don't animate if jumping for funny gameplay effect
    ld a, (hero_flags)
    and HERO_FLAG_JUMPING
    jr nz, _done

    ANIMATION_DO hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

_done:

;-------------------------------------------------------------------------------
    ; increment frame counter used in timing masks (wrap is ok)
    ld hl, hero_frame
    inc (hl)

    jp main_loop
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; renders a sprite
;
; inputs:   B = x coordinate (0-255 pixels)
;           C = y coordinate (0-191 pixels)
;           IX = pointer to sprite data
; outputs:  sprite_collided = non-zero if rendered over content
; clobbers: AF, BC, DE, HL, IX, IYL
;-------------------------------------------------------------------------------
render_sprite:
    ; clear collision byte (0 = no collision)
    xor a
    ld (sprite_collided), a

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
    and %11100000               ; isolate them
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
    ld IYL, a          ; save for later loop
 
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

    ld a, IYL
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
    ld (sprite_collided), a     ; store any non-zero = collision
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
    ld (sprite_collided), a
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
    ld (sprite_collided), a
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
    add a, SCREEN_WIDTH         ; move to next character row
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
    cp SCREEN_WIDTH     ; check screen boundary
    jr nc, _next_col    ; if A >= SCREEN_WIDTH

    ld b, 3             ; loop 3 rows
_row_loop
    push bc
    push de

    ld a, e             ; screen row to A
    cp SCREEN_HEIGHT    ; check vertical boundary
    jr nc, _next_row    ; if A >= 24

    ; call `draw_single_tile`
    ; note: handles `camera_x` offset
    ld ixh, d           ; IXH is screen column
    ld a, e             ; A is screen row
    call render_single_tile

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
; renders a 8 x 8 tile to the screen
;
; inputs:   IXH = screen character x
;           A = screen character y
; outputs:  -
; clobbers: AF, BC, DE, HL
;-------------------------------------------------------------------------------
render_single_tile
    ld c, a                     ; save screen row in A
 
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
    ld a, c                     ; A is screen row
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
; animations
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
hero_animation_idle:
    dw sprites_data_8
    dw sprites_data_9
    dw sprites_data_10
    dw sprites_data_9
    dw 0

hero_animation_right:
    dw sprites_data_0
    dw sprites_data_1
    dw 0

hero_animation_left:
    dw sprites_data_2
    dw sprites_data_3
    dw 0

;-------------------------------------------------------------------------------
end start
