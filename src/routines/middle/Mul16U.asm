; A * X into $08-$0B, unsigned
Mul16U:								; called from DrawPlayerPicture, MapPartToVRAM, MapPartToVRAMOffset, Mo...
	phy
	tay
	beq Mul16_Zero
	sta.b r0
	txa
	beq Mul16_Zero
Mul16U_Go:							; called from Mul16S, Mul16U_Pre, Mul16XS_TestX
	sep #$20
	sta.w WRMPYA
	sty.w WRMPYB
	stz.b r2
	xba
	sta.w WRMPYA
	ldx.w RDMPYL
	stx.b r1
	sty.w WRMPYB
	stz.b r2+3
	ldy.b r0+1
	ldx.w RDMPYL
	stx.b r2+1
	sty.w WRMPYB
	xba
	sta.w WRMPYA
	ldx.w RDMPYL
	stx.b r1+2
	sty.w WRMPYB
	rep #$20
	lda.b r2+1
	clc
	adc.w RDMPYL
	sta.b r2+1
	bcc .nocarry
	inc.b r2+3
.nocarry:							; r2 = r1 + r2, r2+2 = r1+2 + r2+2, return
	lda.b r1
	clc
	adc.b r2
	sta.b r2
	lda.b r1+2
	adc.b r2+2
	sta.b r2+2
	ply
	rtl
