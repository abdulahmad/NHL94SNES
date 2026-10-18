; d4 = the cross product of the goalie vector and the post vector from the puck
CalcAngleOffset:
	lda.b d3
	sec
	sbc.w puckx
	sta.b d3
	lda.b d4
	sec
	sbc.w pucky
	ldx.b d0
	jsl.l Mul16S
	lda.b r2+2
	sta.b d4+2
	lda.b r2
	sta.b d4
	lda.b d1
	ldx.b d3
	jsl.l Mul16S
	lda.b d4
	sec
	sbc.b r2
	sta.b r2
	lda.b d4+2
	sbc.b r2+2
	sta.b r2+2
	lda.b d2
	sta.b r1
	jsl.l Div32S
	lda.b r0
	sta.b d4
	rts
