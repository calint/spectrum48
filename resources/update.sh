#!/bin/sh
set -e
cd $(dirname "$0")

./gen-tile-map.py tile-map.tmx 0 0xfffffff >../src/tile_map.asm
./gen-charset.py custom-charset.png >../src/charset.asm
./gen-sprites-data.py 0 sprites-48.png >../src/sprites.asm
./gen-render-rows.py >../src/render_rows.asm
#./gen-screen-lut.py >../src/screen_lut.asm
