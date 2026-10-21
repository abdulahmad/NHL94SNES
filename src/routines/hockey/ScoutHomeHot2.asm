; Script code %1: the name of the home player 2 on a hot streak (hotplayer2)
ScoutHomeHot2:						; Script code %1 entry
	lda.w hotplayer2				; A = home hot player 2
	bra ScoutHomePlayer				; name him
