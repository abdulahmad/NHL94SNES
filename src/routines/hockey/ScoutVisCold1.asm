; Script code %9: the name of the visitors player 1 off his game ($1E57)
ScoutVisCold1:						; Script code %9 entry
	lda.w coldplayer1+2				; A = visitors cold player 1
	bra ScoutVisPlayer				; name him
