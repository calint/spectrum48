#!/bin/sh
set -e
cd "$(dirname "$0")"

resources/update.sh
pasmo -I src --tapbas src/main.asm main.tap
GDK_DPI_SCALE=1.5 fuse main.tap
