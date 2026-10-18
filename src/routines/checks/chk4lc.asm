; Should the computer call a line change? Then shoot the puck in
chk4lc:
	lda.l OptLine
	cmp.w #$0002
	beq .t1
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .1
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1:
	lda.b d0
	bmi .t1
	sec
	sbc.w #$0058
	bpl .t1
	lda.w seed
	and.w #$0003
	bne .t1
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .2
	ldy.w #$0002
.2:
	lda.w tmflags,y
	ply
	bit.w #$0008
	bne .t1
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .3
	stz.b a1
	lda.w #$0002
	sta.b a2
.3:
	jsl.l AvgCline
	lda.b d0
	cmp.w #$0C01
	bcs .t1
	lda.w PenShotActive
	bne .t1
	lda.l OptLine
	beq .t1
	jsl.l CompLine
	jsl.l setpersonel
	jsl.l printscores1
	jml.l CompShoot

.t1:
	rtl
