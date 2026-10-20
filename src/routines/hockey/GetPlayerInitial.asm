; mesarea = the first initial and last name of player TempPlOffset (PlayerInitialName); no caller
GetPlayerInitial:					; mesarea = first initial and last name of player TempPlOffset
	lda.b d0						; save d0 and a2 (4 words)
	pha
	lda.b d0+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	stz.b a2						; a2 = 0 (home); bit 15 of TempPlOffset set means a visitor player
	lda.w TempPlOffset
	sta.b d0
	bpl .home
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b a2
.home:								; build the name through PlayerInitialName
	jsl.l PlayerInitialName			; build the name through PlayerInitialName
	pla								; restore the registers
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
