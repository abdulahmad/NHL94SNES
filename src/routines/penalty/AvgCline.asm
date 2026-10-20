; d0 = the average energy of team a2's current line
AvgCline:							; called from chk4lc
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b d3
	pha
	lda.b d3+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	stz.b d0
	stz.b d1
	lda.w #$0005
	sta.b d2
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.loop:								; loop: if position,y = 0 go to .2, ...
	ldy.b a0
	lda.w position,y
	beq .2
	bmi .2
	lda.w pnum,y
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .1
	lda.w #$0034
.1:									; adc d3, d0 = tmpde,y + d0, increment d1
	adc.b d3
	tay
	lda.w tmpde,y
	adc.b d0
	sta.b d0
	inc.b d1
.2:									; increment a0, increment a0, decrement d2, ...
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .loop
	lda.b d1
	beq .3
	sta.b r1
	phx
	lda.b d0
	sta.b r2
	jsl.l Div16U
	lda.b r0
	sta.b d0
	plx
.3:									; a0+2 = pulled value, a0 = pulled value, d3+2 = pulled value, ...
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d3+2
	pla
	sta.b d3
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	rtl
