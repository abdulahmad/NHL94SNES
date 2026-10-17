; Show the little warning referee when a teammate is over the blue line
checkob:
	lda.w gmode
	bit.w #gmoffs
	bne .t2
	jmp.w .5

.t2:
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.w #$0005
	sta.b d0
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$000C
.1:
	sty.b a0
	lda.w #$005C
	sta.b d1
	lda.w pfgoal,x
	beq .t1
	jmp.w .7

.t1:
	lda.w #$FFA4
	sta.b d1
	sec
	sbc.w pucky
	beq .1x
	bpl .3
.1x:
	ldy.b a0
	lda.w position,y
	bmi .2
	lda.b d1
	sec
	sbc.w Ypos,y
	beq .2
	bpl .6
.2:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .1x
.3:
	lda.w #$0040
	sta.b d0
	lda.w #$8000
	trb.w sflags
	beq .4
	lda.l refwindow
	bne .4
	lda.w #$0005
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.l blankchar
	sta.b d2
	lda.w #$0002
	sta.w printx
	sta.w printy
	jsl.l eraser
.4:
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
.5:
	rtl
.6:
	lda.w #$0006
	sta.b d0
	lda.w #$8000
	tsb.w sflags
	bne .4
	lda.w RefCnt
	bpl .4
	jsl.l PushRef
	bra .4
.7:
	lda.b d1
	cmp.w pucky
	bmi .3
.loop:
	ldy.b a0
	lda.w position,y
	bmi .1xx
	lda.b d1
	cmp.w Ypos,y
	bmi .6
.1xx:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	bra .3
