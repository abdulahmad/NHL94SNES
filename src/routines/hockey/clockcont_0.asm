; End of a period: the winners celebrate, and the clock moves on
clockcont_0:
	ldx.w #$001C
	stx.b a3
	lda.w #$0018
	sta.b d0
	jsl.l assinsert
	lda.w #$0001
	jsl.l StreamSfx
	stz.b p0
	lda.w gsp
	cmp.w #$0002
	bcs .t1
	jmp.w .8

.t1:
	lda.w #$0008
	sta.b d0
	ldx.w #$0000
	stx.b a3
	lda.l playoffRoundIdx
	cmp.w #$0003
	bne .4
	lda.w bosgames
	cmp.w #$0007
	beq .3
	lda.l gamenum
	asl a
	sta.b a0
	tax
	stz.b d3
	lda.l gsflags,x
	bit.w #$0001
	beq .1
	lda.w #$0010
	sta.b d3
.1:
	lda.w tmscore
	cmp.w tmscore+2
	bpl .2
	lda.b d3
	eor.w #$0010
	sta.b d3
.2:
	lda.b a0
	clc
	adc.b d3
	phx
	tax
	lda.l gspotwins,x
	plx
	cmp.w #$0003
	bne .4
.3:
	lda.l OptPlayMode
	cmp.w #$0000
	beq .4
	inc.b p0
	lda.w #$0009
	sta.b d0
	lda.w #$000B
	sta.b d2
.loop:
	lda.w pflags,x
	and.w #$FFF7
	sta.w pflags,x
	inx
	inx
	dec.b d2
	bpl .loop
	ldx.w #$0000
	stx.b a3
.4:
	lda.w #$0005
	sta.b d2
	lda.w tmscore
	cmp.w tmscore+2
	beq .8
	bpl .5
	ldx.w #$000C
	stx.b a3
.5:
	lda.w position,x
	beq .6
	bmi .6
	jsl.l assinsert
	lda.w #$0008
	sta.b d0
.6:
	inx
	inx
	stx.b a3
	dec.b d2
	bpl .5
.7:
	jsl.l ClearPenaltyBuffer
	lda.l crowdlevel
	clc
	adc.w #$03E8
	sta.l crowdlevel
	lda.w #$003C
	sta.b crowdhold
	lda.w #$0040
	sta.w gmclock
	tsb.w gmode
	lda.w tmscore
	cmp.w tmscore+2
	bmi .1x
	lda.w #$0000
	sta.l crowdlevel
	lda.w #$0003
	sta.w cheercnt
	lda.b vcount
	sec
	sbc.w #$0096
	sta.w cheervc
.1x:
	lda.w #PenEOG
	sta.b d0
	jsl.l AddPenalty2
	lda.b p0
	beq .rtl
	lda.w #PenNoText3
	sta.b d0
	jsl.l AddPenalty2
.rtl:
	rtl
.8:
	lda.w gsp
	cmp.w #$0003
	bne .1xx
	lda.l OptPlayMode
	beq .7
.1xx:
	jsl.l EndPenaltyShot
	lda.w #$0002
	sta.b d0
	jml.l ShootoutWonBy
