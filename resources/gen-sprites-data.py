#!/usr/bin/env python3

from PIL import Image
import sys

if len(sys.argv) < 3:
    print("Usage: ./gen-sprites-data.py <start_label_index> <filename>")
    sys.exit(1)

label_ix = int(sys.argv[1])
filename = sys.argv[2]

print(";")
print("; generated code, do not edit")
print(";\n")

with Image.open(filename) as img:
    if img.mode != "P":
        print("Error: PNG must be paletted.")
        sys.exit(1)

    img_width, img_height = img.size

    sheet_sprite_width = 24
    sheet_sprite_height = 21

    out_width = 16
    out_height = 16

    for row in range(0, img_height, sheet_sprite_height):
        for col in range(0, img_width, sheet_sprite_width):
            print(f"sprites_data_{label_ix}:")
            label_ix += 1

            for y in range(row, row + out_height):
                bytes_out = []

                for byte_idx in range(2):  # 16 pixels = 2 bytes
                    x_start = col + byte_idx * 8
                    byte_val = 0

                    for i in range(8):
                        pixel = img.getpixel((x_start + i, y))
                        byte_val = (byte_val << 1) | (0 if pixel == 0 else 1)

                    bytes_out.append(f"%{byte_val:08b}")

                print(f"db {', '.join(bytes_out)} ; {y - row}")
            print()
