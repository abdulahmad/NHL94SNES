; Record the played playoff game and the series wins
ResolveGames:
	lda.l gamenum
	asl a
	sta.b d0
	stz.b a0
	tax
	lda.w tmscore
	sta.l gss1,x
	lda.w tmscore+2
	sta.l gss2,x
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	lda.w bosgames
	cmp.w #$0007
	bne .4
	jmp.w .9
.4:
	ldx.b a0
	lda.w #$0004
	cmp.l gspotwins,x
	beq .3
	cmp.l gspobwins,x
	beq .3
	stz.b d3
	lda.l gsflags,x
	bit.w #$0001
	beq .1
	lda.w #$0010
	sta.b d3
.1:
	lda.l gss1,x
	cmp.l gss2,x
	bpl .2
	lda.b d3
	eor.w #$0010
	sta.b d3
.2:
	lda.b a0
	clc
	adc.b d3
	tax
	lda.l gspotwins,x
	inc a
	sta.l gspotwins,x
.3:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .4
	inc.w bosgames
	lda.w bosgames
	cmp.w #$0007
	bne .t3
	jmp.w .7

.t3:
	lda.l gamenum
	asl a
	sta.b a0
	tax
	lda.w #$0004
	cmp.l gspotwins,x
	beq .t1
	cmp.l gspobwins,x
	beq .t1
	jmp.w .8

.t1:
	lda.l playoffRoundIdx
	sec
	sbc.w #$0003
	bmi .t2
	bvs .5
	bra .7

.t2:
	bvs .7
.5:
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.6:
	ldx.b a0
	lda.b d1
	cmp.l gamenum
	beq .t1x
	lda.w #$0004
	cmp.l gspotwins,x
	beq .t1x
	cmp.l gspobwins,x
	beq .t1x
	lda.l gspotwins,x
	inc a
	sta.l gspotwins,x
	jsl.l RandomWord
	lsr a
	bcc .6
	lda.l gspotwins,x
	dec a
	sta.l gspotwins,x
	lda.l gspobwins,x
	inc a
	sta.l gspobwins,x
	bra .6

.t1x:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .6
	jsl.l WritePassBits
	ldx.w #$000E
.loop:
	lda.l passbits,x
	sta.l tpassbits,x
	dex
	dex
	bpl .loop
	lda.w #$0004
	tsb.w sflags3
.7:
	stz.w bosgames
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	stz.b d3
.loopx:
	ldx.b a0
	lda.l gspotwins,x
	cmp.w #$0004
	beq .1x
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.1x:
	lda.b a0
	lda.w #$0000
	sta.l gspotwins,x
	sta.l gspobwins,x
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loopx
	lda.b d2
	asl a
	tax
	lda.l BitMaskTable,x
	tax
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	jsl.l Mul16U
	lda.b r2
	tsb.w WinBits
	lda.l playoffRoundIdx
	inc a
	sta.l playoffRoundIdx
.8:
	rtl
.9:
	stz.b d3
.loopxx:
	ldx.b a0
	lda.l gss2,x
	cmp.l gss1,x
	bcc .1xx
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.1xx:
	ldx.b a0
	lda.l gsflags,x
	bit.w #$0001
	beq .2x
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	eor.b d3
	sta.b d3
.2x:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loopxx
	lda.b d2
	asl a
	tax
	lda.l BitMaskTable,x
	tax
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	jsl.l Mul16U
	lda.b r2
	tsb.w WinBits
	lda.l playoffRoundIdx
	inc a
	sta.l playoffRoundIdx
	rtl
