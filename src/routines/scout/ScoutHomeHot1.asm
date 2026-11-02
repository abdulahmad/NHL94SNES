; Script code %0: the name of the home player 1 on a hot streak (hotplayer1)
ScoutHomeHot1:						; Script code %0 entry
	lda.w hotplayer1				; A = home hot player 1
	bra ScoutHomePlayer				; name him
