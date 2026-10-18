; Watch for icing: the loose puck crossing the far goal line
PuckIChk:
	lda.w iflags
	bit.w #$0004
	beq .1
	bit.w #$0001
	bne .1
	lda.w puckc
	bpl .1
	lda.w #$0108
	sta.b d0
	lda.w iflags
	bit.w #$0002
	bne .2
	lda.w #$FEF8
	sec
	sbc.w pucky
	bpl .3
.1:
	rtl
.2:
	lda.w #$0108
	sec
	sbc.w pucky
	bpl .1
.3:
	lda.w #$0001
	tsb.w iflags
	rtl
