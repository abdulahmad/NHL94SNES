; Offsides if the player's team is flagged and the puck is past the blue line.
a2offsides:							; takes a2 = player, called from a2touchpuck
	ldy.b a2
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	bne .0
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.0:
	lda.b d0
	cmp.w #blueline
	bmi .rtl
	stz.b a0
	lda.w pfteam,y
	beq .1
	lda.w #$0002
	sta.b a0
.1:
	ldy.b a0
	lda.w tmflags,y
	bit.w #tmfoside
	beq .rtl
	lda.w gmode
	bit.w #gmhl
	bne .rtl
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #PenOffsides
	sta.b d0
	jsl.l AddPenalty
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
.rtl:
	rtl
