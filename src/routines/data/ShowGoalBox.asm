; The goal box with the scorer and the assists
ShowGoalBox:
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave
	lda.w #$FFFF
	sta.w lcpad
	sta.w lcpad+2
	stz.b a2
	jsl.l lcfound2
	inc.b a2
	inc.b a2
	jsl.l lcfound2
	lda.w #$007E
	sta.b a4+2
	lda.w #ScoreSum-6
	clc
	adc.l ScoreSumbytes
	sta.b a4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowGoalBoxPos>>16
	sta.b a1+2
	lda.w #ShowGoalBoxPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0013
	sta.b d0
	lda.w #$0005
	sta.b d1
	ldy.w #$0004
	lda.b [a4],y
	bit.w #$0080
	bne .1
	inc.b d1
	inc.b d1
	lda.b [a4],y
	bmi .1
	inc.b d1
.1:
	jsl.l Framer
	stz.b a2
	ldy.w #$0002
	lda.b [a4],y
	bit.w #$0080
	beq .2
	inc.b a2
	inc.b a2
.2:
	lda.w #GoalBoxText>>16
	sta.b a1+2
	lda.w #GoalBoxText
	sta.b a1
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	ldy.b a2
	beq .3
	clc
	adc.w #$001A
.3:
	tay
	lda.w tmgoals,y
	and.w #$00FF
	cmp.w #$0003
	bne .4
	jsl.l GoalieCount
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	cmp.b d0
	bmi .4
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
	ldy.b a2
	bne .4
	jsl.l StartHatTrick
	lda.w Pencntdwn
	clc
	adc.w #$000A
	sta.w Pencntdwn
.4:
	jsl.l printbig
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0004
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .5
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AssistByTxt>>16
	sta.b a1+2
	lda.w #AssistByTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0005
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .5
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowGoalBoxPos2>>16
	sta.b a1+2
	lda.w #ShowGoalBoxPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PlayerShortName
	jsl.l print
.5:
	stx.b xsave
	ldx.w #$0012
.loop2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
	rtl
