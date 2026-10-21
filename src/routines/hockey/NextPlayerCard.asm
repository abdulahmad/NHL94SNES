; Show the next player card.
;
; Takes a2 = team. Called from ShowPlayerCards.
NextPlayerCard:						; show the next player card
	lda.w curitem					; already at the last card: wait for the pad again
	cmp.w listend
	bpl PlayerCardsWait
	inc.w curitem					; curitem + 1; items below 7 are the fixed cards, no player to look up
	lda.w curitem
	sec
	sbc.w #$0007
	bmi .1
	sta.w curplayer					; curplayer = curitem - 7; a3 = the 6 bytes of the team data at +$C
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$000C
	clc
	adc.b [a3],y
	sta.b a3
.loop:								; next player number
	inc.w curplayer					; .loop: next player number
	ldy.w #$0000
.loop2:								; is it one of those 6 bytes? then take the next one
	lda.b [a3],y
	and.w #$00FF
	cmp.w curplayer
	beq .loop
	iny
	cpy.w #$0006
	bmi .loop2
	dec.w curplayer					; first player not in the list: curitem = curplayer + 7
	lda.w curplayer
	clc
	adc.w #$0007
	sta.w curitem
.1:									; draw the card
	jsl.l DrawPlayerCard			; draw the card and redraw the screen
	jmp.w PlayerCardsRedraw
