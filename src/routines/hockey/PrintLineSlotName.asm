; Print the short name of the player in line slot y (a3) centred on x at printy
PrintLineSlotName:					; called from DrawPlayerCard
	lda.b [a3],y
	and.w #$00FF
	dec a
	sta.b d0
	jsl.l PlayerShortName
	txa
	sta.b d1
	lda.b [a1]
	dec a
	dec a
	lsr a
	asl a
	asl a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.b d1
	tax
	ldy.w printy
	jsl.l PrintSmallLetterSprites
	rtl
