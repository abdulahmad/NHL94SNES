; Penalty roll for player X: random below (20 - aggress) * 16, doubled for a player on a pad, halved
; near the puck. Callers call a penalty when the result is small
checkagr:							; called from Bcheck, checkcheck, holdcheck
	lda.w #$0014					; 20 minus aggress
	sec
	sbc.w aggress,x
	asl a
	asl a
	asl a
	asl a							; times 16
	sta.b d0
	lda.w playerpad,x
	bmi .1
	asl.b d0						; doubles
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
	jml.l randomd0					; d0 = a random number from 0 to d0-1
