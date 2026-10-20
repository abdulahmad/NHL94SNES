; Script code %7: the name of the visitors player 2 on a hot streak ($1E4F)
ScoutVisHot2:						; Script code %7 entry
	lda.w hotplayer2+2				; A = visitors hot player 2
	bra ScoutVisPlayer				; name him
