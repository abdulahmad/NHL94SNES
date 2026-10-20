; d0 / d1 = the vector from goalie X to the puck; when he is behind his goal line ($108) and the puck is in
; front, d1 = +-1 so he faces out
GoaliePuckVector:					; called from assgoalie, assgoalietopuck
	phk								; data bank = program bank
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

.t1:								; d0 = puckx, d1 = pucky - d4
	lda.w puckx
	sta.b d0
	lda.w pucky
	sec
	sbc.b d4
	sta.b d1
.1:									; if Ypos,x >= 0 go to .4, ...
	lda.w Ypos,x
	bpl .4
	cmp.w #$FEF8
	bmi .3
	lda.w pucky
	cmp.w #$FEF8
	bmi .t1x
	rts

.t1x:								; pucky - $FEF8 negative: d1 = $0001, return
	lda.w #$0001
	sta.b d1
	rts
.2:									; pucky - $0108 >= 0: d1 = $FFFF
	lda.w #$FFFF
	sta.b d1
.3:									; return
	rts
.4:									; Ypos,x >= 0: if plus go to .3, ...
	cmp.w #$0108
	bpl .3
	lda.w pucky
	cmp.w #$0108
	bpl .2
	rts
