; Switch the roster to the other team and redraw it.
; Toggles a2 between the two teams, redraws the sprites and prints the swap text, then jumps to
; TeamRosterRedraw.
;
; Called from TeamRosterScreen.
SwapRosterTeam:						; switch the roster to the other team
	lda.b a2
	eor.w #$0002
	sta.b a2
	jsl.l SpriteFrameStart
	ldx.b a2
	lda.w HomeTeam,x
	sta.l setupvis
	ldx.w #$004C
	ldy.w #$0018
	lda.w #TeamRosterSwap>>16
	sta.b a1+2
	lda.w #TeamRosterSwap
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites TeamRosterSwap
	jsl.l DrawMatchupPictures
	jmp.w TeamRosterRedraw			; redraw the screen for the team in a2
