; mesarea = the number, first initial and last name of player TempPlOffset
GetPlayerNumInitial:
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	stz.b a2
	lda.w TempPlOffset
	sta.b d0
	bpl .1
	and.w #$00FF
	sta.b d0
	inc.b a2
	inc.b a2
.1:
	jsl.l PlayerShortName
	pla
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
