#!/usr/bin/env python3

print(";")
print("; generated code, do not edit")
print(";")
print()
print("; screen_lut: 192 words (384 bytes) mapping y-line to screen memory address")
print("; align to 256 bytes for optimized indexing")

for y in range(192):
    # calculate spectrum memory address for scanline Y
    # format: 010 (y7 y6) (y2 y1 y0) (y5 y4 y3) (00000)
    third = (y & 0b11000000) >> 6
    line = y & 0b00000111
    sector = (y & 0b00111000) >> 3

    high_byte = 0x40 | (third << 3) | line
    low_byte = sector << 5

    address = (high_byte << 8) | low_byte

    if y % 8 == 0:
        print(f"\ndw ${address:04x}", end="")
    else:
        print(f", ${address:04x}", end="")

print()
