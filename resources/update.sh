#!/bin/sh
set -e
cd $(dirname "$0")

#./gen-tile-map.py tile-map.tmx 0 0xfffffff >../src/tile_map.s
./gen-charset.py custom-charset.png >../src/charset.asm
