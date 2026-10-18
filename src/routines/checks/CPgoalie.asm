; Should the computer pull its goalie in the last minute of the third period when it is behind
CPgoalie:
	lda.w gsp
	cmp.w #$0002
	bne .t1
	ldy.b a1
	lda.w tmscore,y
	ldy.b a2
	sec
	sbc.w tmscore,y
	bmi .t1
	beq .t1
	cmp.w #$0003
	bcs .t1
	lda.w gameclock
	cmp.w #$003D
	bcs .t1
	lda.w tmsort,y
	tay
	lda.w pfgoal,y
	bne .1
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1:
	lda.b d1
	bmi .t1
	ldy.b a2
	lda.w tmgoalie,y
	ora.w #$FF00
	sta.w tmgoalie,y
	jml.l setpersonel

.t1:
	rtl
