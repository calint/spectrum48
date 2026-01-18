#!/usr/bin/env python3
"""
generate optimized code to render a column using an unrolled loop
assumes charset is 2k aligned: org ($ + 2047) & $f800
"""

print("    ;")
print("    ; generated code by `gen-render-rows.py`, do not edit")
print("    ;")
print()
print("    ;  assumes: `charset` aligned on 2048, `tile_map` aligned on 256")
print("    ;    input: B = screen column number, C = tile map offset")
print("    ; clobbers: AF, DE, HL, SP")
print()
print("    ; note: since `charset` is aligned on 2048 the lowest 11 bits in")
print("    ;       the pointer are 0's which opens for optimization using bit")
print("    ;       operations such as roll 3 high bits in lower byte into the")
print("    ;       low bits of the high byte of the pointer, then left shift")
print("    ;       tile index byte by 3 (high bits have already been moved to")
print("    ;       high byte) then compose HL")
print("    ; note: using SP gives 213 T, 41 B vs 251 T, 51 B per tile")
print()

for row in range(24):
    print(f"    ; row {row}")

    # tile map pointer HL
    print("    ; SP to tile bitmap")
    print(f"    ld h, (high tile_map) + {row}")
    print("    ld l, c          ; tile map offset")
    print("    ld a, (hl)       ; A = tile index")

    # tile bitmap pointer to HL
    print("    ld l, a          ; backup tile index")
    print("    and %11100000    ; get top 3 bits")
    print("    rlca             ; shift to bottom")
    print("    rlca")
    print("    rlca")
    print("    or high charset  ; set upper 5 bits in high byte")
    print("    ld h, a          ; H = charset page")
    print("    ld a, l          ; shift tile index by 3")
    print("    add a, a         ; x2")
    print("    add a, a         ; x4")
    print("    add a, a         ; x8")
    print("    ld l, a          ; HL = bitmap address")
    print("    ld sp, hl")
    print()
    print("    ; HL to screen destination")
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

    # screen pointer DE
    print(f"    ld h, ${base_d:02X}")
    if e_offset == 0:
        print("    ld l, b          ; screen column offset")
    else:
        print("    ld a, b          ; screen column offset")
        print(f"    add a, {e_offset}")
        print("    ld l, a          ; HL = screen destination")

    print()
    # unrolled scanline copy
    for scanline in range(4):
        print(f"    pop de           ; scanline {scanline * 2}, {scanline * 2 + 1}")
        print("    ld (hl), e")
        print("    inc h")
        print("    ld (hl), d")
        if scanline < 3:
            print("    inc h")
    print()
