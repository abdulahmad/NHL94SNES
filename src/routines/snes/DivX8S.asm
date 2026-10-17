; X / A (8-bit) into A, X signed
DivX8S:								; X / A (8-bit) into A, X signed
	cpx.w #$0000
	bpl DivX8U
	phy
	tay
	txa
	eor.w #$FFFF
	inc a
	sta.w WRDIVL
	sep #$10
	sty.w WRDIVB
	rep #$10
	ply
	nop
	lda.w #$0000
	sec
	sbc.w RDDIVL
	rtl
