; Copy the two team colours of the card's team (home colours $67-$68, visitors $77-$78) to colours $4E-$4F of
; the $7F7500 palette
SetCardTeamColours:
	ldx.w #$00CE
	lda.b a2
	bne .1
	ldx.w #$00EE
.1:
	lda.l colourbuf,x
	sta.l colourbuf+$9C
	inx
	inx
	lda.l colourbuf,x
	sta.l colourbuf+$9E
	rtl
