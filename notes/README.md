# about

## screen memory layout

The pixel data occupies 6,144 bytes, starting at memory address $4000
(16,384 decimal) and extending to $57FF (22,527 decimal)

256 pixels wide
┌────────────────────────────────────────┐
│                                        │ 192 pixels tall
│                                        │
│                                        │
└────────────────────────────────────────┘

1 byte = 8 horizontal pixels
32 bytes = 256 pixels (one scanline)

$4000  ┌───────────────┐  Top third (lines 0–63)
       │ lines 0–7     │
       │ lines 8–15    │
       │ lines 16–23   │
       │ lines 24–31   │
       │ lines 32–39   │
       │ lines 40–47   │
       │ lines 48–55   │
       │ lines 56–63   │
$4800  ├───────────────┤  Middle third (64–127)
$5000  ├───────────────┤  Bottom third (128–191)

H:  0 1 0 Y7 Y6 Y2 Y1 Y0
     │ │  │  │  └─────── row inside 8-line band (0–7)
     │ │  └──────────── screen third selector
     └ └────────────── fixed screen base ($4000)

L:  Y5 Y4 Y3 X4 X3 X2 X1 X0
     │  │  │  └────────── column (0–31)
     └──┴──┴──────────── character row inside third

32 bytes = one full screen row (256 pixels)

Before:
L = |char_row||column|

After +32:
L = |char_row+1||column|

## keyboard

Port (BC)   Bit 0   Bit 1   Bit 2   Bit 3   Bit 4
$FEFE       SHIFT   Z       X       C       V
$FDFE       A       S       D       F       G
$FBFE       Q       W       E       R       T
$F7FE       1       2       3       4       5
$EFFE       0       9       8       7       6
$DFFE       P       O       I       U       Y
$BFFE       ENTER   L       K       J       H
$7FFE       SPACE   SYM     M       N       B
