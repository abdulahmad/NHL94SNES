; Put the name of player d0 of team a2 (GetPlayerRecord) into mesarea and type it (ScoutTypeText)
ScoutPlayerName:					; A = nothing, d0 = player, a2 = team (0 home, 2 visitors), x = column to
									; restore
	phx								; save the column
	lda.b a0						; save a0
	pha
	jsl.l GetPlayerRecord			; a0 = pointer to the player record
	lda.b a0+2
	sta.b a1+2						; a1 = the record (its name string)
	lda.b a0
	sta.b a1
	lda.w #mesarea>>16				; a3 = mesarea
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002					; start a fresh string (length word 2)
	sta.b [a3]
	jsl.l appstring					; append the player name
	lda.w #mesarea>>16				; a1 = mesarea
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	pla								; restore a0
	sta.b a0
	plx								; restore the column into d0
	stx.b d0						; type the name
	jmp.w ScoutTypeText				; type the string at a1 word by word
