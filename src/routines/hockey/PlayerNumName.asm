; mesarea = the uniform number and name of roster player d0 of team a2
PlayerNumName:						; called from DrawPlayerCard, GetNameandAttrib, GetPlayerName, PrintLin...
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	lda.b a3
	pha
	lda.b a3+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	jsl.l GetPlayerRecord			; a0 = the roster record of player d0 of team a2
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.w #mesarea
	sta.b a3
	inc a
	inc a
	sta.b a1
	lda.w #mesarea>>16
	sta.b a3+2
	sta.b a1+2
	lda.w #$0004
	sta.b [a3]
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2				; write the two digit number d0 as two characters at [a1]
	lda.w #PlayerNumNamePos>>16
	sta.b a1+2
	lda.w #PlayerNumNamePos
	sta.b a1
	jsl.l appstring					; append string [a1] to string [a3]
	pla
	sta.b a1+2
	pla
	sta.b a1
	jsl.l appstring					; append string [a1] to string [a3]
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b a3+2
	pla
	sta.b a3
	pla
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
	rtl
