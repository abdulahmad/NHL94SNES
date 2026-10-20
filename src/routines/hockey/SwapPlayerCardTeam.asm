; Switch player cards to the other team.
SwapPlayerCardTeam:					; a2 = team side; called from ShowPlayerCards
	lda.b a2
	eor.w #$0002					; other team (0 <-> 2)
	sta.b a2
	stz.w curitem					; back to the first item
	jsl.l GetPlayerCount			; d0 = players of the team
	lda.b d0
	clc
	adc.w #$0006					; plus the 6 goalies / extra entries
	sta.w listend					; end of the list
	jsl.l DrawPlayerCard			; draw the first card
	jmp.w PlayerCardsRedraw			; redraw and return
