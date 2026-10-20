; Print "The MultiPlayer 5 is not designed for use with the Super NES mouse."
;
; Called from PlayerSelect and setoptions. The three print calls use the same save/restore of a1.
Multi5MouseMsg:						; print the MultiPlayer 5 mouse warning
	lda.b a1+2						; line 1: save a1, print the text, restore a1
	pha
	lda.b a1
	pha
	lda.w #TheMultiPlayer5IsNotTxt2>>16
	sta.b a1+2
	lda.w #TheMultiPlayer5IsNotTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2						; line 2: "designed for use with the"
	pha
	lda.b a1
	pha
	lda.w #DesignedForUseWithTheTxt2>>16
	sta.b a1+2
	lda.w #DesignedForUseWithTheTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2						; line 3: "Super NES mouse."
	pha
	lda.b a1
	pha
	lda.w #SuperNesMouseTxt>>16
	sta.b a1+2
	lda.w #SuperNesMouseTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap				; show the text map
	rtl
