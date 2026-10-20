; Script code %a: the name of the visitors player 2 off his game ($1E5B)
ScoutVisCold2:						; Script code %a entry
	lda.w coldplayer2+2				; A = visitors cold player 2
	bra ScoutVisPlayer				; name him
