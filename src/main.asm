;-------------------------------------------------------------------------------
; memory map
;-------------------------------------------------------------------------------
; $0000-$3fff : sinclair basic rom (read only)
; $4000-$57ff : screen bitmap (6144 bytes)
; $5800-$5aff : color attributes (768 bytes)
; $5b00-$7fff : printer buffer / user ram
; $8000-$xxxx : code (this file)
; $fe00-$ff00 : im2 interrupt vector table (257 bytes)
; $ff01-ffffe : stack
; $ffff       : interrupt handler (ret instruction)
;
; aligned data:
; charset   : 2kb aligned ($x800) - 2048 bytes
; tile_map  : 256b aligned ($xx00) - 6144 bytes
; sprites   : 256b aligned ($xx00) - 1536 bytes
; animations: 256b aligned ($xx00) - variable
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

GRAVITY               equ 3
GRAVITY_RATE          equ %1111

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

HERO_CAMERA_LFT_EDGE  equ 4
HERO_CAMERA_RHT_EDGE  equ 27
HERO_CAMERA_PANE      equ 21

TILE_ID_PICKABLE      equ 33
TILE_ID_PICKED        equ 32

SUBPIXELS             equ 4

; hard constants

HERO_FLAG_MOVING_BIT  equ 0
HERO_FLAG_MOVING      equ 1
HERO_FLAG_JUMPING_BIT equ 1
HERO_FLAG_JUMPING     equ 2

CAMERA_STATE_IDLE     equ 0
CAMERA_STATE_LEFT     equ 1
CAMERA_STATE_RIGHT    equ 2

TILE_WIDTH            equ 8
TILE_HEIGHT           equ 8
TILE_SHIFT            equ 3
TILE_CENTER_OFFSET    equ 4

SPRITE_WIDTH          equ 16
SPRITE_HEIGHT         equ 16

SCREEN_WIDTH_CHARS    equ 32
SCREEN_HEIGHT_CHARS   equ 24

KEYBOARD_ROW_ASDGF    equ $fdfe

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
;   A, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_SET MACRO ANIM_ID, ANIM_RATE, table, id, rate, frame, ptr, sprite
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
ENDM

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
;   A, DE, HL
;-------------------------------------------------------------------------------
ANIMATION_DO MACRO timer, id, rate, frame, ptr, sprite
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
ENDM

;-------------------------------------------------------------------------------
start:
;-------------------------------------------------------------------------------

    ; in order to disable regular "stutter" due to rom routines taking many
    ; cycles during interrupts, disable it by making dummy interrupt handlers
    ; and setting machine in "im 2" mode

    di                  ; disable interrupts

    ld sp, $ffff        ; set stack to start push at $fffd / $fffe

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

    ; set foreground and background to white on black
    ld hl, $5800        ; color attribute start, 768 bytes
    ld (hl), 7          ; white on black
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
; 4.2. sprite vs tile
; 5. save current hero state
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
_loop:
    include "render_rows.asm"
    inc b               ; next column
    inc c               ; next tile map column
    ld a, b
    cp SCREEN_WIDTH_CHARS
    jp nz, _loop
    ; note: djnz using B as counter does not work because `render_rows.asm` size
    ;       is too large for relative jump

;-------------------------------------------------------------------------------
render_sprites:
;-------------------------------------------------------------------------------
    ld a, BORDER_RENDER_SPRITES
    out ($fe), a

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
    ; argument B = hero_x >> SUBPIXELS

    ; save x where sprite was rendered
    ld a, b
    ld (hero_x_screen), a

    ld hl, (hero_y)
    rept SUBPIXELS
        srl h
        rr  l
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
        srl a
    endm
    ; A is now column

    ld hl, camera_x
    ; A = column 
    cp HERO_CAMERA_LFT_EDGE  ; check left boundary
    jr c, _left              ; jump if hero < left edge

    cp HERO_CAMERA_RHT_EDGE  ; check right boundary
    jr c, _end               ; jump if hero < right edge

_right:
    ld e, CAMERA_STATE_RIGHT ; prepare state for pane right
    ld a, (hl)               ; HL = camera_x
    add a, HERO_CAMERA_PANE  ; calculate destination
    jr _apply                ; jump to shared store

_left:
    ld e, CAMERA_STATE_LEFT  ; prepare state for pane left
    ld a, (hl)               ; HL = camera_x
    sub HERO_CAMERA_PANE     ; calculate destination

_apply:
    ld (camera_dest_x), a
    ld a, e
    ld (camera_state), a

_end:

;-------------------------------------------------------------------------------
collisions:
;-------------------------------------------------------------------------------

; note: after this phase x and y must be out of collision since next phase will
;       save current x and y into previous for next frame

_check_sprite:
    ld a, (sprite_collided)
    or a
    jr z, _check_sprite_end

    ; restore previous position and set dx, dy to 0
    ld hl, (hero_x_prv)
    ld (hero_x), hl
    ld hl, (hero_y_prv)
    ld (hero_y), hl
    ld de, 0
    ld (hero_dx), de
    ld (hero_dy), de

    ; clear hero jumping flag
    ld hl, hero_flags
    res HERO_FLAG_JUMPING_BIT, (hl)

_check_sprite_end:

    ; note: tiles collision check is not fully correct but makes good gameplay

_check_tiles:
    ; calculate tile x = L and column = B
    ld a, (hero_x_screen)
    add a, TILE_CENTER_OFFSET ; bias toward tile center (rounded tile coordinate)
    rept TILE_SHIFT
        srl a
    endm
    ld b, a                 ; B = column
    ld a, (camera_x)
    add a, b
    ld l, a                 ; L = top left tile x

    ; calculate tile y
    ld a, (hero_y_screen)
    add a, TILE_CENTER_OFFSET ; bias toward tile center (rounded tile coordinate)
    rept TILE_SHIFT
        srl a
    endm
    ld c, a                 ; C = row
    ld h, a                 ; H = top left tile y

    ; point HL to top left tile
    ld de, tile_map
    add hl, de

_check_top_left:
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_top_right

    ; overwrite the picked tile
    ld (hl), TILE_ID_PICKED

    call render_single_tile

_check_top_right:
    inc l
    inc b
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_bottom_right

    ld (hl), TILE_ID_PICKED

    call render_single_tile

_check_bottom_right:
    inc h
    inc c
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_bottom_left

    ld (hl), TILE_ID_PICKED

    call render_single_tile

_check_bottom_left:
    dec l
    dec b
    ld a, (hl)              ; A = tile id
    cp TILE_ID_PICKABLE
    jr nz, _check_tiles_end

    ld (hl), TILE_ID_PICKED

    call render_single_tile

_check_tiles_end:

;-------------------------------------------------------------------------------
state:
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

_check_hero:
    ld bc, KEYBOARD_ROW_ASDGF
    in b, (c)           ; read row (0 = pressed)

_check_hero_left:
    bit 0, b            ; check key A
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
    bit 2, b            ; check key D
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
    bit 4, b            ; check key G
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
;-------------------------------------------------------------------------------
RENDER_SPRITE_LINE macro
    ; fetch sprite bytes
    ld d, (ix + 0)              ; load left sprite byte
    ld e, (ix + 1)              ; load right sprite byte
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
    srl d                       ; shift left byte, bit 0 goes to carry
    rr e                        ; rotate right byte, carry goes into bit 7
    rr c                        ; rotate spill byte, carry goes into bit 7
    djnz _loop_right
    jr _shift_done

_shift_left:
    ; flip sprite bytes for left shift
    ld c, e
    ld e, d
    ld d, 0
    neg                         ; calculate left shifts, 8 - right shifts
    add a, 8
    ld b, a
_loop_left:
    sla c                       ; shift spill left, bit 7 to carry
    rl e                        ; rotate middle, carry to bit 0
    rl d                        ; rotate left byte, carry to bit 0
    djnz _loop_left

_shift_done:

    ; 3 bytes to draw: D, E, C
    ; D = left, E = middle, C = right (spill)

    ; byte D
    ld a, (hl)                  ; load current screen pixels
    ld b, a                     ; save screen pixels
    and d                       ; check collision
    jr z, _no_col_d             ; skip if no collision
    ld (sprite_collided), a     ; store any non-zero = collision
_no_col_d:
    ld a, b                     ; reload screen pixels
    or d                        ; OR with sprite left
    ld (hl), a                  ; write back to screen
    inc l

    ; byte E
    ld a, (hl)
    ld b, a
    and e
    jr z, _no_col_e
    ld (sprite_collided), a
_no_col_e:
    ld a, b
    or e
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

    ; move sprite pointer +2
    inc ix
    inc ix

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
;   AF, BC, DE, HL, IX, IYL
;-------------------------------------------------------------------------------
render_sprite:
    ; clear collision byte (0 = no collision)
    xor a
    ld (sprite_collided), a

    ; calculate screen address

    ; H:   0  1  0 y7 y6 y2 y1 y0
    ; L:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                     ; y to A
    and %00000111               ; mask 00000111 (y bits 0-2)
    or %01000000                ; add base address
    ld h, a

    ld a, c                     ; y to A
    rra                         ; rotate y bits to position
    rra
    rra
    and %00011000               ; isolate y bits 3-4 (sector offset)
    or h
    ld h, a                     ; H is now correct

    ld a, c                     ; y to A
    rla                         ; rotate y bits to position
    rla
    and %11100000               ; isolate them
    ld l, a                     ; start L

    ld a, b                     ; x to A
    rept TILE_SHIFT             ; shift out the pixel fractions in a character
        rra
    endm
    and %00011111               ; isolate the column bits (0-31)
    or l                        ; combine with L
    ld l, a                     ; HL now points to screen byte

    ; prepare shift counter
    ld a, b
    and 7                       ; x % 8 (shift amount)
    ld IYL, a                   ; save for later use

    ; render the characters that enclose the sprite
rept SPRITE_HEIGHT
    RENDER_SPRITE_LINE
endm 

    ret

;-------------------------------------------------------------------------------
; restores tiles from tile_map for a 16 x 16 sprite area
;
; input:
;   B = x pixel
;   C = y pixel
;
; output: -
;
; clobbers:
;   AF, BC, DE, IX
;-------------------------------------------------------------------------------
restore_sprite_background
    ; calculate starting tile column x / 8
    ld a, b
    rept TILE_SHIFT
        rrca
    endm
    and %00011111       ; isolate column number
    ld b, a             ; B is screen column 0 to 31

    ; calculate starting tile row y / 8
    ld a, c
    rept TILE_SHIFT
        rrca
    endm
    and %00011111       ; isolate row number
    ld c, a             ; C is screen row 0 to 23

    call sprite_restore_tiles

    ret

;-------------------------------------------------------------------------------
; helper macro for `sprite_restore_3_tiles`
;-------------------------------------------------------------------------------
RENDER_TILE macro
    ld a, (hl)                  ; A = tile id
 
    ; make HL point at address of bitmap of tile index
    ; bit trickery because `charset` is aligned on 2048 boundary
    ld l, a                     ; move upper 3 bits of low byte to lower 3 bits
    and %11100000               ;  of high byte
    rlca
    rlca
    rlca
    or high charset             ; set upper 5 bits in high byte
    ld h, a                     ; H = high byte of the pointer
    ld a, l                     ; shift lower byte by 3 because a character is 8
    add a, a                    ;  bytes
    add a, a
    add a, a
    ld l, a                     ; L = low byte of the pointer
    ; HL = bitmap source

rept 7
    ld a, (hl)
    ld (de), a
    inc hl
    inc d                       ; D = next screen line
endm
    ld a, (hl)
    ld (de), a
endm

;-------------------------------------------------------------------------------
; restores 3 tiles in a row
;
; input:
;   B = column
;   C = row
;
; output: -
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
sprite_restore_tiles:
    ; calculate screen address

    ; D:   0  1  0 y7 y6 y2 y1 y0
    ; E:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                     ; A = screen row
    and %00011000               ; isolate row bits 3, 4
    or %01000000                ; add screen base 4000
    ld d, a                     ; D = screen high byte (y0, y1, y2 always 0)

    ld a, c                     ; A = screen row
    and %00000111               ; isolate row bits 0,1, 2
    rrca                        ; rotate lower bits to high bits
    rrca
    rrca                        ; moved low bits to 5 6 7
    or b                        ; add column B
    ld e, a                     ; E = screen low byte
    ; DE = screen destination

    ; calculate poinget tile id from map
    ld h, high tile_map         ; H = tile_map base
    ld a, c
    add a, h                    ; A = base high byte plus row
    ld h, a                     ; H = now the correct high byte
 
    ld a, (camera_x)            ; get current camera offset in A
    add a, b                    ; add screen x in B
    ld l, a                     ; L = map column
    ; HL = pointer to tile

    push de                     ; will be popped when advancing a row
    push hl

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                       ; next tile in row
    inc e                       ; next character on screen
    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l
    inc e
    RENDER_TILE

    pop hl
    pop de

    ; advance 1 row on screen
    ld a, d
    add a, 8
    ld d, a
    and 7
    jr nz, _row_ok_1

    ld a, e
    add a, SCREEN_WIDTH_CHARS
    ld e, a
    jr c, _row_ok_1

    ld a, d
    sub 8
    ld d, a

_row_ok_1:

    ; advance 1 row in tile map
    inc h

    push de                     ; will be popped when advancing a row
    push hl

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                       ; next tile in row
    inc e                       ; next character on screen
    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l
    inc e
    RENDER_TILE

    pop hl
    pop de

    ; advance 1 row on screen
    ld a, d
    add a, 8
    ld d, a
    and 7
    jr nz, _row_ok_2

    ld a, e
    add a, SCREEN_WIDTH_CHARS
    ld e, a
    jr c, _row_ok_2

    ld a, d
    sub 8
    ld d, a

_row_ok_2:

    ; advance 1 row in tile map
    inc h

    push de
    push hl
    RENDER_TILE
    pop hl
    pop de
    inc l                       ; next tile in row
    inc e                       ; next character on screen
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
;   B = column
;   C = row
;
; output: -
;
; clobbers:
;   AF, DE, HL
;-------------------------------------------------------------------------------
render_single_tile:
    ; get tile id from map
    ld h, high tile_map         ; H = tile_map base
    ld a, c
    add a, h                    ; A = base high byte plus row
    ld h, a                     ; H = now the correct high byte
 
    ld a, (camera_x)            ; get current camera offset in A
    add a, b                    ; add screen x in B
    ld l, a                     ; L = map column
    ; HL = pointer to tile

    ld a, (hl)                  ; A = tile id
 
    ; make HL point at address of bitmap of tile index
    ; bit trickery because `charset` is aligned on 2048 boundary
    ld l, a                     ; move upper 3 bits of low byte to lower 3 bits
    and %11100000               ;  of high byte
    rlca
    rlca
    rlca
    or high charset             ; set upper 5 bits in high byte
    ld h, a                     ; H = high byte of the pointer
    ld a, l                     ; shift lower byte by 3 because a character is 8
    add a, a                    ;  bytes
    add a, a
    add a, a
    ld l, a                     ; L = low byte of the pointer
    ; HL = bitmap source

    ; calculate screen address

    ; D:   0  1  0 y7 y6 y2 y1 y0
    ; E:  y5 y4 y3 x4 x3 x2 x1 x0

    ld a, c                     ; A = screen row
    and %00011000               ; isolate row bits 3, 4
    or %01000000                ; add screen base 4000 
    ld d, a                     ; D = screen high byte (y0, y1, y2 always 0)

    ld a, c                     ; A = screen row
    and %00000111               ; isolate row bits 0,1, 2
    rrca                        ; rotate lower bits to high bits
    rrca
    rrca                        ; moved low bits to 5 6 7
    or b                        ; add column B
    ld e, a                     ; E = screen low byte
    ; DE = screen destination

    ; copy 8 bytes

    ; scanline 0 to 6
rept 7
    ld a, (hl)
    ld (de), a
    inc hl
    inc d                       ; D = next screen line
endm

    ; scanline 7
    ld a, (hl)
    ld (de), a
 
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
    dw sprites_data_0
    dw sprites_data_1
    dw 0

hero_animation_left:
    dw sprites_data_2
    dw sprites_data_3
    dw 0

;-------------------------------------------------------------------------------
end start
