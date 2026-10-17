; d0 / d1 = the vector from goalie X to the puck; when he is behind his goal line ($108) and the puck is in
; front, d1 = +-1 so he faces out
GoaliePuckVector:
	phk
	plb
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .1

.t1:
	lda.w puckx
	sta.b d0
	lda.w pucky
	sec
	sbc.b d4
	sta.b d1
.1:
	lda.w Ypos,x
	bpl .4
	cmp.w #$FEF8
	bmi .3
	lda.w pucky
	cmp.w #$FEF8
	bmi .t1x
	rts

.t1x:
	lda.w #$0001
	sta.b d1
	rts
.2:
	lda.w #$FFFF
	sta.b d1
.3:
	rts
.4:
	cmp.w #$0108
	bpl .3
	lda.w pucky
	cmp.w #$0108
	bpl .2
	rts
