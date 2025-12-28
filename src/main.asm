org $8000

border: equ 5

start:
ld a, border
out ($fe), a

ld bc, hello

.loop:
ld a, (bc)
cp 0
jr z, done
rst $10
inc bc
jr .loop

done:
ret

hello:
defb "hello, world!"
defb 13, 0

end start
