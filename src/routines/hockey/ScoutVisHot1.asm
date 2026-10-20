; Script code %6: the name of the visitors player 1 on a hot streak ($1E4B)
ScoutVisHot1:						; Script code %6 entry
	lda.w hotplayer1+2				; A = visitors hot player 1
	bra ScoutVisPlayer				; name him
