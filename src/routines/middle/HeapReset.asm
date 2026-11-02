; HeapInit at the same starts
;
; Keeps all registers. No caller found in the ROM.
HeapReset:							; HeapInit at the same starts
	pha
	phx
	phy
	ldx.w HeapStart7E
	ldy.w HeapStart7F
	jsl.l HeapInit					; set up both heaps
	ply
	plx
	pla
	rtl
