    ;
    ; generated code by `gen-render-rows.py`, do not edit
    ;

    ;  assumes: `charset` aligned on 2048, `tile_map` aligned on 256
    ;    input: B = screen column number, C = tile map offset
    ; clobbers: AF, DE, HL, SP

    ; note: since `charset` is aligned on 2048 the lowest 11 bits in
    ;       the pointer are 0's which opens for optimization using bit
    ;       operations such as roll 3 high bits in lower byte into the
    ;       low bits of the high byte of the pointer, then left shift
    ;       tile index byte by 3 (high bits have already been moved to
    ;       high byte) then compose HL
    ; note: using SP gives 162 T, 28 B  vs  168 T, 30 B when copying
    ;       8 scanlines from HL to DE

    ; row 0
    ld d, $40
    ld e, b          ; screen column offset
    ld h, (high tile_map) + 0
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 1
    ld d, $40
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 1
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 2
    ld d, $40
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 2
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 3
    ld d, $40
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 3
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 4
    ld d, $40
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 4
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 5
    ld d, $40
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 5
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 6
    ld d, $40
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 6
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 7
    ld d, $40
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 7
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 8
    ld d, $48
    ld e, b          ; screen column offset
    ld h, (high tile_map) + 8
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 9
    ld d, $48
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 9
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 10
    ld d, $48
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 10
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 11
    ld d, $48
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 11
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 12
    ld d, $48
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 12
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 13
    ld d, $48
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 13
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 14
    ld d, $48
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 14
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 15
    ld d, $48
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 15
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 16
    ld d, $50
    ld e, b          ; screen column offset
    ld h, (high tile_map) + 16
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 17
    ld d, $50
    ld a, b          ; screen column offset
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 17
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 18
    ld d, $50
    ld a, b          ; screen column offset
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 18
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 19
    ld d, $50
    ld a, b          ; screen column offset
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 19
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 20
    ld d, $50
    ld a, b          ; screen column offset
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 20
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 21
    ld d, $50
    ld a, b          ; screen column offset
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 21
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 22
    ld d, $50
    ld a, b          ; screen column offset
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 22
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

    ; row 23
    ld d, $50
    ld a, b          ; screen column offset
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (high tile_map) + 23
    ld l, c          ; tile map offset
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup tile index
    and %11100000    ; get top 3 bits
    rlca             ; shift to bottom
    rlca
    rlca
    or high charset  ; set upper 5 bits in high byte
    ld h, a          ; H = charset page
    ld a, l          ; shift tile index by 3
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address

    ld sp, hl
    pop hl           ; scanline 0, 1
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 2, 3
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 4, 5
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a
    inc d
    pop hl           ; scanline 6, 7
    ld a, l
    ld (de), a
    inc d
    ld a, h
    ld (de), a

