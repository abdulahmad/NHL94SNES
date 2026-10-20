; X * A (low byte) / 256 into A and $09, unsigned
Mul16x8HiU:							; entry point, no direct callers found
	phy
	tay
	beq Mul16x8Hi_Zero
	txa
	beq Mul16x8Hi_Zero
Mul16x8HiU_Go:						; called from Mul16x8HiS, Mul16x8HiU_Pre, Mul16x8HiXS_TestX
	sep #$20
	sta.w WRMPYA
	sty.w WRMPYB
	stz.b r2+2
	xba
	sta.w WRMPYA
	lda.w RDMPYH
	sta.b r2+1
	sty.w WRMPYB
	rep #$20
	lda.b r2+1
	clc
	adc.w RDMPYL
	sta.b r2+1
	ply
	rtl
