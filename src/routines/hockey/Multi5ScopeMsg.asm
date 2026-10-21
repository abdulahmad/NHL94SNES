; Print "The MultiPlayer 5 is not designed for use with the Super NES Super Scope."
;
; Same structure as Multi5MouseMsg.
Multi5ScopeMsg:						; print the MultiPlayer 5 Super Scope warning
	lda.b a1+2						; line 1: save a1, print the text, restore a1
	pha
	lda.b a1
	pha
	lda.w #TheMultiPlayer5IsNotTxt>>16
	sta.b a1+2
	lda.w #TheMultiPlayer5IsNotTxt
	sta.b a1
	jsl.l print						; print TheMultiPlayer5IsNotTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2						; line 2: "designed for use with the"
	pha
	lda.b a1
	pha
	lda.w #DesignedForUseWithTheTxt>>16
	sta.b a1+2
	lda.w #DesignedForUseWithTheTxt
	sta.b a1
	jsl.l print						; print DesignedForUseWithTheTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2						; line 3: "Super NES Super Scope."
	pha
	lda.b a1
	pha
	lda.w #SuperNesSuperScopeTxt>>16
	sta.b a1+2
	lda.w #SuperNesSuperScopeTxt
	sta.b a1
	jsl.l print						; print SuperNesSuperScopeTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap				; show the text map
	rtl
