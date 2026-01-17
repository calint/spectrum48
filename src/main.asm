;-------------------------------------------------------------------------------
; memory map
;-------------------------------------------------------------------------------
; $0000-$3fff : sinclair basic rom (read only)
; $4000-$57ff : screen bitmap (6144 bytes)
; $5800-$5aff : color attributes (768 bytes)
; $5b00-$7fff : printer buffer / user ram
; $8000-$xxxx : code (this file)
; $fe00-$ff00 : im2 interrupt vector table (257 bytes)
; $ff01-$fffe : stack (254 bytes, ~120 words capacity)
; $ffff       : interrupt handler (ret instruction)
;
; aligned data:
; charset   : aligned $x800 - 2048 bytes
; tile_map  : aligned $xx00 - 6144 bytes
; sprites   : aligned $xx00 - 1536 bytes
; animations: aligned $xx00 - variable
;-------------------------------------------------------------------------------

org $8000

;-------------------------------------------------------------------------------
; constants
;-------------------------------------------------------------------------------

; tunable constants

BORDER_VBLANK           equ 1
BORDER_RENDER_TILE_MAP  equ 1
BORDER_RENDER_SPRITES   equ 6
BORDER_INPUT            equ 9

GRAVITY                 equ 3
GRAVITY_RATE            equ %1111

HERO_MOVE_DX            equ 8
HERO_MOVE_BOOST_DX      equ 16
HERO_JUMP_DY            equ 33
HERO_SKIP_DY            equ 20
HERO_SKIP_RATE          equ %1111

HERO_ANIM_ID_IDLE       equ 1
HERO_ANIM_RATE_IDLE     equ %11111
HERO_ANIM_ID_LEFT       equ 2
HERO_ANIM_RATE_LEFT     equ %111
HERO_ANIM_ID_RIGHT      equ 3
HERO_ANIM_RATE_RIGHT    equ %111

HERO_CAMERA_LFT_EDGE    equ 4
HERO_CAMERA_RHT_EDGE    equ 27
HERO_CAMERA_PANE        equ 21

TILE_ID_PICKABLE        equ 33
TILE_ID_PICKED          equ 32

SUBPIXELS               equ 4

; hard constants

HERO_FLAG_MOVING_BIT    equ 0
HERO_FLAG_MOVING        equ 1
HERO_FLAG_JUMPING_BIT   equ 1
HERO_FLAG_JUMPING       equ 2

CAMERA_STATE_IDLE       equ 0
CAMERA_STATE_LEFT       equ 1
CAMERA_STATE_RIGHT      equ 2

TILE_WIDTH              equ 8
TILE_HEIGHT             equ 8
TILE_SHIFT              equ 3
TILE_SHIFT_MASK         equ %00011111
TILE_CENTER_OFFSET      equ 4

SPRITE_WIDTH            equ 16
SPRITE_HEIGHT           equ 16

SCREEN_WIDTH_CHARS      equ 32
SCREEN_HEIGHT_CHARS     equ 24

KEYBOARD_ROW_POIUY      equ $df
KEYBOARD_ROW_QWERT      equ $fb

;-------------------------------------------------------------------------------
; variables
;-------------------------------------------------------------------------------

; camera state
camera_x         db -16
camera_x_prv     db $ff
camera_state     db CAMERA_STATE_IDLE
camera_dest_x    db -16

; hero position / velocity
hero_x           dw 132 << SUBPIXELS 
hero_y           dw 0
hero_dx          dw 0
hero_dy          dw 0
hero_x_prv       dw 132 << SUBPIXELS
hero_y_prv       dw 0

; hero rendering
hero_x_screen    db 132
hero_y_screen    db 0
hero_sprite      dw sprites_data_8

; hero state
hero_flags       db 0
hero_frame       db 0

; hero animation
hero_anim_id     db HERO_ANIM_ID_IDLE
hero_anim_rate   db HERO_ANIM_RATE_IDLE
hero_anim_ptr    dw hero_animation_idle
hero_anim_frame  db 0

; set in `render_sprite` when any sprite pixel wrote over current screen content
sprite_collided  db 0   ; 0 = no collisions

; used in `render_sprite` and `render_tile_map` to save stack pointer while used
; to read sprite / tile data
saved_sp         dw 0

;-------------------------------------------------------------------------------
; initiates animation if not same
;
; input:
;   ANIM_ID = animation id constant
;   ANIM_RATE = animation rate constant
;   table = address of animation table
;   id = address of animation id field
;   rate = address of animation rate field
;   ptr = address of animation table pointer
;   sprite = address of sprite field
;
; output:
;   initiates addresses with animation
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_SET macro ANIM_ID, ANIM_RATE, table, id, rate, frame, ptr, sprite
    ; check if same animation and if so then done
    ld a, (id)
    cp ANIM_ID
    jr z, _end

    ld a, ANIM_ID
    ld (id), a

    ld a, ANIM_RATE
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

_end:
endm

;-------------------------------------------------------------------------------
; advances a frame in animation if `timer` bitwise and `(rate)` is zero
; if end of animation is reached then restart at first frame
;
; input:
;   id = address of animation id field
;   rate = address of animation rate field
;   ptr = address of pointer to animation table
;   sprite = address of sprite field
; 
; output:
;   adjusts `(ptr)` and `(sprite)`
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_DO macro timer, id, rate, frame, ptr, sprite
    ld a, (rate)
    ld e, a
    ld a, (timer)
    and e
    jr nz, _end

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
    ; update sprite pointer
    ld (sprite), de

    ; advance frame index
    ld hl, frame
    inc (hl)

_end:
endm

;-------------------------------------------------------------------------------
start:
;-------------------------------------------------------------------------------

    di                  ; disable interrupts

    ld sp, $ffff        ; set stack to start push at $fffd / $fffe

    ; in order to disable regular "stutter" due to rom routines taking many
    ; cycles during interrupts, disable it by making dummy interrupt handler
    ; and setting machine in "im 2" mode

    ; build im2 table at $fe00
    ld hl, $fe00        ; table address
    ld a, $ff           ; point to address $ffff
_loop:
    ld (hl), a
    inc l
    jr nz, _loop
    inc h               ; last byte of 257-byte table
    ld (hl), a

    ; place a 'ret' instruction at $ffff
    ld a, $c9           ; opcode for 'ret'
    ld ($ffff), a

    ; activate im 2
    ld a, $fe           ; high byte of table
    ld i, a
    im 2

    ; set foreground and background to bright white on black
    ld hl, $5800        ; color attribute start, 768 bytes
    ld (hl), %01000111  ; bright white on black
    ld de, $5801        ; destination one byte ahead to copy previous byte
    ld bc, 767          ; remaining bytes to fill
    ldir                ; hardware copy loop

;-------------------------------------------------------------------------------
; main loop:
; 1. pane camera logic
; 2. render
; 2.1. render tile map if camera position has changed
; 2.2. render sprite
; 2.2.1. render dirty tiles from previous frame
; 2.2.2. render sprite
; 3. trigger camera pane if hero is at left or right edge of screen 
; 4. check collision
; 4.1. sprite vs background
; 4.2. sprite vs tiles
; 5. save current state
; 6. handle input
; 6.1. left
; 6.2. right
; 6.3. jump
; 7. apply game logic physics
; 8. advance animation
; 9. frame done, loop
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
main_loop:
;-------------------------------------------------------------------------------
    ld a, BORDER_VBLANK
    out ($fe), a

    ei                  ; enable interrupts to receive vblank
    halt                ; sleep until the start of the next frame
    di                  ; disable interrupts while in game loop

;-------------------------------------------------------------------------------
camera_pane:
;-------------------------------------------------------------------------------

    ; handle panning camera to new position

    ; if idle then continue
    ld a, (camera_state)
    cp CAMERA_STATE_IDLE
    jr z, _end

    ; check if panning left
    ld hl, camera_x
    ; A = camera_state
    cp CAMERA_STATE_LEFT
    jr nz, _right

_left:
    ld de, 8 << SUBPIXELS    ; hero moves right relative to screen
    ld c, -1                 ; camera moves left
    jr _apply

_right:
    ld de, -(8 << SUBPIXELS) ; hero moves left relative to screen
    ld c, 1                  ; camera moves right

_apply:
    ; update camera x
    ld a, (hl)              ; HL = camera_x
    add a, c
    ld (hl), a

    ; adjust hero world x and previous x during camera pan
    ; DE = delta in subpixels
    ld hl, (hero_x)
    add hl, de
    ld (hero_x), hl
    ld hl, (hero_x_prv)
    add hl, de
    ld (hero_x_prv), hl

    ; check if destination reached
    ld hl, camera_dest_x
    ; A = camera_x
    cp (hl)
    jr nz, _end

    ; camera reached destination, set state
    ld a, CAMERA_STATE_IDLE
    ld (camera_state), a

_end:

;-------------------------------------------------------------------------------
render:
;-------------------------------------------------------------------------------

    ; check if camera position changed since last frame and if so trigger
    ; `render_tile_map`, otherwise jump to `render_sprites`

    ld hl, camera_x_prv
    ld a, (camera_x)
    cp (hl)
    jp z, render_sprites
    ld (hl), a          ; save current x to previous

;-------------------------------------------------------------------------------
render_tile_map:
;-------------------------------------------------------------------------------
    ld a, BORDER_RENDER_TILE_MAP
    out ($fe), a

    ld a, (camera_x)
    ld c, a             ; C = tile map offset
    ld b, 0             ; current column (0-31)
    ld (saved_sp), sp   ; save SP that will be used in `render_rows.asm`
_loop:
    include "render_rows.asm"
    inc b               ; next column
    inc c               ; next tile map column
    ld a, b             ; check if all columns have been rendered
    cp SCREEN_WIDTH_CHARS
    jp nz, _loop
    ; note: djnz using B as counter does not work because `render_rows.asm` size
    ;       is too large for relative jump
    ld sp, (saved_sp)   ; restore stack pointer to previous

;-------------------------------------------------------------------------------
render_sprites:
;-------------------------------------------------------------------------------
    ld a, BORDER_RENDER_SPRITES
    out ($fe), a

    ; render hero

    ; restore dirty tiles

    ; call restore_sprite_tiles
    ; B = previous render x 
    ld a, (hero_x_screen)
    ld b, a
    ; C = previous render y 
    ld a, (hero_y_screen)
    ld c, a
    ; D = column offset in tile map
    ld a, (camera_x)
    ld d, a
    call restore_sprite_tiles

    ; call render_sprite
    ld hl, (hero_x)
    ; remove the subpixels
    rept SUBPIXELS
        srl h
        rr l
    endm
    ld b, l
    ; argument B = hero_x >> SUBPIXELS

    ; save x where sprite was rendered
    ld a, b
    ld (hero_x_screen), a

    ; remove the subpixels
    ld hl, (hero_y)
    rept SUBPIXELS
        srl h
        rr l
    endm
    ld c, l
    ; argument C = hero_y >> SUBPIXELS

    ; save y where sprite was rendered
    ld a, c
    ld (hero_y_screen), a

    ; argument IX = pointer to sprite data
    ld ix, (hero_sprite)
    call render_sprite

;-------------------------------------------------------------------------------
camera_adjust:
;-------------------------------------------------------------------------------

    ; if hero is too far to the left or right start camera panning

    ; get hero tile x
    ld a, (hero_x_screen)
    rept TILE_SHIFT           ; convert to tile x
        rra
    endm
    and TILE_SHIFT_MASK
    ; A = column

    ; A = column 
    cp HERO_CAMERA_LFT_EDGE  ; check left boundary
    jr c, _left              ; jump if hero < left edge

    cp HERO_CAMERA_RHT_EDGE  ; check right boundary
    jr c, _end               ; jump if hero < right edge

_right:
    ld e, CAMERA_STATE_RIGHT ; prepare state for pane right
    ld a, (camera_x)
    add a, HERO_CAMERA_PANE  ; calculate destination
    jr _apply                ; jump to shared store

_left:
    ld e, CAMERA_STATE_LEFT  ; prepare state for pane left
    ld a, (camera_x)
    sub HERO_CAMERA_PANE     ; calculate destination

_apply:
    ld (camera_dest_x), a
    ld a, e
    ld (camera_state), a

_end:

;-------------------------------------------------------------------------------
collision_background:
;-------------------------------------------------------------------------------

; note: after this phase x and y must be out of collision since next phase will
;       save current x and y into previous for next frame

    ld a, (sprite_collided)
    or a
    jr z, _end

    ; restore previous position and set dx, dy to 0
    ld hl, (hero_x_prv)
    ld (hero_x), hl
    ld hl, (hero_y_prv)
    ld (hero_y), hl
    ld hl, 0
    ld (hero_dx), hl
    ld (hero_dy), hl

    ; clear hero jumping flag
    ld hl, hero_flags
    res HERO_FLAG_JUMPING_BIT, (hl)

_end:

;-------------------------------------------------------------------------------
collision_tiles:
;-------------------------------------------------------------------------------

    ; note: tiles collision check is not fully correct but makes good gameplay

    ; calculate tile x = L and column = B
    ld a, (hero_x_screen)
    add a, TILE_CENTER_OFFSET ; bias toward tile center (round tile coordinate)
    ; use rra + mask to save 5t over srl for 3 rept
    rept TILE_SHIFT
        rra
    endm
    and TILE_SHIFT_MASK
    ld b, a                 ; B = column
    ld a, (camera_x)
    add a, b
    ld l, a                 ; L = top left tile x

    ; calculate tile y
    ld a, (hero_y_screen)
    add a, TILE_CENTER_OFFSET ; bias toward tile center (round tile coordinate)
    ; use rra + mask to save 5t over srl for 3 rept
    rept TILE_SHIFT
        rra
    endm
    and TILE_SHIFT_MASK
    ld c, a                 ; C = row
    ld h, a                 ; H = top left tile y

    ; point HL to top left tile
    ; note: since `tile_map` is aligned on 256 B do slightly faster (2 T) 8 bit
    ;       operations
    ld a, h
    ld d, high tile_map
    add a, d
    ld h, a

_top_left:
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _top_right

    ; overwrite the picked tile
    ld (hl), TILE_ID_PICKED

    push hl
    ; call render_tile
    ld a, (camera_x)
    ld d, a
    call render_tile
    pop hl

_top_right:
    inc l
    inc b
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _bottom_right

    ld (hl), TILE_ID_PICKED

    push hl
    ; call render_tile
    ld a, (camera_x)
    ld d, a
    call render_tile
    pop hl

_bottom_right:
    inc h
    inc c
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _bottom_left

    ld (hl), TILE_ID_PICKED

    push hl
    ; call render_tile
    ld a, (camera_x)
    ld d, a
    call render_tile
    pop hl

_bottom_left:
    dec l
    dec b
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _end

    ld (hl), TILE_ID_PICKED

    ; call render_tile
    ld a, (camera_x)
    ld d, a
    call render_tile

_end:

;-------------------------------------------------------------------------------
save_state:
;-------------------------------------------------------------------------------

    ; save current x and y to previous

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
    ld hl, hero_flags
    res HERO_FLAG_MOVING_BIT, (hl)

_check_hero_left:
    ld a, KEYBOARD_ROW_POIUY
    in a, ($fe)         ; read row (0 = pressed)
    bit 1, a            ; check key O
    jr nz, _check_hero_left_end

    ; flag hero is moving
    ld hl, hero_flags
    set HERO_FLAG_MOVING_BIT, (hl)

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
    ld a, (sprite_collided)
    or a
    jr z, _set_left_dx
    ld hl, -HERO_MOVE_BOOST_DX
_set_left_dx:
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame)
    and HERO_SKIP_RATE
    jr nz, _check_hero_left_end

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_left_end
    ; note: this logic works with tuned constants, however, if hero is skipping
    ;       and frame coincides with skip rate and dy is 0 then hero skips again
    ;       giving the effect of hero floating upwards

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_DY 
    ld (hero_dy), hl

_check_hero_left_end:

_check_hero_right:
    ld a, KEYBOARD_ROW_POIUY
    in a, ($fe)         ; read row (0 = pressed)
    bit 0, a            ; check key P
    jr nz, _check_hero_right_end

    ; flag hero is moving
    ld hl, hero_flags
    set HERO_FLAG_MOVING_BIT, (hl)

    ANIMATION_SET HERO_ANIM_ID_RIGHT, HERO_ANIM_RATE_RIGHT, hero_animation_right, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

    ; choose dx boost if in collision
    ld hl, HERO_MOVE_DX
    ld a, (sprite_collided)
    or a
    jr z, _set_right_dx
    ld hl, HERO_MOVE_BOOST_DX
_set_right_dx:
    ld (hero_dx), hl

    ; if not at skip (small jump) interval then continue to next step
    ld a, (hero_frame)
    and HERO_SKIP_RATE
    jr nz, _check_hero_right_end

    ; if there is vertical movement then don't skip (small jump)
    ld hl, (hero_dy)
    ld a, h
    or l
    jr nz, _check_hero_right_end
    ; note: this logic works with tuned constants, however, if hero is skipping
    ;       and frame coincides with skip rate and dy is 0 then hero skips again
    ;       giving the effect of hero floating upwards

    ; set skip (small jump) `dy`
    ld hl, -HERO_SKIP_DY 
    ld (hero_dy), hl

_check_hero_right_end:

_check_hero_jump:
    ld a, KEYBOARD_ROW_QWERT
    in a, ($fe)         ; read row (0 = pressed)
    bit 0, a            ; check key Q
    jr nz, _check_hero_jump_end

    ; if hero is jumping then done
    ld hl, hero_flags
    bit HERO_FLAG_JUMPING_BIT, (hl)
    jr nz, _check_hero_jump_end

    ; set jump velocity
    ld hl, -HERO_JUMP_DY
    ld (hero_dy), hl

    ; flag hero is moving and jumping
    ld a, HERO_FLAG_MOVING | HERO_FLAG_JUMPING
    ld (hero_flags), a

_check_hero_jump_end:

    ; if hero is moving skip idle animation
    ld hl, hero_flags
    bit HERO_FLAG_MOVING_BIT, (hl)
    jr nz, _end

    ANIMATION_SET HERO_ANIM_ID_IDLE, HERO_ANIM_RATE_IDLE, hero_animation_idle, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

_end:

;-------------------------------------------------------------------------------
physics:
;-------------------------------------------------------------------------------
    ; if hero is jumping then apply gravity
    ld hl, hero_flags
    bit HERO_FLAG_JUMPING_BIT, (hl)
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
    jr z, _gravity_end
    ; note: if gravity and skip cancel each other so that dy is 0 then hero
    ;       floats, adjust constants to avoid that

_gravity:
    ; apply gravity on velocity
    ld hl, (hero_dy)
    ld de, GRAVITY
    add hl, de
    ld (hero_dy), hl

_gravity_end:

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
    ld hl, hero_flags
    bit HERO_FLAG_JUMPING_BIT, (hl)
    jr nz, _end

    ANIMATION_DO hero_frame, hero_anim_id, hero_anim_rate, hero_anim_frame, hero_anim_ptr, hero_sprite

_end:

;-------------------------------------------------------------------------------
    ; increment frame counter used in timing masks (wrap is ok)
    ld hl, hero_frame
    inc (hl)

    jp main_loop
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; helper macro for `render_sprite` to avoid label clashes in `rept` block
;
; input:
;   HL = screen destination
;   SP = pointer to sprite data
;   IYL = number of shifts
;
; output: -
;
; clobbers:
;   AF, BC, DE, HL, SP
;-------------------------------------------------------------------------------
RENDER_SPRITE_LINE macro
    pop de                      ; fetch sprite bytes
    ld c, 0                     ; C will hold the "spillover" bits

    ; shift 16-bit row right or left depending on IYL
    ; note: this is very expensive, thus pre-shifted sprites would be better

    ld a, iyl                   ; A = number of shifts
    or a                        ; check if shift is 0
    jr z, _shift_done           ; skip if no shift needed

    cp 5                        ; is shift > 4
    jr nc, _shift_left

_shift_right:
    ld b, a                     ; B = shift counter
_loop_right:
    srl e                       ; shift sprite left byte right, bit 0 to carry
    rr d                        ; rotate sprite right byte, carry to bit 7
    rr c                        ; rotate spill byte, carry to bit 7
    djnz _loop_right
    jr _shift_done

_shift_left:
    ; flip sprite bytes for left shift
    ld c, d
    ld d, e
    ld e, 0
    ; A = shifts right
    neg                         ; calculate left shifts, 8 - right shifts
    add a, 8
    ld b, a
_loop_left:
    sla c                       ; shift sprite right byte left, bit 7 to carry
    rl d                        ; rotate sprite left byte, carry to bit 0
    rl e                        ; rotate spill byte, carry to bit 0
    djnz _loop_left

_shift_done:

    ; 3 bytes to draw: E, D, C
    ; E = left, D = middle, C = right (spill)

    ; byte E
    ld a, (hl)                  ; load current screen pixels
    ld b, a                     ; save screen pixels
    and e                       ; check collision
    jr z, _no_col_d             ; skip if no collision
    ld (sprite_collided), a     ; store any non-zero = collision
_no_col_d:
    ld a, b                     ; reload screen pixels
    or e                        ; OR with sprite left byte
    ld (hl), a                  ; write back to screen
    inc l

    ; byte D
    ld a, (hl)
    ld b, a
    and d
    jr z, _no_col_e
    ld (sprite_collided), a
_no_col_e:
    ld a, b
    or d
    ld (hl), a
    inc l

    ; byte C
    ld a, (hl)
    ld b, a
    and c
    jr z, _no_col_c
    ld (sprite_collided), a
_no_col_c:
    ld a, b
    or c
    ld (hl), a

    ; move HL back to starting position
    dec l
    dec l

    ; move down 1 scanline

    inc h                      ; increment high byte (pixel row)
    ld a, h
    and 7                      ; check if we crossed 8-line char boundary
    jr nz, _end                ; if not 0 then continue

    ; if wrapped 0-7 then fix the lower byte of the address
    ld a, l
    add a, SCREEN_WIDTH_CHARS  ; move to next character row
    ld l, a
    jr c, _end                 ; if carry then 256 and moved to next third

    ; otherwise, subtract 8 from H to stay in correct third
    ld a, h
    sub 8
    ld h, a

_end:
endm

;-------------------------------------------------------------------------------
; renders a sprite
;
; input:
;   B = x coordinate (0-255 pixels)
;   C = y coordinate (0-191 pixels)
;   IX = pointer to sprite data
;
; output:
;   sprite_collided = non-zero if rendered over content
;
; clobbers:
;   AF, BC, DE, HL, IYL
;-------------------------------------------------------------------------------
render_sprite:
    ; clear collision byte (0 = no collision)
    xor a
    ld (sprite_collided), a

    ; calculate screen address

    ; H:   0  1  0 y7 y6 y2 y1 y0
    ; L:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                 ; A = screen y
    and %00000111           ; mask y2, y1, y0
    or %01000000            ; add screen base $4000
    ld h, a

    ld a, c                 ; A = screen y
    rra                     ; rotate y7, y6 bits to position
    rra
    rra
    and %00011000
    or h
    ld h, a                 ; H = screen address high byte

    ld a, c                 ; A = screen y
    rla                     ; rotate y5, y4, y3 bits to position
    rla
    and %11100000
    ld l, a                 ; L = y5, y4, y3

    ld a, b                 ; A = screen x
    rept TILE_SHIFT         ; shift out the pixel fractions in a tile
        rra
    endm
    and TILE_SHIFT_MASK     ; isolate the column bits (0-31)
    or l                    ; add x4, x3, x2, x1, x0
    ld l, a                 ; HL = screen address

    ; prepare shift counter
    ld a, b
    and 7                   ; x % 8 (shift amount)
    ld iyl, a               ; save for later use

    ld (saved_sp), sp       ; save SP that will be used when rendering
    ld sp, ix
    ; render over the tiles that enclose the sprite
rept SPRITE_HEIGHT
    RENDER_SPRITE_LINE
endm 
    ld sp, (saved_sp)       ; restore SP to previous

    ret

;-------------------------------------------------------------------------------
; helper macro for `restore_sprite_tiles` and `render_tile`
;
; input:
;   B = screen column
;   C = screen row
;
; output:
;   DE = screen destination
;
; clobbers:
;   AF
;-------------------------------------------------------------------------------
SCREEN_ADDRESS_FROM_BC_TO_DE macro
    ; calculate screen address

    ; D:   0  1  0 y7 y6 y2 y1 y0
    ; E:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                 ; A = screen row
    and %00011000           ; row bits already "shifted" due to tile 8 lines
    or %01000000            ; add screen base $4000
    ld d, a                 ; D = screen high byte (y2, y1, y0 always 0)

    ld a, c                 ; A = screen row
    and %00000111           ; isolate y5, y4, y3
    rrca                    ; rotate lower bits to high bits
    rrca
    rrca
    or b                    ; add column to B
    ld e, a                 ; E = screen destination low byte
    ; DE = screen destination
endm

;-------------------------------------------------------------------------------
; helper macro for `restore_sprite_tiles` and `render_tile`
;
; input:
;   B = screen column
;   C = screen row
;   D = tile map column offset
;
; output:
;   HL = pointer to tile
;
; clobbers:
;   AF
;-------------------------------------------------------------------------------
TILE_ADDRESS_FROM_BCD_TO_HL macro
    ; get tile id from map
    ld h, high tile_map     ; H = tile_map base
    ld a, c                 ; C = screen row
    add a, h                ; A = base high byte plus row
    ld h, a                 ; H = now the correct high byte
 
    ld a, d                 ; A = tile map column offset
    add a, b                ; B = screen column
    ld l, a                 ; L = tile map column
    ; HL = pointer to tile
endm

;-------------------------------------------------------------------------------
; helper macro for `restore_sprite_tiles` and `render_tile`
;
; input:
;   HL = pointer to tile
;   DE = screen destination
;
; output: -
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
RENDER_TILE macro
    ld a, (hl)              ; A = tile id
 
    ; make HL pointer to address of tile bitmap
    ; bit trickery because `charset` is aligned on 2048 boundary
    ld l, a                 ; move upper 3 bits of low byte to lower 3 bits
    and %11100000           ;  of high byte
    rlca
    rlca
    rlca
    or high charset         ; set upper 5 bits in high byte
    ld h, a                 ; H = pointer high byte
    ld a, l                 ; shift lower byte by 3 because a tile is 8
    add a, a                ;  bytes
    add a, a
    add a, a
    ld l, a                 ; L = pointer low byte
    ; HL = bitmap source

rept 7
    ld a, (hl)
    ld (de), a
    inc hl                  ; HL = next tile scanline
    inc d                   ; D = next screen line
endm
    ld a, (hl)
    ld (de), a
endm

;-------------------------------------------------------------------------------
; helper macro for `restore_sprite_tiles`
;
; input:
;   DE = screen destination
;
; output:
;   DE = next screen row
;
; clobbers:
;   AF
;-------------------------------------------------------------------------------
ADVANCE_ROW macro
    ; advance 1 row on screen
    ld a, d
    add a, 8
    ld d, a
    and 7
    jr nz, _end

    ld a, e
    add a, SCREEN_WIDTH_CHARS
    ld e, a
    jr c, _end

    ld a, d
    sub 8
    ld d, a

_end:
endm

;-------------------------------------------------------------------------------
; restores 3 x 3 tiles occupied by a sprite
;
; input:
;   B = x pixel
;   C = y pixel
;   D = tile map column offset
;
; output: -
;
; clobbers:
;   AF, BC, DE, HL
;-------------------------------------------------------------------------------
restore_sprite_tiles:
    ; calculate starting tile column
    ; note: 3 T faster than ld / rra * 3 / and / ld
    rept TILE_SHIFT
        srl b
    endm

    ; calculate starting tile row
    ; note: 3 T faster than ld / rra * 3 / and / ld
    rept TILE_SHIFT
        srl c
    endm

    TILE_ADDRESS_FROM_BCD_TO_HL
    SCREEN_ADDRESS_FROM_BC_TO_DE

    push de                 ; will be popped when advancing a row
    push hl                 ;

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                   ; next tile in row
    inc e                   ; next character on screen
    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l
    inc e
    RENDER_TILE

    pop hl                  ; restore values prior rendering a new tile row
    pop de                  ;
    ADVANCE_ROW             ; advance 1 row on screen
    inc h                   ; advance 1 row in tile map

    push de                 ; will be popped when advancing a row
    push hl                 ;

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                   ; next tile in row
    inc e                   ; next character on screen
    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l
    inc e
    RENDER_TILE

    pop hl                  ; restore values prior rendering a tile row
    pop de                  ;
    ADVANCE_ROW             ; advance 1 row on screen
    inc h                   ; advance 1 row in tile map

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                   ; next tile in row
    inc e                   ; next character on screen
    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l
    inc e
    RENDER_TILE

    ret

;-------------------------------------------------------------------------------
; renders a 8 x 8 tile to the screen
;
; input:
;   B = screen column
;   C = screen row
;   D = tile map column offset
;
; output: -
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
render_tile:
    TILE_ADDRESS_FROM_BCD_TO_HL
    SCREEN_ADDRESS_FROM_BC_TO_DE
    RENDER_TILE
    ret

;-------------------------------------------------------------------------------
; charset: 256 * 8 = 2048 B, aligned on 2048 B
;-------------------------------------------------------------------------------
org ($ + 2047) & $f800
charset:
    include "charset.asm"

;-------------------------------------------------------------------------------
; tile map: 24 x 256 = 6144 B, aligned on 256 B
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
tile_map:
    include "tile_map.asm"

;-------------------------------------------------------------------------------
; sprites data: 48 x 2 x 16 = 1536 B, aligned on 256 B
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
sprites_data:
    include "sprites.asm"

;-------------------------------------------------------------------------------
; animations, aligned on 256 B
;-------------------------------------------------------------------------------
org ($ + 255) & $ff00
hero_animation_idle:
    dw sprites_data_8
    dw sprites_data_9
    dw sprites_data_10
    dw sprites_data_9
    dw 0

hero_animation_right:
    dw sprites_data_1
    dw sprites_data_0
    dw 0

hero_animation_left:
    dw sprites_data_3
    dw sprites_data_2
    dw 0

;-------------------------------------------------------------------------------
end start
