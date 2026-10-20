; Name player A of the visitors (ScoutPlayerName)
ScoutVisPlayer:						; A = player number, visitors side
	ldx.b d0						; x = column (d0, restored by ScoutPlayerName)
	sta.b d0						; d0 = player number
	lda.w #$0002					; team 2 (visitors)
	sta.b a2						; a2 = team
	bra ScoutPlayerName				; type the name
