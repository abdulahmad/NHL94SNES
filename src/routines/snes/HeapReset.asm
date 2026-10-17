; HeapInit at the same starts
HeapReset:							; HeapInit at the same starts
	pha
	phx
	phy
	ldx.w HeapStart7E
	ldy.w HeapStart7F
	jsl.l HeapInit
	ply
	plx
	pla
	rtl
