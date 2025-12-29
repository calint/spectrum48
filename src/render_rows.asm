    ;
    ; generated code by `gen-render-rows.py`, do not edit
    ;

    ;  assumes: `charset` aligned on 2048, `tile_map` aligned on 256
    ;    input: IXL = tile map column offset, IXH = screen column number
    ; clobbers: A, B, C, D, E, H, L

    ld a, ixl
    add a, ixh
    ld c, a          ; C = constant tile map column

    ; row 0
    ld d, $40
    ld e, ixh
    ld h, (tile_map / 256) + 0
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 1
    ld d, $40
    ld a, ixh
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 1
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 2
    ld d, $40
    ld a, ixh
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 2
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 3
    ld d, $40
    ld a, ixh
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 3
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 4
    ld d, $40
    ld a, ixh
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 4
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 5
    ld d, $40
    ld a, ixh
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 5
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 6
    ld d, $40
    ld a, ixh
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 6
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 7
    ld d, $40
    ld a, ixh
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 7
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 8
    ld d, $48
    ld e, ixh
    ld h, (tile_map / 256) + 8
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 9
    ld d, $48
    ld a, ixh
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 9
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 10
    ld d, $48
    ld a, ixh
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 10
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 11
    ld d, $48
    ld a, ixh
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 11
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 12
    ld d, $48
    ld a, ixh
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 12
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 13
    ld d, $48
    ld a, ixh
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 13
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 14
    ld d, $48
    ld a, ixh
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 14
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 15
    ld d, $48
    ld a, ixh
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 15
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 16
    ld d, $50
    ld e, ixh
    ld h, (tile_map / 256) + 16
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 17
    ld d, $50
    ld a, ixh
    add a, 32
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 17
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 18
    ld d, $50
    ld a, ixh
    add a, 64
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 18
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 19
    ld d, $50
    ld a, ixh
    add a, 96
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 19
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 20
    ld d, $50
    ld a, ixh
    add a, 128
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 20
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 21
    ld d, $50
    ld a, ixh
    add a, 160
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 21
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 22
    ld d, $50
    ld a, ixh
    add a, 192
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 22
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

    ; row 23
    ld d, $50
    ld a, ixh
    add a, 224
    ld e, a          ; DE = screen dest
    ld h, (tile_map / 256) + 23
    ld l, c
    ld a, (hl)       ; A = tile index
    ld l, a          ; backup index
    and %11100000    ; get top 3 bits for high byte
    rlca             ; shift to bottom
    rlca
    rlca
    add a, (charset / 256) & $ff
    ld h, a          ; H = charset page
    ld a, l
    add a, a         ; x2
    add a, a         ; x4
    add a, a         ; x8
    ld l, a          ; HL = bitmap address
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline
    inc hl
    inc d
    ld a, (hl)
    ld (de), a       ; copy scanline

