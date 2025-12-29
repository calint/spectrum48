    ;
    ; generated code, do not edit
    ;

    ; input: IXL = tile map column offset, IXH = screen column number
    ; row 0
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld e, ixh
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 0
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 1
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 32
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 1
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 2
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 64
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 2
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 3
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 96
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 3
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 4
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 128
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 4
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 5
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 160
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 5
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 6
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 192
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 6
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 7
    ; place DE to screen destination of tile bitmap
    ld d, $40
    ld a, ixh
    add a, 224
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 7
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 8
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld e, ixh
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 8
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 9
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 32
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 9
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 10
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 64
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 10
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 11
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 96
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 11
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 12
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 128
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 12
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 13
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 160
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 13
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 14
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 192
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 14
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 15
    ; place DE to screen destination of tile bitmap
    ld d, $48
    ld a, ixh
    add a, 224
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 15
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 16
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld e, ixh
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 16
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 17
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 32
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 17
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 18
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 64
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 18
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 19
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 96
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 19
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 20
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 128
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 20
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 21
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 160
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 21
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 22
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 192
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 22
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

    ; row 23
    ; place DE to screen destination of tile bitmap
    ld d, $50
    ld a, ixh
    add a, 224
    ld e, a
    ; DE now at screen destination
    ; place HL at tile
    ld h, (tile_map / 256) + 23
    ld a, ixl
    add a, ixh
    ld l, a
    ; load A with tile number
    ld a, (hl)
    ; place HL at tile bitmap
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, charset
    add hl, bc
    ; HL now at tile bitmap
    ; scanline 0
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 1
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 2
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 3
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 4
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 5
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 6
    ld a, (hl)
    ld (de), a
    inc hl
    inc d
    ; scanline 7
    ld a, (hl)
    ld (de), a

