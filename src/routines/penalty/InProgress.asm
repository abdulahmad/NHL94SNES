; The referee's work after a whistle
InProgress:
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne InProgress
	dec.b a0
	dec.b a0
	dec.b a0
	dec.b a0
	lda.b [a0]
	pha
	and.w #$7FFF
	sta.b [a0]
	pla
	bmi .t4
	lda.b [a0]
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tay
	lda.w position,y
	bmi .t1
	jmp.w InProgress_coin

.t1:
	lda.w #$0000
	sta.b [a0]
	jmp.w InProgress_coin

.t4:
	lda.b [a0]
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
	cmp.w #$D4AD
	bne .t2
	jmp.w .t3

.t2:
	cmp.w #$D434
	bne .1
	jsl.l ShowStars
.1:
	lda.b [a1]
	and.w #$00FF
	sta.b d2
	bne .t1x
	jmp.w .10

.t1x:
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave
	jsl.l GetPeriodTimeRemaining
	lda.b [a0]
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tax
	stx.b a3
	stz.b d0
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .1x
	lda.w #$8000
	sta.b d0
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w CwdExciteLvl
	clc
	adc.w #$0014
	bmi .1x
	sta.w CwdExciteLvl
.1x:
	ldy.b a2
	lda.w tmPenalties,y
	inc a
	sta.w tmPenalties,y
	lda.w tmPenmin,y
	clc
	adc.b d2
	sta.w tmPenmin,y
	lda.w pnum,x
	and.w #$00FF
	ora.b d0
	sta.w TempPlOffset
	lda.w pnum,x
	sta.b d0
	lda.b a2
	beq .2
	lda.w #$001A
.2:
	phx
	clc
	adc.b d0
	tax
	sep #$20
	lda.w ppenmin,x
	rep #$20
	and.w #$00FF
	clc
	adc.b d2
	sep #$20
	sta.w ppenmin,x
	rep #$20
	plx
	lda.w PenSumLength
	cmp.w #$0041
	bcs .4
	asl a
	asl a
	tay
	jsl.l GetPeriodTimeRemaining
	lda.b d0
	sta.w PenSum,y
	iny
	iny
	lda.w TempPlOffset
	cmp.w #$0080
	bmi .3
	ora.w #$0080
.3:
	sep #$20
	sta.w PenSum,y
	rep #$20
	iny
	lda.b [a0]
	and.w #$00FF
	sep #$20
	sta.w PenSum,y
	rep #$20
	inc.w PenSumLength
.4:
	lda.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .5
	ora.w #$FF00
.5:
	asl a
	sta.b d0
	phx
	ldx.w #$003C
	lda.b d2
	and.w #$00FF
	jsl.l Mul8U
	ora.w #$2000
	sta.b d2
	plx
	lda.b a2
	beq .6
	lda.w #$0034
.6:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .7
	and.w #$1000
	tsb.b d2
.7:
	lda.b d2
	sta.w tmpdst,y
	lda.w #$1000
	trb.b d2
	lda.b a0+2
	pha
	lda.b a0
	pha
	lda.b a2
	beq .8
	lda.w #$001A
.8:
	sta.b a0
	lda.w #$0018
	sta.b d1
.loop2:
	ldy.b a0
	inc.b a0
	lda.w tmboxlist,y
	bit.w #$0080
	bne .9
	dec.b d1
	bpl .loop2
.9:
	lda.b d0
	ora.w #$FF00
	sta.w tmboxlist,y
	pla
	sta.b a0
	pla
	sta.b a0+2
	lda.w #$000D
	sta.b d0
	jsl.l assreplace
	stx.b xsave
	ldx.w #$000E
.loop3:
	pla
	sta.b a1,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
	jsl.l SetPA
	jsl.l USBoard
	bra InProgress_coin

.t3:
	jsl.l StartPenaltyShot
.10:
	lda.w #$0000
	sta.b [a0]
	lda.w sfhormode
	beq .t1xx
	jmp.w chkprogress_find

.t1xx:
	jsl.l SetPA
	bra InProgress_coin
; InProgress: the penalties are over (chkprogress_find found none): clear gmpen, puck faceoff assignment, then
; InProgress_coin
InProgress_exit:
	lda.w #$0004
	trb.w gmode
	ldx.w #$001C
	stx.b a3
	lda.w #$001B
	sta.b d0
	jsl.l assreplace
; InProgress: coinsearch for both teams (not in a shootout), restore the registers
InProgress_coin:
	lda.w penshot
	bne .1
	stz.b a2
	jsl.l coinsearch
	lda.w #$0002
	sta.b a2
	jsl.l coinsearch
.1:
	stx.b xsave
	ldx.w #$000E
.loop:
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop
	ldx.b xsave
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
; InProgress: the rtl it leaves through
InProgress_rtl:
	rtl
