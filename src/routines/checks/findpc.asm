; When and where the puck will cross each goal line
findpc:
	stx.b xsave						; keep X
	ldx.w #$0000					; save d0 through d4
.loop:								; save d0 and the words after it (10 words)
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave
	lda.w #$0008
	sta.b r0
	ldy.w puckc
	bmi .9
	lda.w position,x
	beq .t1
	lda.w playerpad,x
	bmi .t1
	lda.w pfalock,x
	bne .t1
	lda.w puckdist2,x
	cmp.w #$0064
	bcs .t1
	jmp.w .10

.t1:
	lda.w playerpad,y
	bmi .1
	tay
	lda.w padside,y
	cmp.w padside,x
	beq .9
.1:
	ldy.w #$0000
	lda.w pfgoal,x
	bne .2
	ldy.w #$0004
.2:
	sty.b r0
.9:
	lda.w #$0006
	sta.b d1
	ldy.b d4
	lda.w #$FFFF
	sta.b d2
	ldx.w #$0000
	lda.w cont1team,y
	cmp.w #$0001
	beq .1x
	ldx.w #$000C
.1x:
	lda.w position,x
	bmi .8
	beq .8
	lda.w pflags,x
	bit.w #$1000
	bne .8
	lda.w SPA,x
	cmp.w #SPAturnl
	bcc .2x
	cmp.w #$EBE3
	bcc .4
.2x:
	cmp.w #SPAcrosscheck
	bcc .3
	cmp.w #$F343
	bcc .4
.3:
	lda.w pflags,x
	and.w #$1000
	ora.w pfalock,x
	bne .8
.4:
	lda.w playerpad,x
	bmi .5
	cmp.b d4
	bne .8
.5:
	stz.b r3
	lda.w puckc
	bmi .7
	lda.b r0
	cmp.w #$0008
	beq .7
	eor.w puckdir,x
	cmp.w #$0004
	bcc .6
	eor.w #$FFFF
	adc.w #$0008
.6:
	cmp.w #$0000
	beq .7
	dec a
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b r3
	sta.b r3
.7:
	lda.w puckdist,x
	clc
	adc.b r3
	bcs .8
	cmp.b d2
	bcs .8
	stx.b d3
	sta.b d2
.8:
	inx
	inx
	dec.b d1
	bne .1x
	ldx.b a3
	lda.b d2
	cmp.w #$FFFF
	beq .12
	ldy.b d4
	lda.b d3
	cmp.w c1playernum,y
	bne .11
.10:
	lda.w pfalock,x
	bne .12
	lda.b d4
	pha
	lda.b d4+2
	pha
	lda.b d5
	pha
	lda.b d5+2
	pha
	lda.b d6
	pha
	lda.b d6+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	jsl.l Sweepcheck
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d6+2
	pla
	sta.b d6
	pla
	sta.b d5+2
	pla
	sta.b d5
	pla
	sta.b d4+2
	pla
	sta.b d4
	bra .12
.11:
	sta.b d0
	jsl.l AssignPadPlayer
.12:
	stx.b xsave
	ldx.w #$000E
.loopx:								; pull d0-d4 back
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	rtl
