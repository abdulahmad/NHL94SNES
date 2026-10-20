; Script code %3: the name of the home player 1 off his game ($1E55)
ScoutHomeCold1:						; Script code %3 entry
	lda.w coldplayer1				; A = home cold player 1
	bra ScoutHomePlayer				; name him
