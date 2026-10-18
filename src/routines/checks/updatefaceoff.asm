; Step the puck drop animation
updatefaceoff:
	lda.w temp1,x
	beq .t2
	clc
	adc.w #$0006
	lsr a
	lsr a
	lsr a
	sta.b d0
	cmp.w #$0003
	bpl .rtl
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000A
	sta.b d0
	sta.l fofdata
.rtl:
	rtl

.t2:
	lda.w penshot
	bne .t1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #updatefaceoffPos>>16
	sta.b a1+2
	lda.w #updatefaceoffPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.l fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .2
.1:
	ora.w #$E000
.2:
	sta.w printx
	lda.l fodropy
	sec
	sbc.w #$0044
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .4
.3:
	ora.w #$E000
.4:
	sta.w printy
	lda.w #$000C
	sta.b d0
	inc a
	sta.b d1
	bra .5

.t1:
	lda.w #$0001
	sta.w printy
	lda.w #$0006
	sta.w printx
	lda.w #$0014
	sta.b d0
	lda.w #$0008
	sta.b d1
.5:
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	stz.w FrameCount
	stz.w gameframes
	rtl
