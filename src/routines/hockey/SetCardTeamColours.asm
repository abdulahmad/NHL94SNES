; Copy the two team colours of the card's team (home colours $67-$68, visitors $77-$78) to colours $4E-$4F of
; the colourbuf palette
SetCardTeamColours:					; a2 = team side (0 home); returns nothing; called from DrawPlayerCard
	ldx.w #$00CE					; home colours
	lda.b a2						; home?
	bne .1							; no, visitors
	ldx.w #$00EE					; visitors colours
.1:									; copy two colours
	lda.l colourbuf,x				; first colour
	sta.l colourbuf+$9C				; colour $4E
	inx								; next colour
	inx
	lda.l colourbuf,x
	sta.l colourbuf+$9E				; colour $4F
	rtl
