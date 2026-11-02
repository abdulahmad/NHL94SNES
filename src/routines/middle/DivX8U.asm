; X / A (8-bit) into A with the hardware divider
DivX8U:								; X / A (8-bit) into A with the hardware divider
	sep #$20
	stx.w WRDIVL
	sta.w WRDIVB
	rep #$20
	phx
	plx
	nop
	lda.w RDDIVL
	rtl
