; Divides.
; $08 / $04 into $00, signed
Div16S:								; called from TitlePathScale, TitlePathY
	lda.b r1
	bmi .divneg
	lda.b r2
	bmi .dividendneg
	jmp.w Div16U
.divneg:							; r1 negative: eor #$FFFF, increment a, r1 = A, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b r1
	lda.b r2
	bpl .negate
	lda.w #$0000
	sec
	sbc.b r2
	sta.b r2
	jmp.w Div16U
.dividendneg:						; r2 negative: eor #$FFFF, increment a, r2 = A
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b r2
.negate:							; call Div16U, r0 = $0000 - r0, return
	jsl.l Div16U
	lda.w #$0000
	sec
	sbc.b r0
	sta.b r0
	rtl
