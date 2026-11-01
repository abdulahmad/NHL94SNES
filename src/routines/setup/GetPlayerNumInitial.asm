; mesarea = the number, first initial and last name of player TempPlOffset
;
; Takes TempPlOffset (player number; bit 15 set for the visitors). Saves and restores d0 and a2. Called from
; ShowInjuryBox.
GetPlayerNumInitial:				; the number, first initial and last name of player TempPlOffset
	lda.b d0						; save d0 and a2 (low and high words)
	pha
	lda.b d0+2						; save d0
	pha
	lda.b a2
	pha
	lda.b a2+2						; save a2
	pha
	stz.b a2						; a2 = team offset, home 0
	lda.w TempPlOffset				; player id
	sta.b d0
	bpl .1							; home team
	and.w #$00FF					; visitors: player number only
	sta.b d0
	inc.b a2						; a2 = 2 for the visitors
	inc.b a2
.1:									; format the number, initial and name
	jsl.l FormatPlayerNumInitial	; format the text
	pla								; restore a2 and d0
	sta.b a2+2
	pla								; restore a2
	sta.b a2
	pla
	sta.b d0+2
	pla								; restore d0
	sta.b d0
	rtl
