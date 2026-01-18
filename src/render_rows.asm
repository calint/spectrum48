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
    ; note: using SP gives 213 T, 41 B vs 251 T, 51 B per tile

    ; row 0
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld l, b          ; screen column offset

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 1
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 32
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 2
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 64
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 3
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 96
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 4
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 128
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 5
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 160
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 6
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 192
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 7
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $40
    ld a, b          ; screen column offset
    add a, 224
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 8
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld l, b          ; screen column offset

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 9
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 32
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 10
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 64
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 11
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 96
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 12
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 128
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 13
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 160
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 14
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 192
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 15
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $48
    ld a, b          ; screen column offset
    add a, 224
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 16
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld l, b          ; screen column offset

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 17
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 32
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 18
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 64
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 19
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 96
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 20
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 128
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 21
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 160
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 22
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 192
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

    ; row 23
    ; SP to tile bitmap
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

    ; HL to screen destination
    ld h, $50
    ld a, b          ; screen column offset
    add a, 224
    ld l, a          ; HL = screen destination

    pop de           ; scanline 0, 1
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 2, 3
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 4, 5
    ld (hl), e
    inc h
    ld (hl), d
    inc h
    pop de           ; scanline 6, 7
    ld (hl), e
    inc h
    ld (hl), d

