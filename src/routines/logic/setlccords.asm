; printx / printy and the size of team a2's line change box
setlccords:
	stz.b d0
	lda.b a2
	bne .1
	inc.b d0
.1:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #setlccordsPos>>16
	sta.b a1+2
	lda.w #setlccordsPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w gmode
	bit.w #gmdir
	beq .2
	lda.b d0
	eor.w #$0001
	sta.b d0
.2:
	phx
	lda.w #$0015
	ldx.b d0
	jsl.l Mul8U
	plx
	adc.w printy
	sta.w printy
	lda.w #$0002
	sta.b d0
	jsl.l getlchoice
	lda.w #$0006
	sta.b d1
	lda.b d0
	bpl .3
	dec.b d1
	inc.w printy
.3:
	lda.w #$000C
	sta.b d0
	rtl
