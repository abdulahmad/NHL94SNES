; Script code %2: the name of the home player 3 on a hot streak (hotplayer3)
ScoutHomeHot3:						; Script code %2 entry
	lda.w hotplayer3				; A = home hot player 3
	bra ScoutHomePlayer				; name him
