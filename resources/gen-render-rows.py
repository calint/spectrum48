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
print("    ; clobbers: A, D, E, H, L")
print()
print("    ; note: since `charset` is aligned on 2048 the lowest 11 bits in")
print("    ;       the pointer are 0's which opens for optimization using bit")
print("    ;       operations such as roll 3 high bits in lower byte into the")
print("    ;       low bits of the high byte of the pointer, then left shift")
print("    ;       tile index byte by 3 (high bits have already been moved to")
print("    ;       high byte) then compose HL")
print()

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

    # screen pointer DE
    print(f"    ld d, ${base_d:02X}")
    if e_offset == 0:
        print("    ld e, b          ; screen column offset")
    else:
        print("    ld a, b          ; screen column offset")
        print(f"    add a, {e_offset}")
        print("    ld e, a          ; DE = screen dest")

    # tile map pointer HL
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

    # unrolled scanline copy
    for scanline in range(8):
        print(f"    ld a, (hl)       ; copy scanline {scanline}")
        print("    ld (de), a")
        if scanline < 7:
            print("    inc l")
            print("    inc d")
    print()
