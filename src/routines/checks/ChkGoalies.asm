; A computer team pulls its goalie on a delayed penalty, or late in a game it trails
ChkGoalies:
	lda.w gmclock
	bne rtss
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l .1
	stz.b a1
	lda.w #$0002
	sta.b a2
.1:
	ldy.b a2
	lda.w tmgoalie,y
	bmi rtss
	ldx.w tmsort,y
	ldy.w puckc
	bmi rtss
	lda.w pfteam,y
	cmp.w pfteam,x
	bne rtss
	ldy.b a2
	lda.w gmode
	bit.w #$0008
	bne .t1
	lda.w teampads,y
	bne rtss
	lda.w pucky
	sta.b d1
	jsl.l CPgoalie
	rtl

.t1:
	lda.w tmgoalie,y
	ora.w #$FF00
	sta.w tmgoalie,y
	jsl.l setpersonel
rtss:
	rtl
