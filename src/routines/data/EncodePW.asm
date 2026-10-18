; After a playoff game, work out the winners and the new password
EncodePW:
	lda.l OptPlayMode
	bne .t2
	jmp.w .4

.t2:
	lda.w #$0001
	sta.l OptPlayMode
	jsl.l ResolveGames
	jsl.l maketree
	lda.l playoffRoundIdx
	cmp.w #$0004
	beq .t1
	lda.l gamenum
	bpl .1
	lda.l pojoy
	sec
	sbc.w #$0002
	bmi .3
	lda.l playoffRoundIdx
	cmp.w #$0001
	bne .3
	lda.l potreeteam
	eor.w #$0001
	sta.l potreeteam
	lda.l pojoy
	eor.w #$0001
	sta.l pojoy
.1:
	jsl.l WritePassBits
	jsl.l BitstoPW
	lda.w sflags3
	bit.w #$0004
	beq .2
	ldx.w #$000E
.loop:
	lda.l tpassbits,x
	sta.l passbits,x
	dex
	dex
	bpl .loop
	jsl.l ReadPassBits
.2:
	jml.l maketree

.t1:
	jsl.l ResetPassWord
.3:
	lda.w #$0080
	ora.l PassWord
	sta.l PassWord
	lda.w #$0002
	sta.l OptPlayMode
	lda.w bosgames
	cmp.w #$0007
	beq .4
	lda.w #$0003
	sta.l OptPlayMode
.4:
	rtl
