org $8000
  ld bc, MY_STRING

MY_LOOP:
  ld a, (bc)
  cp 0
  jr z, END_PROGRAM
  rst $10
  inc bc
  jr MY_LOOP

END_PROGRAM:
  ret

MY_STRING:
  defb "Hello, world!"
  defb 13, 0
END $8000
