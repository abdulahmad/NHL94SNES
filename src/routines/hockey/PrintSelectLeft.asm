; Print the Select Left hint on the password screen.
PrintSelectLeft:					; called from PasswordRedraw, PasswordScreen
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintSelectLeftPos>>16
	sta.b a1+2
	lda.w #PrintSelectLeftPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w printx
	clc
	adc.b d4
	sta.w printx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SelectLeft>>16
	sta.b a1+2
	lda.w #SelectLeft
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
