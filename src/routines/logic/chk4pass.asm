; A computer player looks for a good pass
chk4pass:
	lda.w threat
	bne .1
	lda.w #$0010
	clc
	adc.w spodds,x
	jsl.l randoma8
	cmp.w #$0009
	bcs .4
.1:
	lda.w #$0006
	jsl.l randoma8
	sta.b d0
	cpx.w #$000C
	bcc .2
	clc
	adc.w #$0006
	sta.b d0
.2:
	lda.w position,x
	beq .3
	lda.w puckx
	cmp.w #$FFD7
	bmi .3
	cmp.w #$0029
	bpl .3
	lda.w pucky
	cmp.w #$FF33
	bmi .4
	cmp.w #$00CD
	bpl .4
.3:
	asl.b d0
	cpx.b d0
	bne .6
.4:
	rtl
.6:
	ldy.b d0
	sty.b a0
	lda.w position,y
	beq .4
	bmi .4
	lda.w pflags,y
	and.w #$1000
	ora.w pfalock,y
	bne .4
	lda.w Ypos,y
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	lda.w pfgoal,x
	bne .1x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1x:
	lda.w gmode
	bit.w #gmoffs
	beq .2x
	lda.b d0
	sec
	sbc.w #$0058
	sta.b tmp0
	lda.b d1
	sec
	sbc.w #$0058
	eor.b tmp0
	bmi .4
.2x:
	lda.b d0
	cmp.w #$0058
	bpl .3x
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	cmp.w #$FFF1
	bmi .t1
.3x:
	lda.w puckdir,y
	sec
	sbc.w #$0004
	and.w #$0007
	sta.w passdir
	lda.w puckdist2,y
	sta.b d2
	lda.w #$0005
	sta.b d3
	ldy.w #$0000
	stz.b a1
	cpx.w #$000C
	bcs .4x
	ldy.w #$000C
.4x:
	lda.b d2
	cmp.w puckdist2,y
	bcc .5
	lda.w puckdir,y
	sec
	sbc.w #$0004
	and.w #$0007
	cmp.w passdir
	beq .t1
.5:
	iny
	iny
	dec.b d3
	bpl .4x
	jsl.l dopass
	lda.w position,x
	beq .t1
	pla
	sep #$20
	pla
	rep #$30
	jmp.w assexit

.t1:
	rtl
