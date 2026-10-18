; d0 = the line for line choice d0 of team a2, by the man advantage. -1 = none.
getlchoice:
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a2
	eor.w #$0002
	tay
	lda.w tmap,y
	ldy.b a2
	sec
	sbc.w tmap,y
	sta.b d2
	beq .1
	lda.b d0
	clc
	adc.w #$0015
	sta.b d0
	lda.b d2
	bmi .1
	lda.b d0
	clc
	adc.w #$0015
	sta.b d0
.1:
	ldy.b a2
	lda.w tmline,y
	sta.b d1
	lda.b d0
	clc
	adc.b d1
	clc
	adc.b d1
	clc
	adc.b d1
	sta.b d0
	tay
	lda.w #$009F
	sta.b a0+2
	lda.w #.tab
	sta.b a0
	lda.b [a0],y
	and.w #$00FF
	bit.w #$0080
	beq .sext
	ora.w #$FF00
.sext:
	sta.b d0
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	rtl
.tab:
	db $00,$01,$02,$01,$02,$00,$02,$00,$01,$00,$01,$02,$00,$01,$02,$00
	db $01,$02,$00,$01,$02,$03,$04,$FF,$03,$04,$FF,$03,$04,$FF,$03,$04
	db $FF,$04,$03,$FF,$03,$04,$FF,$03,$04,$FF,$05,$06,$FF,$05,$06,$FF
	db $05,$06,$FF,$05,$06,$FF,$05,$06,$FF,$05,$06,$FF,$06,$05,$FF
