; For each of the 16 objects: puckdist2 (about (dx^2 + dy^2) / 4), puckdist (ApproxLength) and puckdir (vtoa)
; to the puck
CalcPuckDistances:
	ldx.w #$0000
.loop:
	stx.b curobj
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	bpl .1
	eor.w #$FFFF
	inc a
.1:
	pha
	lsr a
	lsr a
	tax
	jsl.l Mul8U
	ldx.b curobj
	sta.w puckdist2,x
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	bpl .2
	eor.w #$FFFF
	inc a
.2:
	pha
	lsr a
	lsr a
	tax
	jsl.l Mul8U
	ldx.b curobj
	clc
	adc.w puckdist2,x
	sta.w puckdist2,x
	ply
	pla
	jsl.l ApproxLength_abs
	ldx.b curobj
	sta.w puckdist,x
	jsl.l vtoa
	sta.w puckdir,x
	inx
	inx
	cpx.w #$0020
	bne .loop
	rtl
