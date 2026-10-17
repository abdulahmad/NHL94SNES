; Look for a new penalty call and stop play when it should be called
checkfornewpen:
	lda.w sfhormode
	beq .t1
	jmp.w .6

.t1:
	lda.w #PenBuf
	sta.b a0
.4:
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #$0034
	beq .4
	tay
	bne .t2
	jmp.w .6

.t2:
	lda.w gmode
	bit.w #gmpen
	bne .3
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	beq .2
	lda.w puckc
	bmi .7
	lsr a
	sec
	sbc.w #$0006
	sta.b d0
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:
	sec
	sbc.w #$0006
	eor.b d0
	bmi .7
.2:
	jsl.l Stop4Pen
.3:
	dec.b a0
	lda.b (a0)
	tay
	ora.w #$0080
	sta.b (a0)
	inc.b a0
	tya
	bit.w #$0080
	beq .t1x
	jmp.w .4

.t1x:
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.w #$0001
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	sec
	sbc.w Pencntdwn
	beq .5
	bmi .5
	lda.b d1
	sta.w Pencntdwn
.5:
	jmp.w .4
.6:
	rtl
.7:
	lda.w #$0008
	tsb.w gmode
	bne .5
	lda.w #$0030
	sta.b d0
	jsl.l SetPA
	jmp.w .4
