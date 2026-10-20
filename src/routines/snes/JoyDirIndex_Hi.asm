; JoyDirIndex of the high byte of A; JoyDirIndex: X = 2 * JoyDirTable[the dpad bits A & $F]
;
; Takes: A = pad word. Returns X = 2 * JoyDirTable[direction bits]. No caller found in the ROM.
JoyDirIndex_Hi:						; JoyDirIndex of the high byte of A
	xba								; high byte of A to the low byte

JoyDirIndex:						; low nibble of A = the d-pad bits
	and.w #$000F
	tax
	lda.l JoyDirTable,x
	and.w #$00FF
	asl a
	tax
	rtl
