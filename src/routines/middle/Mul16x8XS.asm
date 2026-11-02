; X (16 bits) * A (8 bits) into $08-$0A, X signed
Mul16x8XS:							; called from TitlePathX, TitlePathY, assdumpin, asseben, assgoalie and...
	phy
	tay
	beq Mul16x8_Zero
Mul16x8XS_neg:						; called from Mul16x8S
	txa
	beq Mul16x8_Zero
	bpl Mul16x8U_go
	eor.w #$FFFF					; negate: two's complement
	inc a
Mul16x8XS_mul:						; called from Mul16x8S
	jsl.l Mul16x8U_Pre				; Mul16x8U from its second step, with Y saved
Mul16x8XS_negres:					; called from Mul16XS_Neg
	lda.w #$0000
	sec
	sbc.b r2
	sta.b r2
	lda.w #$0000
	sbc.b r2+2
	sta.b r2+2
	ply
	rtl
