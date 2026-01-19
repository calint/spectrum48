# about z80 and spectrum 48k

## screen memory layout

The pixel data occupies 6,144 bytes, starting at memory address $4000
(16,384 decimal) and extending to $57FF (22,527 decimal)

On PAL, a scanline is 224 T-states

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

### 1. register roles (not equal)

* A   = arithmetic, logic, decisions (volatile)
* F   = flags (side effects only)
* B   = loop counter
* C   = I/O port, helper
* D,E = data transport
* H,L = pointer (HL)
* IX/IY = structured access (slow, document use)

### 2. where values want to live

* decision / compare → A
* boolean test        → A
* loop counter        → B
* pointer             → HL
* secondary pointer   → DE
* length              → BC
* temp scratch        → A

### 3. core idioms

#### test zero

    ld a, (x)
    or a
    jr z, zero

#### compare

    ld a, (x)
    cp y
    jr c, smaller

#### loop

    ld b, n
    loop:
        ...
    djnz loop

#### walk memory

    ld hl, table
    ld a, (hl)
    inc hl

#### block copy

    ld hl, src
    ld de, dst
    ld bc, len
    ldir

#### 16-bit add

    add hl, de

#### test hl == 0

    ld a, h
    or l
    jr z, zero

### 4. shifts & rotates

* A  = full support
* HL = manual

#### 8-bit

    srl a
    rrca
    rla

#### 16-bit right

    srl h
    rr  l

### 5. flags rules

* Flags are temporary
* Flags die after CALL
* Never depend on flags across labels

Idiomatic flag set:
    or a

### 6. scratch register priority

1) A
2) E / D
3) C
4) B
5) H / L (only if not pointer)

### 7. pointer conventions

* HL = active pointer (source)
* DE = secondary pointer (destination)
* BC = length

Follow this or code feels wrong.

### 8. calling convention mindset

Assume:

* A clobbered
* F clobbered
* Others only safe if documented

Always comment:

* inputs:
* outputs:
* clobbers:

### 9. smells to avoid

* math in HL when A fits
* loop counter in A
* pointer in B
* relying on flags after CALL
* silent IX/IY clobber

### 10. acceptable advanced tricks (document!)

* IXH / IYL usage
* unrolled loops
* recompute vs maintain state
* clarity over micro-optimizations

### 11. mental rule

Ask:
"What is this value doing?"

Then assign:

* deciding → A
* counting → B
* pointing → HL
* moving → DE
* temporary → A

### 12. mantra

"Let the Z80 lead — don’t fight it."

### 13. one sentence rule

Good z80 code can be read aloud:

* hl walks the map
* de copies the sprite
* b counts the rows
* a decides what happens next

If you cannot narrate it, simplify.

### 14. load direction bias

* load from memory into registers early
* write back to memory late
* keep values in registers as long as possible
* memory access is expensive mentally even when it is cheap in cycles.

### 15. fallthrough is a feature

* structure code so the common path falls through
* jump only for rare cases
* avoid jump ladders

Good z80 code reads top to bottom.

### 16. compare is cheaper than you think

* cp is often clearer than clever bit tests
* explicit compares beat flag archaeology
* readability wins over one instruction savings

If you must explain a compare, it is too clever.

### 17. stack discipline

* stack is not scratch space
* push pop only around clear ownership boundaries
* deep push pop chains are a smell

If you push more than two registers, reconsider the design.

### 18. sp is sacred

* never repurpose sp
* never do arithmetic on sp
* never use stack tricks in gameplay code

Stack bugs are catastrophic and hard to debug.

### 19. instruction shape matters

Prefer:
    ld a,(hl)
    inc hl

Over:
    inc hl
    ld a,(hl)

Because the first matches how humans read memory walking.

### 20. self modifying code rule

* acceptable only for inner loops
* must be isolated and commented
* never mix with logic

If smc leaks into control flow, maintenance collapses.

### 21. jr vs jp instinct

* jr for local structure
* jp for architectural jumps
* jr implies relationship
* jp implies separation

If a jr crosses a screen of code, rethink layout.

### 22. labels express intent

* labels are not comments
* label names should explain why, not what
* avoid generic labels like loop1 temp skip

If the label lies, the code will too.

### 23. constants vs memory rule

* constants are immutable truths
* memory variables represent state
* never blur the two

If something changes, it should live in memory.

### 24. interrupt awareness rule

* any code may be interrupted
* do not assume atomicity unless interrupts are disabled
* shared data must be designed intentionally

If an interrupt can break it, it eventually will.

### 25. disable interrupts sparingly

* di is a strong smell
* ei must be near di
* long critical sections are wrong

If di feels necessary, question the architecture.

### 26. slow instructions are not evil

* ldir is slow but clear
* ix iy are slow but expressive
* clarity beats premature speed

Optimize only after measuring or feeling pain.

### 25. screen math isolation

* keep screen address math in one place
* never sprinkle screen calculations everywhere
* wrap them in routines or macros

Screen bugs multiply when logic leaks.

### 26. symmetry rule

If you:

* save something
* allocate something
* modify something

Then somewhere you must:

* restore it
* free it
* undo it

Asymmetry causes long term bugs.

### 27. one owner per variable

* every variable should have a conceptual owner
* avoid shared responsibility
* document ownership in comments if needed

Shared ownership causes subtle corruption.

### 28. test on real hardware mindset

* emulators forgive timing
* real hardware does not
* clean logic survives both

Write as if the machine is unforgiving.

### 29. comfort test

Ask:
“Would i trust this code at 3 am with a bug report”

If not, simplify.

### 30. boredom test

Good z80 code is slightly boring.

If it feels exciting, it is probably fragile.

### 31. final instinct

When stuck:

* reload values
* recompute addresses
* reset assumptions

The z80 prefers recomputation over clever state.
