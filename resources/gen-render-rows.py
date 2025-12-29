#!/usr/bin/env python3
"""
generate unrolled z80 code for rendering all 24 tile rows on zx spectrum 48k
"""

for row in range(24):
    if row < 8:
        base_d = 0x40
        row_in_third = row
    elif row < 16:
        base_d = 0x48
        row_in_third = row - 8
    else:
        base_d = 0x50
        row_in_third = row - 16

    e_offset = row_in_third * 32

    print(f"    ; row {row}")
    print("    ; place DE to screen destination of tile bitmap")
    print(f"    ld d, ${base_d:02X}")
    if e_offset == 0:
        print("    ld e, ixh")
    else:
        print("    ld a, ixh")
        print(f"    add a, {e_offset}")
        print("    ld e, a")
    print("    ; DE now at screen destination")
    print("    ; place HL at tile")
    print(f"    ld h, (tile_map / 256) + {row}")
    print("    ld a, (camera_x)")
    print("    add a, ixh")
    print("    ld l, a")
    print("    ; load A with tile number")
    print("    ld a, (hl)")
    print("    ; place HL at tile bitmap")
    print("    ld l, a")
    print("    ld h, 0")
    print("    add hl, hl")
    print("    add hl, hl")
    print("    add hl, hl")
    print("    ld bc, charset")
    print("    add hl, bc")
    print("    ; HL now at tile bitmap")

    for scanline in range(8):
        print(f"    ; scanline {scanline}")
        print("    ld a, (hl)")
        print("    ld (de), a")
        print("    inc hl")
        if scanline < 7:
            print("    inc d")
    print()
