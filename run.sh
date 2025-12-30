#!/bin/sh
set -e
cd "$(dirname "$0")"

resources/update.sh
pasmo -I src --tapbas src/main.asm main.tap
echo --------------------------------------------------------------------------------
echo $((32767 - ($(stat -c%s main.tap) - 21))) "bytes free in 32k block"
echo --------------------------------------------------------------------------------
GDK_DPI_SCALE=1.5 fuse main.tap
