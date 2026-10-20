; Script code %b: the name of the visitors player 3 off his game ($1E5F)
ScoutVisCold3:						; Script code %b entry
	lda.w coldplayer3+2				; A = visitors cold player 3
	bra ScoutVisPlayer				; name him
