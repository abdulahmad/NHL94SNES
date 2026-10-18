; a1 = d0 as a decimal string, no leading zeros.
PushNumber:
	phx
	lda.w #$0000
	sta.b a1+2
	lda.w #mesareaEnd
	sta.b a1
	lda.b d0
.0:
	sta.b r2
	lda.w #$000A
	sta.b r1
	jsl.l Div16x8U
	dec.b a1
	sep #$20
	lda.w RDMPYL
	clc
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b r0
	bne .0
	dec.b a1
	dec.b a1
	lda.w #mesareaEnd
	sec
	sbc.b a1
	sta.b [a1]
	plx
	rtl
