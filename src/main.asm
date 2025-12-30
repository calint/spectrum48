org $8000
;-------------------------------------------------------------------------------
; constants
;-------------------------------------------------------------------------------
BORDER_VBLANK: equ 1
BORDER_RENDER: equ 14

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
 
    ld a, BORDER_RENDER ; visualize render tile map phase
    out ($fe), a

input:
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

render:
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

    ld a, (hero_x)
    ld b, a
    ld a, (hero_y)
    ld c, a
    ld ix, sprites_data_8
    call render_sprite

    ld a, (sprite_collision)
    ld hl, $401f
    ld (hl), a
    jp main_loop

hero_x: defb 0
hero_y: defb 0
sprite_collision: defb 0

; ----------------------------------------------------------------
; inputs:  b = x coordinate (0-255 pixels)
;          c = y coordinate (0-191 pixels)
;          ix = pointer to sprite data
; ----------------------------------------------------------------
render_sprite:
    xor a
    ld (sprite_collision), a

    ; --- step 1: calculate screen address ---
    ld a, c                     ; y to a
    and $07                     ; mask 00000111 (y bits 0-2)
    or $40                      ; add base address (e.g., $d0)
    ld h, a                     ; store in h

    ld a, c
    rra                         ; rotate y bits to position
    rra
    rra
    and $18                     ; isolate y bits 3-4 (sector offset)
    or h
    ld h, a                     ; h is now correct

    ld a, c
    rla                         ; rotate y bits 5-7 to position
    rla
    and $e0                     ; isolate them
    ld l, a                     ; start l

    ld a, b                     ; x to a
    rra
    rra
    rra
    and $1f                     ; x / 8 (column 0-31)
    or l                        ; combine with l
    ld l, a                     ; hl now points to screen byte

    ; --- step 2: prepare shift counter ---
    ld a, b
    and $07                     ; x % 8 (shift amount)
    ld (shift_amt), a           ; save for later loop
 
    ld b, 16                    ; loop counter (16 lines)

draw_loop:
    push bc                     ; save loop counter
    push hl                     ; save screen address start of line

    ; --- step 3: fetch sprite bytes ---
    ld d, (ix+0)                ; load left sprite byte
    ld e, (ix+1)                ; load right sprite byte

    ; --- step 4: shift 16-bit row right by (shift_amt) ---
    ; we need to shift de into a 3rd byte (let's use c)
    ld c, 0                     ; c will hold the "spillover" bits

    ld a, (shift_amt)
    or a                        ; check if shift is 0
    jr z, shift_done            ; skip if no shift needed (fast path)
 
    ld b, a                     ; b = shift counter
shift_bits:
    srl d                       ; shift left byte, bit 0 goes to carry
    rr e                        ; rotate right byte, carry goes into bit 7
    rr c                        ; rotate spill byte, carry goes into bit 7
    djnz shift_bits

shift_done:
    ; we now have 3 bytes to draw: d, e, c
    ; d = left, e = middle, c = right (spill)

    ; --- step 5: draw to screen (or logic) ---
    ; byte 1
    ld a, (hl)                  ; get current screen
    and d                       ; check collision
    ld b, a                     ;
    ld a, (sprite_collision)    ;
    or b                        ;
    ld (sprite_collision), a    ;
    ld a, (hl)                  ; reload screen pixels
    or d                        ; or with sprite left
    ld (hl), a                  ; write back
    inc hl

    ; byte 2
    ld a, (hl)
    and e                       ; check collision
    ld b, a                     ;
    ld a, (sprite_collision)    ;
    or b                        ;
    ld (sprite_collision), a    ;
    ld a, (hl)                  ; reload screen pixels
    or e                        ; or with sprite middle
    ld (hl), a
    inc hl

    ; byte 3 (spillover)
    ld a, (hl)
    and c
    ld b, a
    ld a, (sprite_collision)
    or b
    ld (sprite_collision), a
    ld a, (hl)                  ; reload screen pixels
    or c                        ; or with sprite spill
    ld (hl), a

    ; --- step 6: advance pointers ---
    pop hl                      ; restore start of line address
    call move_down_scanline     ; helper to move hl down 1 pixel row

    inc ix                      ; move sprite pointer +2
    inc ix
 
    pop bc                      ; restore loop counter
    djnz draw_loop
    ret

; helper: calculate pixel row down logic for spectrum layout
move_down_scanline:
    inc h                       ; increment high byte (pixel row)
    ld a, h
    and $07                     ; check if we crossed 8-line char boundary
    ret nz                      ; if not 0, we are safe

    ; if we wrapped 0-7, we need to fix the address
    ld a, l
    add a, 32                   ; move to next character row
    ld l, a
    ret c                       ; if carry, we moved to next third, standard handling is ok

    ld a, h                     ; otherwise, subtract 8 from h to stay in correct third
    sub 8
    ld h, a
    ret

; variable storage
shift_amt: db 0
;-------------------------------------------------------------------------------
; variables
;-------------------------------------------------------------------------------
camera_x: defb 0

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
