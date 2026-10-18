; Call penalty d0 on player X without the checks
AddPenalty2:
	lda.w sfhormode
	beq .t2
	jmp.w .5

.t2:
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b d0
	cmp.w #PenGoal
	bne .1
.1:
	sec
	sbc.w #PenGoal
	bmi .3
	lda.l crowdlevel
	clc
	adc.w #$00C8
	sta.l crowdlevel
	lda.w #$002D
	sta.b crowdhold
	lda.w pfteam,x
	beq .3
	lda.l crowdlevel
	sec
	sbc.w #$00C8
	bcs .2
	lda.w #$0000
.2:
	sta.l crowdlevel
.3:
	lda.w #PenBuf>>16
	sta.b a1+2
	lda.w #PenBuf
	sta.b a1
	lda.w #$001F
	sta.b d1
.loop:
	lda.b [a1]
	inc.b a1
	inc.b a1
	and.w #$00FF
	cmp.w #$0034
	beq .loop
	tay
	beq .t1
	dec.b d1
	bpl .loop
	bra .4

.t1:
	dec.b a1
	dec.b a1
	txa
	lsr a
	xba
	and.w #$FF00
	ora.b d0
	sta.b [a1]
	lda.w #PenaltyList>>16
	sta.b a0+2
	lda.w #PenaltyList
	sta.b a0
	ldy.b d0
	clc
	adc.b [a0],y
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	beq .4
	lda.w pflags,x
	pha
	ora.w #$4000
	sta.w pflags,x
	pla
	bit.w #$4000
	beq .4
	lda.w #$0000
	sta.b [a1]
.4:
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
.5:
	rtl
