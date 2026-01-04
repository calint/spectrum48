# about z80 and spectrum 48k

## screen memory layout

The pixel data occupies 6,144 bytes, starting at memory address $4000
(16,384 decimal) and extending to $57FF (22,527 decimal)

```text
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
```

## keyboard

```text
Port (BC)   Bit 0   Bit 1   Bit 2   Bit 3   Bit 4
$FEFE       SHIFT   Z       X       C       V
$FDFE       A       S       D       F       G
$FBFE       Q       W       E       R       T
$F7FE       1       2       3       4       5
$EFFE       0       9       8       7       6
$DFFE       P       O       I       U       Y
$BFFE       ENTER   L       K       J       H
$7FFE       SPACE   SYM     M       N       B
```

## Z80 Register Usage & Idioms — Mental Cheat Sheet

### 1. Register Roles (not equal)

* A   = arithmetic, logic, decisions (volatile)
* F   = flags (side effects only)
* B   = loop counter
* C   = I/O port, helper
* D,E = data transport
* H,L = pointer (HL)
* IX/IY = structured access (slow, document use)

### 2. Where values want to live

* decision / compare → A
* boolean test        → A
* loop counter        → B
* pointer             → HL
* secondary pointer   → DE
* length              → BC
* temp scratch        → A

### 3. Core idioms

#### Test zero

    ld a,(x)
    or a
    jr z, zero

#### Compare

    ld a,(x)
    cp y
    jr c, smaller

#### Loop

    ld b,n
    loop:
        ...
    djnz loop

#### Walk memory

    ld hl,table
    ld a,(hl)
    inc hl

#### Block copy

    ld hl,dst
    ld de,src
    ld bc,len
    ldir

#### 16-bit add

    add hl,de

#### Test HL == 0

    ld a,h
    or l
    jr z, zero

### 4. Shifts & rotates

* A  = full support
* HL = manual

#### 8-bit

    srl a
    rrca
    rla

#### 16-bit right

    srl h
    rr  l

### 5. Flags rules

* Flags are temporary
* Flags die after CALL
* Never depend on flags across labels

Idiomatic flag set:
    or a

### 6. Scratch register priority

1) A
2) E / D
3) C
4) B
5) H / L (only if not pointer)

### 7. Pointer conventions

* HL = active pointer
* DE = secondary pointer
* BC = length

Follow this or code feels wrong.

### 8. Calling convention mindset

Assume:

* A clobbered
* F clobbered
* Others only safe if documented

Always comment:

* inputs:
* outputs:
* clobbers:

### 9. Smells to avoid

* math in HL when A fits
* loop counter in A
* pointer in B
* relying on flags after CALL
* silent IX/IY clobber

### 10. Acceptable advanced tricks (document!)

* IXH / IYL usage
* unrolled loops
* recompute vs maintain state
* clarity over micro-optimizations

### 11. Mental rule

Ask:
"What is this value doing?"

Then assign:

* deciding → A
* counting → B
* pointing → HL
* moving → DE
* temporary → A

### 12. Mantra

"Let the Z80 lead — don’t fight it."
