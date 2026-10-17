; quotient $7FFF
Div_Overflow:
	rep #$20
	lda.w #$7FFF
	sta.b r0
	rtl
	sep #$20						; not reached
Div32U_ByteDivisor:					; $08-$0A / $04 (8-bit) with the hardware divider, high byte first
	lda.b r2+2
	beq Div16x8U_Go
	cmp.b r1
	bcs Div_Overflow
	ldx.b r2+1
	lda.b r1
	stx.w WRDIVL
	sta.w WRDIVB
	phx
	plx
	nop
	nop
	lda.w RDDIVL
	sta.b r0+1
	lda.w RDMPYL
	sta.b r2+1
	lda.b r1
	ldx.b r2
	stx.w WRDIVL
	sta.w WRDIVB
	phx
	plx
	nop
	nop
	lda.w RDDIVL
	sta.b r0
	rep #$20
	rtl
