; Script code %4: the name of the home player 2 off his game ($1E59)
ScoutHomeCold2:						; Script code %4 entry
	lda.w coldplayer2				; A = home cold player 2
	bra ScoutHomePlayer				; name him
