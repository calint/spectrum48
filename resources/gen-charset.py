#!/bin/python3

from PIL import Image
import sys

if len(sys.argv) < 2:
    print("Usage: ./gen-charset.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

print(";")
print("; generated code, do not edit")
print(";\n")
with Image.open(filename) as img:
    if img.mode != "P":
        print("Error: The PNG is not paletted.")
        sys.exit(1)

    BACKGROUND_PALETTE_INDEX = 0

    char_width = 8
    char_height = 8
    img_width, img_height = img.size
    ix = 0
    for row in range(0, img_height, char_height):
        for column in range(0, img_width, char_width):
            print(f"; {ix}")
            ix += 1
            for y in range(row, row + char_height):
                for start_x in range(column, column + char_width, 8):
                    # note: 8 is number of pixels per byte
                    byte_value = 0
                    for i in range(8):
                        x = start_x + i
                        pixel = img.getpixel((x, y))
                        bit = 1 if pixel != BACKGROUND_PALETTE_INDEX else 0
                        byte_value = (byte_value << 1) | bit
                    print(f"db %{byte_value:08b}", end="")
                print()
            print()
