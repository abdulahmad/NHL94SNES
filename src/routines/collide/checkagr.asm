; How hard a check is, from the player's checking rating
checkagr:
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	asl a
	asl a
	asl a
	asl a
	sta.b d0
	lda.w playerpad,x
	bmi .1
	asl.b d0
.1:
	lda.w Xpos,x
	sec
	sbc.w puckx
	cmp.w #$FFD7
	bmi .2
	cmp.w #$0029
	bpl .2
	lda.w Ypos,x
	sec
	sbc.w pucky
	cmp.w #$FFD7
	bmi .2
	cmp.w #$0029
	bpl .2
	lsr.b d0
.2:
	jml.l randomd0
