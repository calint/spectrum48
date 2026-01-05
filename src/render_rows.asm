    ;
    ; generated code by `gen-render-rows.py`, do not edit
    ;

    ;  assumes: `charset` aligned on 2048, `tile_map` aligned on 256
    ;    input: B = screen column number, C = tile map offset
    ; clobbers: A, D, E, H, L

    ; note: since `charset` is aligned on 2048 the lowest 11 bits in
    ;       the pointer are 0's which opens for optimization using bit
    ;       operations such as roll 3 top bits in lower byte into the
    ;       high byte of the pointer (bit 10, 9, 8 with base 0 in the
    ;       16-bit pointer) then left shift lower byte by 3 (8 bytes 
    ;       per character bitmap) then compose the pointer with HL

    ; row 0
    ld d, $40
    ld e, b          ; screen column offset
    ld h, (tile_map / 256) + 0
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 1
    ld d, $40
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 1
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 2
    ld d, $40
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 2
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 3
    ld d, $40
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 3
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 4
    ld d, $40
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 4
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 5
    ld d, $40
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 5
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 6
    ld d, $40
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 6
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 7
    ld d, $40
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 7
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 8
    ld d, $48
    ld e, b          ; screen column offset
    ld h, (tile_map / 256) + 8
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 9
    ld d, $48
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 9
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 10
    ld d, $48
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 10
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 11
    ld d, $48
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 11
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 12
    ld d, $48
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 12
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 13
    ld d, $48
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 13
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 14
    ld d, $48
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 14
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 15
    ld d, $48
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 15
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 16
    ld d, $50
    ld e, b          ; screen column offset
    ld h, (tile_map / 256) + 16
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 17
    ld d, $50
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 17
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 18
    ld d, $50
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 18
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 19
    ld d, $50
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 19
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 20
    ld d, $50
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 20
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 21
    ld d, $50
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 21
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 22
    ld d, $50
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 22
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

    ; row 23
    ld d, $50
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 23
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)       ; copy scanline 0
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 1
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 2
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 3
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 4
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 5
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 6
    ld (de), a
    inc l
    inc d
    ld a, (hl)       ; copy scanline 7
    ld (de), a

