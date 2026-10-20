; Name player A of the home team (ScoutPlayerName)
ScoutHomePlayer:					; A = player number, home side
	ldx.b d0						; x = column (d0, restored by ScoutPlayerName)
	sta.b d0						; d0 = player number
	stz.b a2						; a2 = team 0 (home)
	bra ScoutPlayerName				; type the name
