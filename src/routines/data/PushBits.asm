; password bits = password bits * d1 + d0
PushBits:
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d0
	ldx.b d1
	sta.b d1
	stx.b d0
	jsl.l SuperMult
	stz.b d0+2
	lda.b d1
	sta.b d0
	jsl.l SuperAdd
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
