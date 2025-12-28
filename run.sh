#!/bin/sh
set -e

pasmo --tapbas src/main.asm main.tap
GDK_DPI_SCALE=1.5 fuse main.tap
