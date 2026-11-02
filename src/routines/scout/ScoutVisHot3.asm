; Script code %8: the name of the visitors player 3 on a hot streak ($1E53)
ScoutVisHot3:						; Script code %8 entry
	lda.w hotplayer3+2				; A = visitors hot player 3
	bra ScoutVisPlayer				; name him
