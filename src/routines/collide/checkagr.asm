; How hard a check is, from the player's checking rating
checkagr:							; called from Bcheck, checkcheck, holdcheck
	lda.w #$0014					; $14 minus the energy left
	sec
	sbc.w GGSleft,x
	asl a
	asl a
	asl a
	asl a							; times 16
	sta.b d0
	lda.w playerpad,x
	bmi .1
	asl.b d0
.1:									; if minus go to .2, ...
	lda.w Xpos,x					; x distance
	sec
	sbc.w puckx
	cmp.w #$FFD7
	bmi .2
	cmp.w #$0029
	bpl .2
	lda.w Ypos,x					; y distance
	sec
	sbc.w pucky
	cmp.w #$FFD7
	bmi .2
	cmp.w #$0029
	bpl .2
	lsr.b d0
.2:									; go to randomd0
	jml.l randomd0
