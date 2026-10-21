; Print the password screen keys: Select, A Next, Y Back, Press start
PrintPasswordHelp:					; called from BadPasswordPrompt, PasswordRedraw
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SelectTxt>>16
	sta.b a1+2
	lda.w #SelectTxt
	sta.b a1
	jsl.l print						; print SelectTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ANextTxt>>16
	sta.b a1+2
	lda.w #ANextTxt
	sta.b a1
	jsl.l print						; print ANextTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #YBackTxt>>16
	sta.b a1+2
	lda.w #YBackTxt
	sta.b a1
	jsl.l print						; print YBackTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PressStartTxt>>16
	sta.b a1+2
	lda.w #PressStartTxt
	sta.b a1
	jsl.l print						; print PressStartTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	rts
