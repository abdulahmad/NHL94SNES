; Move the password cursor to character d5.
PlacePasswordCursor:				; called from PasswordRedraw, PasswordScreen
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlacePasswordCursorPos>>16
	sta.b a1+2
	lda.w #PlacePasswordCursorPos
	sta.b a1
	jsl.l print						; print PlacePasswordCursorPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	phx
	ldx.b d5
	lda.w #$0006
	jsl.l DivX8U					; X / A into A with the hardware divider
	plx
	asl a
	adc.w printy
	sta.w printy
	lda.w RDMPYL
	asl a
	adc.w printx
	dec a
	dec a
	sta.w printx
	lda.w #$0003
	sta.b d0
	sta.b d1
PasswordCursorRtl:					; called from BadPasswordPrompt
	rtl
