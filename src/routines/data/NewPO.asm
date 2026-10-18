; Start new playoffs and build the tree
NewPO:
	jsl.l RandomWord
	and.w #$001F
	sta.b d0
.loop:
	lda.b d0
	inc a
	and.w #$001F
	sta.b d0
	asl a
	asl a
	asl a
	asl a
	adc.w #$ED59
	sta.b a0
	lda.w #$009C
	sta.b a0+2
	lda.w #$000F
	sta.b d1
	lda.l OptTeam1
	sta.b d2
	cmp.w #$001A
	bcc .1
	lda.w #$0019
	sta.b d2
.1:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.b d2
	beq .t1
	dec.b d1
	bpl .1
	bra .loop

.t1:
	lda.b d1
	eor.w #$000F
	sta.b d1
	sta.l potreeteam
	lda.b d0
	sta.l postarts
	lda.w #$0000
	sta.l playoffRoundIdx
	lda.w #$0007
	sta.w bosgames
	lda.l OptPlayMode
	cmp.w #$0002
	beq .1x
	stz.w bosgames
	lda.w #$0007
	sta.b d0
	ldx.w #$0000
	txa
.loopx:
	sta.l gspotwins,x
	sta.l gspobwins,x
	inx
	inx
	dec.b d0
	bpl .loopx
.1x:
	jml.l maketree
